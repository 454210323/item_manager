import requests
from bs4 import BeautifulSoup

from base import Session
from models.chiikawa_online_order_detail import ChiikawaOnlineOrderDetail
from models.chiikawa_online_order import ChiikawaOnlineOrder
from datetime import datetime
from tqdm import tqdm

cookies_wu = {
    "localization": "JP",
    "_shopify_y": "03f0beba-28e7-486c-bf50-8e220dcfb7c6",
    "__lt__cid": "5a678b49-2ab5-4ec8-9c3c-746e8ce13cd8",
    "_yjsu_yjad": "1709257743.866755b6-4417-4177-9ac2-e4541da9cefa",
    "_tt_enable_cookie": "1",
    "_ttp": "TxdDQLMzaJ06zLwTiGdNDzvdpLe",
    "_fbp": "fb.1.1709257743550.1653495352",
    "skip_shop_pay": "false",
    "hide_shopify_pay_for_checkout": "5218c964d6084455a8a2d324d66b65ef",
    "cart_currency": "JPY",
    "_gcl_au": "1.1.1002553371.1718271210",
    "_ga_PN5MPJPH85": "deleted",
    "shop_pay_accelerated": "%7B%22disable_auto_redirect%22%3A%22%22%2C%22session_detected_at%22%3A1718273140%7D",
    "shopify_pay_redirect": "true",
    "_tracking_consent": "%7B%22con%22%3A%7B%22CMP%22%3A%7B%22a%22%3A%22%22%2C%22m%22%3A%22%22%2C%22p%22%3A%22%22%2C%22s%22%3A%22%22%7D%7D%2C%22v%22%3A%222.1%22%2C%22region%22%3A%22JP13%22%2C%22reg%22%3A%22%22%7D",
    "_clck": "1kcw06y%7C2%7Cfn7%7C0%7C1641",
    "_ga_7WX3W15SYL": "GS1.1.1720401775.4.0.1720401775.60.0.0",
    "cart": "Z2NwLXVzLWNlbnRyYWwxOjAxSjM3TjU0MDIwNDJRS0JOOTgzR1kwSzNG%3Fkey%3Db75de31b6be5d4daae4d4ef760bff7eb",
    "cart_sig": "3926e1b732064a14b23b5750f08a0629",
    "_cmp_a": "%7B%22purposes%22%3A%7B%22a%22%3Atrue%2C%22p%22%3Atrue%2C%22m%22%3Atrue%2C%22t%22%3Atrue%7D%2C%22display_banner%22%3Afalse%2C%22sale_of_data_region%22%3Afalse%7D",
    "_gid": "GA1.2.1307836889.1721985702",
    "receive-cookie-deprecation": "1",
    "_orig_referrer": "https%3A%2F%2Fchiikawamarket.jp%2Fcollections%2Fnewitems%2Fproducts%2F4582662958524",
    "_landing_page": "%2Faccount%2F",
    "_shopify_sa_p": "",
    "_gat": "1",
    "__lt__sid": "1a23882c-cae45b96",
    "shopify_pay": "KzlxYVJiZkRmSFl2STZZWTRCOFpYWGt1SjVXbVlUNzJUNDlBYklQekdnTXVXMUpqWGZ6SG9JMjY2cTF4cloxd3V5ZFlFQ3ova0tIZzZmMkhpaVN1SFdrZ1ppQzlWekJIREwrcXZsVDF0WXAwVEk3bG45emNPRi9iK2UrMkhMQXl0dG04ODViMVkvYUhEcWUrbmd4MTBxYURGRXlrWVpOVmk3WkhwbWtQdUk5eWJaell5RUVJQjlZS0xZdjBOTVJSRldWQ2lUS01XTndoL05FWERDQk9INllCd0cxejdKbUlFTU8vYjlHb2VUY3MxZWZJWGlJNWNWT3luUEkyaHE3TzhjcDRtTkRnRmg1MTZQalptMU9lRjU1LzE3YUJ4c2gzVEJnMmljZmxzVnBrR1BoWVB6V3dCNUJGVmxlVW5JaUlGWkZCUGFyVS9HYWFuRm10NnNyM1ZjQjZ4aVZpNlM0cDR0VUhnTkIxZUhxNXNkb2xlZUtoUTIzT2MySFBFTGZKQ1ozUUhSRWJMb3hEQ2NQSW9TUUgyZz09LS1HcFRKU09SY2R2Nmp0TFA4aHJjTVlRPT0%3D--251531f7b4e0c15c17e1de3100a3af69196632b6",
    "_shopify_essential": ":AZB3veADAAH_HHBHRFlstoqGfRk7tO_tAe6TncAO8zmNAo-4lWWgofNhbVMj8CEni0lqrZGSzu0uEJVeYnVoZgFEnu0_9C4rxbAUKSEk4daVk1oUFNzTFrBP0CCt:",
    "cart_ts": "1721991079",
    "secure_customer_sig": "40c76f83cc6ce34eb7dd0ba977540228",
    "keep_alive": "4f188fa1-b7b2-4356-883d-289166b7e2fa",
    "_shopify_s": "51cbe1ce-3ddc-42fd-8eba-45bf03ba7ea7",
    "_ga": "GA1.2.1347574435.1715851172",
    "_shopify_sa_t": "2024-07-26T10%3A51%3A20.612Z",
    "_ga_PN5MPJPH85": "GS1.1.1721991068.44.1.1721991082.46.0.0",
}


cookies_you = {
    "localization": "JP",
    "_shopify_y": "03f0beba-28e7-486c-bf50-8e220dcfb7c6",
    "__lt__cid": "5a678b49-2ab5-4ec8-9c3c-746e8ce13cd8",
    "_yjsu_yjad": "1709257743.866755b6-4417-4177-9ac2-e4541da9cefa",
    "_tt_enable_cookie": "1",
    "_ttp": "TxdDQLMzaJ06zLwTiGdNDzvdpLe",
    "_fbp": "fb.1.1709257743550.1653495352",
    "skip_shop_pay": "false",
    "hide_shopify_pay_for_checkout": "5218c964d6084455a8a2d324d66b65ef",
    "cart_currency": "JPY",
    "_gcl_au": "1.1.1002553371.1718271210",
    "_ga_PN5MPJPH85": "deleted",
    "shop_pay_accelerated": "%7B%22disable_auto_redirect%22%3A%22%22%2C%22session_detected_at%22%3A1718273140%7D",
    "shopify_pay_redirect": "true",
    "_tracking_consent": "%7B%22con%22%3A%7B%22CMP%22%3A%7B%22a%22%3A%22%22%2C%22m%22%3A%22%22%2C%22p%22%3A%22%22%2C%22s%22%3A%22%22%7D%7D%2C%22v%22%3A%222.1%22%2C%22region%22%3A%22JP13%22%2C%22reg%22%3A%22%22%7D",
    "_clck": "1kcw06y%7C2%7Cfn7%7C0%7C1641",
    "_ga_7WX3W15SYL": "GS1.1.1720401775.4.0.1720401775.60.0.0",
    "cart": "Z2NwLXVzLWNlbnRyYWwxOjAxSjM3TjU0MDIwNDJRS0JOOTgzR1kwSzNG%3Fkey%3Db75de31b6be5d4daae4d4ef760bff7eb",
    "cart_sig": "3926e1b732064a14b23b5750f08a0629",
    "_orig_referrer": "https%3A%2F%2Fchiikawamarket.jp%2Fcollections%2Fnewitems%2Fproducts%2F4582662958524",
    "_landing_page": "%2Faccount%2F",
    "_cmp_a": "%7B%22purposes%22%3A%7B%22a%22%3Atrue%2C%22p%22%3Atrue%2C%22m%22%3Atrue%2C%22t%22%3Atrue%7D%2C%22display_banner%22%3Afalse%2C%22sale_of_data_region%22%3Afalse%7D",
    "receive-cookie-deprecation": "1",
    "_shopify_sa_p": "",
    "_gid": "GA1.2.144811571.1722090849",
    "_gat": "1",
    "__lt__sid": "1a23882c-3b43908c",
    "shopify_pay": "N0RnY0xndWZDS2U4UkhOU3ozdmZZZjd1Y3daaTlpSUd4QS9kM0V0dlJtb25zbm1VTWxrYkdDWk1LZ3Q0bzJCWDlQcTM1NHRJYVhEbUN4dTZodXZuaFRkYUY2c043RkFxa2FDZEJ3Z1dMYkhzMlE0UzZIdG5aRFBrYTFUUFlZQzZ2aUhseXFQS00zOWdHdGVhYWFJaFVjalhkZzI5cmtDTkgwM3N4aWs4RUxwZjZZMkFsaTgrTndBbjZ2NDJxRGxNdjluNjE4Q3o2NFJVV1ozVlF4cjNkRkVSa2NNUkZWRG1WYytJY014bW9wTm1ENXozWUR5UGg1VUxYbmtzVUxZQ1RXRmk3eVhydzA1VWIvbUNCNW9tZDU2S05XZzFZcmh3eEpKYjhMaDJIMHp0M0I3a0NyQW80YXVIa3QxWUVrcExmRHFTUkpFWjV2NUt1c2MrREpoaWxMRDRoTlVZdy9kMk5idVh2WDl0Y0pKbWV5cmRvRE1lMEM4Z3RtYmxoUTNoRUw3UWFUTUVNRjdNeWpuenZ5RVVuQT09LS01dk02WkxmcTdEQjBWYndPai90Z09RPT0%3D--3efd16f0676d251dcc0d9e6599ab132c14293174",
    "_shopify_essential": ":AZB3veADAAH_a4VH8HvAxzue6TWni7stSRXOS-dUtH9WCHGZVp7GzJYg8TrJidiMDiRVW2ggKun6BxR7TZnWN2JE7BG6XHxag41pz4JedeeJTuYm5MJqliW8Oymh:",
    "cart_ts": "1722090865",
    "secure_customer_sig": "9c052d1d6646335357525193e8d9a3e9",
    "keep_alive": "5ea0e8df-0d75-4538-b945-f26171d17882",
    "_ga_PN5MPJPH85": "GS1.1.1722090849.45.1.1722090865.44.0.0",
    "_shopify_s": "d245c242-b7eb-4012-bfe8-797ff2deaa6a",
    "_ga": "GA1.2.1347574435.1715851172",
    "_shopify_sa_t": "2024-07-27T14%3A34%3A25.538Z",
}

orderer = "you"

cookies = cookies_wu if orderer == "wu" else cookies_you


def fetch_instered_urls():
    session = Session()
    return [
        result[0]
        for result in session.query(ChiikawaOnlineOrder.order_url).distinct().all()
    ]


def fetch_total_page():
    html_text = requests.get("https://chiikawamarket.jp/account", cookies=cookies).text
    soup = BeautifulSoup(html_text, "html.parser")
    page_nums = soup.find_all("li", class_="pagination--number")
    total_page = page_nums[-1].get_text()
    return int(total_page)


def fetch_all_order_url():
    urls = []
    total_page = fetch_total_page()
    for i in range(1, total_page + 1):
        html_text = requests.get(
            f"https://chiikawamarket.jp/account?page={i}", cookies=cookies
        ).text
        soup = BeautifulSoup(html_text, "html.parser")
        ul_element = soup.find("ul", class_="orderhistory_list")

        a_elements = ul_element.find_all("a")

        urls.extend([a.get("href") for a in a_elements])
    return urls


def fetch_order_item_info(soup: BeautifulSoup):
    items: list[ChiikawaOnlineOrderDetail] = []

    item_codes = soup.find_all("li", {"data-label": "商品コード"})
    quantities = soup.find_all("li", {"data-label": "数量"})

    for code, quantity in zip(item_codes, quantities):
        item_code = code.get_text(strip=True).replace("商品コード：", "")
        quantity = quantity.get_text(strip=True).replace("数量：", "")
        items.append(ChiikawaOnlineOrderDetail(item_code=item_code, quantity=quantity))
    return items


def fetch_order_info(order_url):
    html_text = requests.get(order_url, cookies=cookies).text
    soup = BeautifulSoup(html_text, "html.parser")
    main_content = soup.find("div", class_="account_wrapper")
    header_content = main_content.find("div", class_="order_detail_header")
    order_no = header_content.find("h2").get_text(strip=True)
    order_date_str = header_content.find("time").get_text(strip=True)
    order_date = datetime.strptime(order_date_str, "%Y年%m月%d日").date()
    footer_content = main_content.find(id="order_shipping")
    order_status = footer_content.find_all("span")[-1].get_text(strip=True)

    item_info_table = main_content.find("ul", class_="detail1")
    return order_no, order_date, order_status, item_info_table


def fetch_order_detail_and_insert(order_url):
    order_no, order_date, order_status, item_info_table = fetch_order_info(order_url)

    items = fetch_order_item_info(item_info_table)
    for item in items:
        item.order_no = order_no
    order: ChiikawaOnlineOrder = ChiikawaOnlineOrder(
        order_no=order_no,
        order_url=order_url,
        order_date=order_date,
        order_status=order_status,
        orderer=orderer,
    )

    session = Session()
    try:
        session.add(order)
        session.add_all(items)
        session.commit()
    except Exception as e:
        session.rollback()
        print(f"An error occurred: {e}")
    finally:
        session.close()


def insert_order():
    inserted_urls = fetch_instered_urls()
    urls = fetch_all_order_url()
    # 登录未登录的订单信息
    for url in tqdm(urls):
        if url in inserted_urls:
            continue
        fetch_order_detail_and_insert(url)


def update_order_status():
    session = Session()
    try:
        orders: list[ChiikawaOnlineOrder] = (
            session.query(ChiikawaOnlineOrder)
            .filter(
                ChiikawaOnlineOrder.order_status == "未発送",
                ChiikawaOnlineOrder.orderer == orderer,
            )
            .all()
        )
        for order in tqdm(orders):
            order_status = fetch_order_info(order.order_url)[2]
            if not order_status == order.order_status:
                order.order_status = order_status
                print(f"order_no: {order.order_no} will be updated")
        session.commit()
    except Exception as e:
        session.rollback()
        print(f"An error occurred: {e}")
    finally:
        session.close()


if __name__ == "__main__":
    update_order_status()
    insert_order()
