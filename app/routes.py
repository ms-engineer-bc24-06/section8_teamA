from flask import Blueprint, request, abort
from linebot import LineBotApi, WebhookHandler
from linebot.exceptions import InvalidSignatureError
from linebot.models import MessageEvent, TextMessage, TextSendMessage
import os
from dotenv import load_dotenv
from .services.chatgpt_service import process_message
from .services.rakuten_service import search_products
from .services.database_service import save_message, get_conversation_history
import logging

load_dotenv()

main = Blueprint('main', __name__)

# LINE APIの設定
line_bot_api = LineBotApi(os.getenv('LINE_CHANNEL_ACCESS_TOKEN'))
handler = WebhookHandler(os.getenv('LINE_CHANNEL_SECRET'))

# 状態管理用変数
user_states = {}

# ログ設定
logging.basicConfig(level=logging.INFO)

@main.route("/callback", methods=['POST'])
def callback():
    signature = request.headers['X-Line-Signature']
    body = request.get_data(as_text=True)

    logging.info(f"Received request: {body}")

    try:
        handler.handle(body, signature)
    except InvalidSignatureError:
        logging.error("Invalid signature")
        abort(400)

    return 'OK'

@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    user_id = event.source.user_id
    user_message = event.message.text

    logging.info(f"Received message from user {user_id}: {user_message}")

    if user_id not in user_states:
        user_states[user_id] = {"step": 0}

    step = user_states[user_id]["step"]

    if step == 0:
        reply_message = "こんにちは！私はギフティーです。あなたにぴったりのプレゼントを提案します。まず、贈る相手について少し教えてください。贈る相手の性別を教えてください。（例: 男性、女性）"
        user_states[user_id]["step"] = 1
    elif step == 1:
        user_states[user_id]["gender"] = user_message
        reply_message = "相手の年齢を教えてください。（例: 30歳）"
        user_states[user_id]["step"] = 2
    elif step == 2:
        user_states[user_id]["age"] = user_message
        reply_message = "相手との関係を教えてください。（例: 友人、恋人、家族）"
        user_states[user_id]["step"] = 3
    elif step == 3:
        user_states[user_id]["relationship"] = user_message
        reply_message = "どのカテゴリーのプレゼントが良いですか？（例: アクセサリー、ファッション、ガジェット、グルメ）"
        user_states[user_id]["step"] = 4
    elif step == 4:
        user_states[user_id]["category"] = user_message
        reply_message = "予算を教えてください。（例: 5000円、10000円）"
        user_states[user_id]["step"] = 5
    elif step == 5:
        user_states[user_id]["budget"] = user_message
        # プレゼント提案を生成する（ここではChatGPTで処理）
        conversation_history = get_conversation_history(user_id)
        chatgpt_response = process_message(user_id, user_message, conversation_history)
        product_suggestions = search_products(chatgpt_response)
        user_states[user_id]["suggestions"] = product_suggestions
        reply_message = "あなたの情報に基づいて、以下のプレゼントを提案します！\n" + "\n".join(product_suggestions) + "\nもっと詳しく知りたい商品番号を教えてください。または、再提案を希望する場合は「再提案」と入力してください。"
        user_states[user_id]["step"] = 6
    elif step == 6:
        if user_message.lower() == "再提案":
            reply_message = "新しい提案を準備します。少々お待ちください..."
            user_states[user_id]["step"] = 5  # 再提案のため予算の確認ステップに戻る
        else:
            suggestion_index = int(user_message.split("提案")[1]) - 1
            reply_message = f"{user_states[user_id]['suggestions'][suggestion_index]}の詳細はこちらです：..."
            user_states[user_id]["step"] = 7
    elif step == 7:
        if user_message.lower() == "購入":
            reply_message = "購入手続きに進みます。以下のリンクから購入ページにアクセスしてください：..."
        elif user_message.lower() == "質問":
            reply_message = "ご質問をどうぞ。"
        else:
            reply_message = "本日はご利用ありがとうございました！またのご利用をお待ちしております。ご意見やご感想がありましたら教えてくださいね。"
            user_states[user_id]["step"] = 0  # 初期ステップに戻す

    logging.info(f"Replying to user {user_id} with message: {reply_message}")

    save_message(user_id, user_message, reply_message)
    line_bot_api.reply_message(
        event.reply_token,
        TextSendMessage(text=reply_message)
    )
