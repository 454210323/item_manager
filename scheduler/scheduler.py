from apscheduler.schedulers.blocking import BlockingScheduler
import requests
from bs4 import BeautifulSoup

from base import Session
from favorite_item import FavoriteItem
from datetime import datetime


def fetch_stock(item_code: str):

    item_url = "https://chiikawamarket.jp/collections/newitems/products/{item_code}"
    try:
        html_content = requests.get(item_url.format(item_code=item_code)).text
        soup = BeautifulSoup(html_content, "html.parser")
        div_options = soup.find("div", class_="product-form--options")
        option_tag = div_options.find("option", selected=True)
        stock_quantity = option_tag.get("data-inventory-quantity")
        return int(stock_quantity)
    except:
        return None


def add_stock_info():

    try:
        session = Session()

        item_codes = [
            result[0]
            for result in session.query(FavoriteItem.item_code).distinct().all()
        ]

        for item_code in item_codes:
            check_time = datetime.now()
            stock_quantity = fetch_stock(item_code)
            favorite_item = FavoriteItem(
                item_code=item_code,
                check_datetime=check_time,
                stock_quantity=stock_quantity,
            )
            session.add(favorite_item)
        session.commit()
    except:
        return


scheduler = BlockingScheduler()
scheduler.add_job(add_stock_info, "cron", minute="0,30")

try:
    print("Scheduler started.")
    scheduler.start()
except (KeyboardInterrupt, SystemExit):
    pass
