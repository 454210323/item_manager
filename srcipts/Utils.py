import requests
from pathlib import Path
import datetime
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import re

SAVE_PATH = "item_info"


def make_dir(index=0) -> str:
    dir_path = SAVE_PATH + "/" + datetime.date.today().strftime("%Y%m%d")
    path = Path(f"{dir_path}-{str(index)}")
    if path.exists():
        index += 1
        return make_dir(index)
    else:
        Path.mkdir(path)
        return str(path)


def download_image(url, save_path):
    response = requests.get(url, stream=True)
    response.raise_for_status()
    with open(save_path, "wb") as file:
        for chunk in response.iter_content(chunk_size=8192):
            file.write(chunk)


def chrome_driver(headless=False):
    driver_path = ChromeDriverManager().install()
    options = webdriver.ChromeOptions()
    if headless:
        options.add_argument("--headless=new")
    driver = webdriver.Chrome(service=Service(driver_path), options=options)
    # 防止网站检测selenium的webdriver
    driver.execute_cdp_cmd(
        "Page.addScriptToEvaluateOnNewDocument",
        {
            "source": """
                Object.defineProperty(navigator, 'webdriver', {
                    get: () => false
                })
            """
        },
    )
    return driver


def find_content_between_spaces_regex(s):
    # 使用正则表达式匹配第一个空格到第二个空格之间的内容
    # 正则表达式解释：
    # \s 表示空格
    # .*? 表示非贪婪模式的任意字符匹配，尽可能少的匹配字符
    match = re.search(r"\s(.*?)\s", s)

    # 如果找到匹配，返回匹配的内容；否则，返回特定的错误消息
    if match:
        return match.group(1)  # group(1) 返回第一个括号内匹配的文本
    else:
        return ""


def find_price(s):
    # 使用正则表达式找到字符串中的所有数字
    numbers = re.findall(r"\d", s)

    # 将找到的数字连接成一个字符串
    price_str = "".join(numbers)

    # 将字符串转换为整数
    price = int(price_str)

    return price


def replace_last_occurrence(regex, replacement, text) -> str:
    matches = list(re.finditer(regex, text))
    if not matches:
        return text
    last_match = matches[-1]
    return (
        text[: last_match.start()]
        + re.sub(regex, replacement, text[last_match.start() : last_match.end()], 1)
        + text[last_match.end() :]
    )


def find_image_src(srcset: str):
    src_temp = srcset.split(",")[-1].split("?")[0]
    src = replace_last_occurrence(r"_(\d{2}|\d{3}|\d{4})x", "", src_temp).strip()
    return f"https:{src}"
