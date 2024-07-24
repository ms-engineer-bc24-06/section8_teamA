from flask import Flask, request, abort
from linebot import LineBotApi, WebhookHandler
from linebot.exceptions import InvalidSignatureError
from linebot.models import MessageEvent, TextMessage, TextSendMessage
import openai
import os
from dotenv import load_dotenv
import logging
from database import create_connection, close_connection

# 環境変数の読み込み
load_dotenv()

# Flaskアプリケーションの設定
app = Flask(__name__)

# LINE API設定
line_bot_api = LineBotApi(os.getenv("CHANNEL_ACCESS_TOKEN"))
handler = WebhookHandler(os.getenv("CHANNEL_SECRET"))

# OpenAI API設定
openai.api_key = os.getenv("OPENAI_API_KEY")

# ロギングの設定
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

@app.route("/callback", methods=["POST"])
def callback():
    print("callback関数呼び出し")
    signature = request.headers.get("X-Line-Signature")
    body = request.get_data(as_text=True)

    try:
        handler.handle(body, signature)
    except InvalidSignatureError:
        logger.error("Invalid signature error.")
        abort(400)
    return "OK"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

