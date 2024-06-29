import requests
from bs4 import BeautifulSoup


item_code = "4582662920262"

item_url = "https://chiikawamarket.jp/collections/newitems/products/{item_code}"


html_content = requests.get(item_url.format(item_code=item_code)).text
soup = BeautifulSoup(html_content, "html.parser")
div_options = soup.find("div", class_="product-form--options")
option_tag = div_options.find("option", selected=True)
inventory_quantity = option_tag.get("data-inventory-quantity")
print(inventory_quantity)
