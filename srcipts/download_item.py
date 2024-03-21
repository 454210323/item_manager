from Utils import (
    chrome_driver,
    download_image,
    find_content_between_spaces_regex,
    find_price,
    find_image_src,
    replace_last_occurrence,
)
from selenium.webdriver.chrome.webdriver import WebDriver
from selenium.webdriver.common.by import By
import re
from base import Session
from item import Item
from tqdm import tqdm
from pathlib import Path

base_url = "https://chiikawamarket.jp/collections/all/products/{item_code}"
save_path = "download"

driver = chrome_driver(headless=True)
session = Session()

with open("error_item.txt", "r", encoding="utf-8") as f:
    item_codes = [line.replace("\n", "") for line in f.readlines()]
item_list = []
for item_code in tqdm(item_codes):
    item = session.query(Item).get(item_code)
    if item and Path(f"{save_path}/{name}").exists():
        continue
    driver.get(base_url.format(item_code=item_code))
    try:

        item_name = driver.find_element(By.CLASS_NAME, "product-page--title").text
        series = find_content_between_spaces_regex(item_name)
        price = find_price(
            driver.find_element(By.CLASS_NAME, "product-form--price").text
        )
        name = f"{item_code}.jpg"
        img_src = driver.find_element(By.CSS_SELECTOR, ".slick-dots img").get_attribute(
            "src"
        )
        img_src = replace_last_occurrence(r"_(\d{2}|\d{3}|\d{4})x", "", img_src).strip()
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
        with open("error_item_2.txt", "a", encoding="utf-8") as f:
            f.write(f"{item_code}\n")
            continue
    item_list.append(item)
if item_list:
    session.add_all(item_list)
    session.commit()
driver.quit()
