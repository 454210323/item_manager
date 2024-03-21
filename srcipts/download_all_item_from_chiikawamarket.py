from Utils import (
    chrome_driver,
    download_image,
    find_content_between_spaces_regex,
    find_price,
    find_image_src,
)
from selenium.webdriver.chrome.webdriver import WebDriver
from selenium.webdriver.common.by import By
import re
from base import Session
from item import Item
from tqdm import tqdm
from pathlib import Path

base_url = "https://chiikawamarket.jp/collections/all?page={page_num}"
save_path = "download"


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
                if item and Path(f"{save_path}/{name}").exists():
                    continue

                item_name = item_element.find_element(
                    By.CLASS_NAME, "product_name"
                ).text
                series = find_content_between_spaces_regex(item_name)
                price = find_price(
                    item_element.find_element(By.CLASS_NAME, "product_price").text
                )

                name = f"{item_code}.jpg"
                if not Path(f"{save_path}/{name}").exists():
                    image_srcset = item_element.find_element(
                        By.CSS_SELECTOR, ".image--container img"
                    ).get_attribute("data-srcset")
                    img_src = find_image_src(image_srcset)
                    download_image(img_src, f"{save_path}/{name}")
                item = Item(
                    item_id=item_code,
                    item_code=item_code,
                    item_name=item_name,
                    item_type="",
                    series=series,
                    price=price,
                )
            except Exception as e:
                with open("error_item.txt", "a", encoding="utf-8") as f:
                    f.write(f"{item_code}\n")
                    continue
            item_list.append(item)
        if item_list:
            session.add_all(item_list)
            session.commit()
        session.close()
    driver.quit()


if __name__ == "__main__":
    find_all_items()
