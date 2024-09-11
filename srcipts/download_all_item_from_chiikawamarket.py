from io import BytesIO
from Utils import (
    chrome_driver,
    download_image,
    find_content_between_spaces_regex,
    find_price,
    find_image_src,
    upload_image_to_server,
)
from selenium.webdriver.chrome.webdriver import WebDriver
from selenium.webdriver.common.by import By
import re
from base import Session
from models.item import Item
from tqdm import tqdm
from pathlib import Path
from urls import (
    chiikawamarket_all_items_url,
    naganomarket_all_items_url,
    chiikawamarket_new_items_url,
    naganomarket_new_items_url,
)
import requests
from azure.storage.blob import ContainerClient, ContentSettings


base_url = chiikawamarket_new_items_url
resource_url = "http://192.168.0.126:5001/static/images/"

upload_image_endpoint = "http://192.168.0.126:5001/fetch_chikawa_online_store_image"
save_path = (
    r"C:\Users\wuqipeng\Desktop\work\flutter_application\static_resource\static\images"
)
AZURE_STORAGE_BLOB_URL = "https://www233.blob.core.windows.net/chiikawa-item-images?sp=racwd&st=2024-07-28T16:21:34Z&se=2025-07-29T00:21:34Z&spr=https&sv=2022-11-02&sr=c&sig=5mkQsDSfHbX8garB4WIYa2BURWfRSidbcNHcSMrLRtk%3D"


def find_all_items():
    driver = chrome_driver(headless=True)
    driver.get(base_url.format(page_num=1))
    pages = driver.find_elements(By.CLASS_NAME, "pagination--number")

    max_page = int(pages[-1].text)
    for page_num in tqdm(range(1, max_page + 1)):
        driver.get(base_url.format(page_num=page_num))
        item_elements = driver.find_elements(By.CLASS_NAME, "product--root")
        item_list = []
        session = Session()
        for i, item_element in enumerate(item_elements):
            print(f"{page_num} page, {i} item")
            print("--------------------")
            try:
                link = item_element.find_element(By.TAG_NAME, "a").get_attribute("href")
                item_code = link.split("/")[-1]
                item = session.query(Item).get(item_code)
                image_name = f"{item_code}.jpg"

                item_name = item_element.find_element(
                    By.CLASS_NAME, "product_name"
                ).text
                series = find_content_between_spaces_regex(item_name)
                price = find_price(
                    item_element.find_element(By.CLASS_NAME, "product_price").text
                )
                if item_code == "4582662953581":
                    pass
                img_elements = item_element.find_elements(
                    By.CSS_SELECTOR, ".product--image img"
                )
                for img_element in img_elements:
                    image_srcset = img_element.get_attribute("data-srcset")
                    if image_srcset:
                        img_src = find_image_src(image_srcset)
                        break
                    image_srcset = img_element.get_attribute("srcset")
                    if image_srcset:
                        img_src = find_image_src(image_srcset)
                        break

                    img_src = img_element.get_attribute("src")
                    break

                if not item:
                    item = Item(
                        item_code=item_code,
                        item_name=item_name,
                        item_type="",
                        series=series,
                        price=price,
                    )
                    item_list.append(item)

                    # 下载图片
                    response = requests.get(img_src)
                    image_data = BytesIO(response.content)

                    container_client = ContainerClient(
                        account_url=AZURE_STORAGE_BLOB_URL,
                        container_name="chiikawa-item-images",
                    )
                    # 根据文件后缀确定 content_type
                    content_type = "image/jpeg"

                    content_settings = ContentSettings(
                        content_type=content_type, content_disposition="inline"
                    )

                    container_client.upload_blob(
                        name=image_name,
                        data=image_data,
                        blob_type="BlockBlob",
                        overwrite=True,
                        content_settings=content_settings,
                    )

            except Exception as e:
                print(e)
                with open("error_item.txt", "a", encoding="utf-8") as f:
                    f.write(f"{item_code}\n")
                    continue
        if item_list:
            session.add_all(item_list)
            session.commit()
        session.close()
    driver.quit()


if __name__ == "__main__":
    find_all_items()
