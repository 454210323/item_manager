from dataclasses import dataclass


@dataclass
class Item:
    item_code: str
    item_name: str
    item_type: str
    price: str
    series: str
    shipment_quantity: str
    stock_quantity: str
    image_url: str

    # def to_markdown_row(self) -> str:
    #     return (
    #         f"| {self.item_code} | {self.item_name} | {self.item_type} | {self.price} | "
    #         f"{self.series} | {self.shipment_quantity} | {self.stock_quantity} | ![Image]({self.image_url}) |"
    #     )
    def to_markdown_row(self) -> str:
        return (
            f"| {self.item_name} | {self.price} | "
            f'{self.shipment_quantity} | <img src="{self.image_url}" width="100" height="50"> |'
        )


header = (
    "| Item Name | Price | Shipment Quantity | Image |\n"
    "|-----------|-------|-------------------|-------|"
)
stock_shipment_infos = [
    {
        "item_code": "4582662961999",
        "item_name": "\u3061\u3044\u304b\u308f \u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f \u3055\u3044\u3054\u306e\u6226\u3044\uff013\u9023\u30a2\u30af\u30ea\u30eb\u30c1\u30e3\u30fc\u30e0",
        "item_type": "",
        "price": "1320",
        "series": "\u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f",
        "shipment_quantity": "5",
        "stock_quantity": "0",
    },
    {
        "item_code": "4582662962002",
        "item_name": "\u3061\u3044\u304b\u308f \u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f \u306a\u3093\u3068\u304b\u30fb\u30fb\u30fb\u30fb\u306a\u308c\u30fc\u30c3\uff013\u9023\u30a2\u30af\u30ea\u30eb\u30c1\u30e3\u30fc\u30e0",
        "item_type": "",
        "price": "1320",
        "series": "\u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f",
        "shipment_quantity": "5",
        "stock_quantity": "0",
    },
    {
        "item_code": "4582662962033",
        "item_name": "\u3061\u3044\u304b\u308f \u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f \u30ec\u30a4\u30e4\u30fc\u30a2\u30af\u30ea\u30eb\u30b9\u30bf\u30f3\u30c9\uff08\u30c6\u30ec\u30d3\u3092\u898b\u308b\u3068\u304d\u306f\uff09",
        "item_type": "",
        "price": "770",
        "series": "\u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f",
        "shipment_quantity": "4",
        "stock_quantity": "0",
    },
    {
        "item_code": "4582662962040",
        "item_name": "\u3061\u3044\u304b\u308f \u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f \u30ec\u30a4\u30e4\u30fc\u30a2\u30af\u30ea\u30eb\u30b9\u30bf\u30f3\u30c9\uff08\u3055\u3044\u3054\u306e\u6226\u3044\uff09",
        "item_type": "",
        "price": "770",
        "series": "\u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f",
        "shipment_quantity": "8",
        "stock_quantity": "0",
    },
    {
        "item_code": "4582662962057",
        "item_name": "\u3061\u3044\u304b\u308f \u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f \u30ec\u30a4\u30e4\u30fc\u30a2\u30af\u30ea\u30eb\u30b9\u30bf\u30f3\u30c9\uff08\u306a\u3093\u304b\u3080\u3061\u3083\u307e\u3058\u304b\u308b\uff09",
        "item_type": "",
        "price": "770",
        "series": "\u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f",
        "shipment_quantity": "2",
        "stock_quantity": "0",
    },
    {
        "item_code": "4582662962491",
        "item_name": "\u3061\u3044\u304b\u308f \u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f \u30b9\u30af\u30a8\u30a2\u30de\u30b0\u30cd\u30c3\u30c8\uff08\u60aa\u3044\u30d0\u30fc\u30b8\u30e7\u30f3\uff09",
        "item_type": "",
        "price": "550",
        "series": "\u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f",
        "shipment_quantity": "1",
        "stock_quantity": "0",
    },
    {
        "item_code": "4582662962507",
        "item_name": "\u3061\u3044\u304b\u308f \u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f \u30b9\u30af\u30a8\u30a2\u30de\u30b0\u30cd\u30c3\u30c8\uff08\u3055\u3044\u3054\u306e\u6226\u3044\uff09",
        "item_type": "",
        "price": "550",
        "series": "\u8d85\u307e\u3058\u304b\u308b\u3061\u3044\u304b\u308f",
        "shipment_quantity": "1",
        "stock_quantity": "0",
    },
]
markdown_rows = [header]
for e in stock_shipment_infos:
    item_code = e["item_code"]
    e["image_url"] = f"https://static-resource.fly.dev/static/images/{item_code}.jpg"
    item = Item(**e)
    markdown_rows.append(item.to_markdown_row())
markdown_output = "\n".join(markdown_rows)
with open("test.md", "w", encoding="utf-8") as f:
    f.write(markdown_output)
