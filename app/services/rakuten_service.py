import requests
import os
import logging
from dotenv import load_dotenv

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()

def get_rakuten_products(keyword):
    """
    楽天市場APIを使って商品を検索する関数。
    Args:
        keyword (str): 検索キーワード
    Returns:
        list: 検索結果の商品のリスト。APIからのレスポンスに'Items'キーが含まれていればその値を返す。
    """
    url = "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706"
    params = {
        "applicationId": os.getenv("RAKUTEN_APP_ID"),  # 環境変数から楽天APIのアプリケーションIDを取得
        "keyword": keyword,  # 検索キーワード
        "format": "json"  # レスポンス形式をJSONに設定
    }
    
    # APIリクエストを送信
    logger.info(f"Sending request to Rakuten API with params: {params}")
    response = requests.get(url, params=params)
    
    # APIからのレスポンスを処理
    if response.status_code == 200:
        data = response.json()
        if 'Items' in data:
            logger.info("Received successful response from Rakuten API")
            return data['Items']  # 'Items'キーが存在する場合、その値を返す
        else:
            logger.error(f"Key 'Items' not found in the response: {data}")
            return []
    else:
        logger.error(f"Failed to receive response from Rakuten API: {response.status_code}")
        return []

def format_product_info(product):
    """
    商品情報を整形する関数。
    Args:
        product (dict): 商品情報を含む辞書
    Returns:
        str: 整形された商品情報
    """
    item = product['Item']
    name = item.get('itemName', 'No Name')
    price = item.get('itemPrice', 'No Price')
    image_url = item.get('mediumImageUrls', [{}])[0].get('imageUrl', None)
    
    product_info = f"**商品名**: {name}\n**価格**: {price}円\n"
    
    if image_url:
        product_info += f"**画像**: {image_url}\n"
    
    return product_info

def search_products(chatgpt_response):
    """
    ChatGPTの応答を基に商品を検索し、整形された商品情報をリストとして返す関数。
    Args:
        chatgpt_response (str): ChatGPTからの応答をキーワードとして使用
    Returns:
        list: 整形された商品情報のリスト
    """
    products = get_rakuten_products(chatgpt_response)
    return [format_product_info(item) for item in products[:5]]

if __name__ == "__main__":
    keyword = "ギフト"
    products = get_rakuten_products(keyword)
    if products:
        # 整形された商品情報を表示
        for product_info in search_products(keyword):
            print(product_info)
    else:
        print("No products found")  # 商品が見つからない場合のメッセージ
