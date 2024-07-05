import requests
from bs4 import BeautifulSoup

from base import Session
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
    "_orig_referrer": "",
    "_landing_page": "%2Fcollections%2Fnewitems",
    "_tracking_consent": "%7B%22con%22%3A%7B%22CMP%22%3A%7B%22a%22%3A%22%22%2C%22m%22%3A%22%22%2C%22p%22%3A%22%22%2C%22s%22%3A%22%22%7D%7D%2C%22v%22%3A%222.1%22%2C%22region%22%3A%22JP13%22%2C%22reg%22%3A%22%22%7D",
    "_clck": "1kcw06y%7C2%7Cfn1%7C0%7C1641",
    "_ga_7WX3W15SYL": "GS1.1.1719679272.2.0.1719679272.60.0.0",
    "_cmp_a": "%7B%22purposes%22%3A%7B%22a%22%3Atrue%2C%22p%22%3Atrue%2C%22m%22%3Atrue%2C%22t%22%3Atrue%7D%2C%22display_banner%22%3Afalse%2C%22sale_of_data_region%22%3Afalse%7D",
    "_gid": "GA1.2.1222447335.1719995837",
    "cart": "Z2NwLWFzaWEtc291dGhlYXN0MTowMUoxVlZWSzBRNFFBSjFCQ0ZUWFBLVDJIVg%3Fkey%3D3d22a09e0fa3ff1367b6787b9b523686",
    "cart_sig": "832e4e4d95bcc2c215f18617e226da47",
    "receive-cookie-deprecation": "1",
    "_shopify_sa_p": "",
    "__lt__sid": "1a23882c-5a941c13",
    "shopify_pay": "L1hRNjJnWVRVNTVxbFlaTWV6OHBFNGltclhUTXpsQ1RHMXRleWliR3hkc0hwWjA5N0xTc29tN0g5TDVrV1ZHK3lCR1ZoY0NwZmF0QThNQnBKQTRXYmF4dHpiTWZTSy80M09vS0xrWW1MSzg4dFpmaUdGSGxBbmE2SjNzTUhhOHgzbCtZbWM5MDMvWWI5VzJ6d1R4dUNlUzNYS0NJdmw1Q2ZWZmZOb0VaWXMwTlgxa2F3d0lrTFplRXRaSFV2NEhTOWVsY1p3TmlsZUVzU3g0SlpXN3lYM2FrTEQzS0ptSDBvSU0vMW45dGcwZGZKQytZcndESmovRTVFOU13RjBmaXpBc3lvTEdBYTVoTjhGcnVCL1p3VjlRdGRhQ2NwUlFRbk9vUlRFL1M5QzRiMHhnb05vZmR1cTUwd0U1d1VqN1pEMHFYZmtITDdsMUVQeEhlczI2VGpvQ1RtaThNUlpLalFkT1J6NFlhREhFanlaZlhzSmpaSGtjTHZVcnRuTGdHMEEvNVFGQ09QTW1sd3hWY3gwTXV3UT09LS1XckYwT3l3cVViRGJjenFrMmJtRTNnPT0%3D--c2c9b5b229aaebe26d2c3138f11b58f6a3a7bf84",
    "_shopify_essential": ":AZB3veADAAH_Kz423ObeIMoy_m250UQ76Vj2X7EHRqOPKLIxMqOPikrwPYV4N6BoNMuKfvfiI-LI91gGydDwma-o_DeJNU3ITA3q0g:",
    "cart_ts": "1720150261",
    "secure_customer_sig": "40c76f83cc6ce34eb7dd0ba977540228",
    "keep_alive": "827e67be-eb8b-48f0-b421-8e979fd25dc5",
    "_shopify_s": "6a552363-4717-41e6-9811-b5e4797479f8",
    "_ga": "GA1.1.1347574435.1715851172",
    "_gat": "1",
    "_shopify_sa_t": "2024-07-05T03%3A31%3A55.885Z",
    "_ga_PN5MPJPH85": "GS1.1.1720150238.26.1.1720150317.58.0.0",
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
    "_orig_referrer": "",
    "_landing_page": "%2Fcollections%2Fnewitems",
    "_tracking_consent": "%7B%22con%22%3A%7B%22CMP%22%3A%7B%22a%22%3A%22%22%2C%22m%22%3A%22%22%2C%22p%22%3A%22%22%2C%22s%22%3A%22%22%7D%7D%2C%22v%22%3A%222.1%22%2C%22region%22%3A%22JP13%22%2C%22reg%22%3A%22%22%7D",
    "_clck": "1kcw06y%7C2%7Cfn1%7C0%7C1641",
    "_ga_7WX3W15SYL": "GS1.1.1719679272.2.0.1719679272.60.0.0",
    "_cmp_a": "%7B%22purposes%22%3A%7B%22a%22%3Atrue%2C%22p%22%3Atrue%2C%22m%22%3Atrue%2C%22t%22%3Atrue%7D%2C%22display_banner%22%3Afalse%2C%22sale_of_data_region%22%3Afalse%7D",
    "_gid": "GA1.2.1222447335.1719995837",
    "cart": "Z2NwLWFzaWEtc291dGhlYXN0MTowMUoxVlZWSzBRNFFBSjFCQ0ZUWFBLVDJIVg%3Fkey%3D3d22a09e0fa3ff1367b6787b9b523686",
    "cart_sig": "832e4e4d95bcc2c215f18617e226da47",
    "receive-cookie-deprecation": "1",
    "_shopify_sa_p": "",
    "__lt__sid": "1a23882c-5a941c13",
    "shopify_pay": "bWFFa0l4c05pU05RTTAwVUd3aFRUVmxyM1Y0L0dwV1BCTm1qdXZpeVVSL0s4alRXeEoxeEdnRHlOM2ZHa1EzS1dhTm5Cb2djZDlwejNNU25GUUJlWnZXa1JwZCtWWXZ2Ykk2ZTA0aHBZc3dUOXl6RXpNRldqMVZsdHQydDZPaElHM2dOR2tGK2lVVUFQTDd4bUhqaGM2R2E3TWxUYy9DT204c3ZmOTNiWndNaTNYZnc0RUg2SDE1cjYyejk3QnlqT1hka2t2WjIyU1NzWm5pQ01iNWUyR2RRclJmVzNJWTlLWnNsaUFsUk9zOTg0bGFqaW4xcmlNb0dBZ1ZvNjgybGpWLzExMGVpRkFvUEdsM2s3cFNJdGhSMHZPbUg5dnh5YjVyaVpJanBlUEFkM0YzQmtub0hRTzU0cUNoSnc2KzE5V2xDeFRPNUxTdkl3TWxmSmVSK2hxVC9oWVEvZXQ4UW5iM204L2UvOUltSFZqS24wRmxtOEdYRWQ1eTF4UHlhbEtuVzJwNDZCYkxBYUdSamdZdTViUT09LS12N1Fwa2dIRVI0NjRNT0J3WVFiazVnPT0%3D--5c90d9bcd7d76624ef82dd8bb8628aaaa0c6f098",
    "_gat": "1",
    "_shopify_essential": ":AZB3veADAAH_b71uecEqoK_rQQp6yEKxdwwFfKMKDVOvoMn64L4gFGmkUrgLwDkoRaagNXcbd58SAoTflkRTf_4xzfMNcheuMsy7jA:",
    "cart_ts": "1720150706",
    "secure_customer_sig": "a1dd051f6d519df6338bfefdba7ef3c4",
    "keep_alive": "718c8ef6-99ae-49a2-9caf-4d8c0e708eae",
    "_ga_PN5MPJPH85": "GS1.1.1720150238.26.1.1720150707.44.0.0",
    "_shopify_s": "6a552363-4717-41e6-9811-b5e4797479f8",
    "_ga": "GA1.2.1347574435.1715851172",
    "_shopify_sa_t": "2024-07-05T03%3A38%3A27.606Z",
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
    items: list[ChiikawaOnlineOrder] = []

    item_codes = soup.find_all("li", {"data-label": "商品コード"})
    quantities = soup.find_all("li", {"data-label": "数量"})

    for code, quantity in zip(item_codes, quantities):
        item_code = code.get_text(strip=True).replace("商品コード：", "")
        quantity = quantity.get_text(strip=True).replace("数量：", "")
        items.append(ChiikawaOnlineOrder(item_code=item_code, quantity=quantity))
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
        item.order_url = order_url
        item.order_status = order_status
        item.order_date = order_date
        item.orderer = orderer

    session = Session()
    try:
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
