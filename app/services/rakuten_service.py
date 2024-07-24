import requests
import os
import logging
from dotenv import load_dotenv

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()

def get_rakuten_products(keyword):
    url = "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706"
    params = {
        "applicationId": os.getenv("RAKUTEN_APP_ID"),
        "keyword": keyword,
        "format": "json"
    }
    logger.info(f"Sending request to Rakuten API with params: {params}")
    response = requests.get(url, params=params)
    
    if response.status_code == 200:
        data = response.json()
        if 'Items' in data:
            logger.info("Received successful response from Rakuten API")
            return data['Items']
        else:
            logger.error(f"Key 'Items' not found in the response: {data}")
            return []
    else:
        logger.error(f"Failed to receive response from Rakuten API: {response.status_code}")
        return []

def format_product_info(products):
    formatted_info = []
    for item in products:
        product = item['Item']
        info = (
            f"**商品名**: {product['itemName']}\n"
            f"**価格**: {product['itemPrice']}円\n"
            f"**画像**: {product['mediumImageUrls'][0]['imageUrl']}\n"
            f"**レビュー平均**: {product.get('reviewAverage', 'N/A')}\n"
            f"**レビュー件数**: {product.get('reviewCount', 'N/A')}\n"
            "---------------------------------------------"
        )
        formatted_info.append(info)
    return formatted_info

if __name__ == "__main__":
    keyword = "ギフト"
    products = get_rakuten_products(keyword)
    if products:
        formatted_products = format_product_info(products)
        for product_info in formatted_products[:5]:
            print(product_info)
    else:
        print("No products found")
