from Utils import (
    download_image,
    make_dir,
    chrome_driver,
    find_price,
    find_content_between_space_and_parenthesis,
)
import os
import re
from datetime import datetime
from pathlib import Path
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.webdriver import WebDriver
from typing import List
import time

from models.item import Item

"""
这是一个从chiikawa fujitv eshop上下载商品图的脚本
"""


def find_item_info(driver: WebDriver):
    item_info = driver.find_element(By.CLASS_NAME, "FS2_itemlayout_td_Right")
    item_name = item_info.find_element(By.CSS_SELECTOR, "a").text
    item_price = find_price(item_info.find_element(By.CLASS_NAME, "itemPrice").text)
    series = find_content_between_space_and_parenthesis(item_name)
    return Item(
        item_code=item_code,
        item_name=item_name,
        item_type="",
        series=series,
        price=price,
    )


def download_image_from_urls(urls: List[str]) -> bool:
    base_save_path = r"G:\home_share\A淘宝上货"

    date_str = datetime.now().strftime("%Y%m%d")
    try:
        save_path = f"{base_save_path}\{date_str}"
        if not (path := Path(save_path)).exists():
            path.mkdir()

        driver = chrome_driver(headless=True)

        for url in urls:
            driver.get(url)
            items = driver.find_elements(
                By.CSS_SELECTOR, ".FS2_GroupLayout .groupLayout .alignItem_04 gl_Item"
            )

            image_srcs = [img.get_attribute("src") for img in images]

            for img_url in image_srcs:
                print(f"image url before:{img_url}")

                img_url = img_url.replace("thumbnail", "1")
                print(f"image url after:{img_url}")
                name = os.path.basename(img_url.split(".jpg")[0])
                download_image(img_url, f"{save_path}/{name}.jpg")
        return "Download success"
    except Exception as e:
        print(f"Exception occured: {e}")


if __name__ == "__main__":
    urls = [
        "https://eshop.fujitv.co.jp/fs/fujitv/c/B007088/1/1",
        "https://eshop.fujitv.co.jp/fs/fujitv/c/B007088/1/2",
    ]
    download_image_from_urls(urls)
