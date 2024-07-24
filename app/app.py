# from flask import Flask, request, abort
# from linebot import LineBotApi, WebhookHandler
# from linebot exceptions import InvalidSignatureError
# from linebot models import MessageEvent, TextMessage, TextSendMessage
# import openai
# import os
# from dotenv import load_dotenv
# import logging
# from database import create_connection, close_connection

# # 環境変数の読み込み
# load_dotenv()

# # Flaskアプリケーションの設定
# app = Flask(__name__)

# # LINE API設定
# line_bot_api = LineBotApi(os.getenv("CHANNEL_ACCESS_TOKEN"))
# handler = WebhookHandler(os.getenv("CHANNEL_SECRET"))

# # OpenAI API設定
# openai.api_key = os.getenv("OPENAI_API_KEY")

# # ロギングの設定
# logging.basicConfig(level=logging.INFO)
# logger = logging.getLogger(__name__)

# @app.route("/callback", methods=["POST"])
# def callback():
#     signature = request.headers.get("X-Line-Signature")
#     body = request.get_data(as_text=True)

#     try:
#         handler.handle(body, signature)
#     except InvalidSignatureError:
#         logger.error("Invalid signature error.")
#         abort(400)
#     return "OK"

# @handler.add(MessageEvent, message=TextMessage)
# def handle_message(event):
#     user_id = event.source.user_id
#     user_message = event.message.text

#     try:
#         # データベース接続の作成
#         connection = create_connection()
#         cursor = connection.cursor()

#         # ユーザー情報の保存
#         cursor.execute("INSERT IGNORE INTO users (user_id) VALUES (%s)", (user_id,))
#         connection.commit()

#         # 過去のメッセージ履歴の取得
#         cursor.execute("SELECT message, response FROM messages WHERE user_id = %s", (user_id,))
#         messages = cursor.fetchall()

#         conversation_history = "\n".join([f"{row['message']}: {row['response']}" for row in messages])

#         # ChatGPTにメッセージを送信
#         response = openai.ChatCompletion.create(
#             model="gpt-4",
#             messages=[
#                 {"role": "system", "content": "You are a helpful assistant."},
#                 {"role": "user", "content": conversation_history},
#                 {"role": "user", "content": user_message}
#             ]
#         )

#         reply_text = response.choices[0].message['content']

#         # メッセージと応答を保存
#         cursor.execute(
#             "INSERT INTO messages (user_id, message, response) VALUES (%s, %s, %s)",
#             (user_id, user_message, reply_text)
#         )
#         connection.commit()
#     except Exception as e:
#         logger.error(f"An error occurred: {e}")
#         reply_text = "Sorry, I couldn't process your request."
#     finally:
#         # データベース接続のクローズ
#         cursor.close()
#         close_connection(connection)

#     # LINEに返信
#     try:
#         line_bot_api.reply_message(
#             event.reply_token,
#             TextSendMessage(text=reply_text)
#         )
#     except Exception as e:
#         logger.error(f"Failed to send message: {e}")

# if __name__ == "__main__":
#     app.run(host="0.0.0.0", port=5000)

# from flask import Flask, request, abort
# from linebot import LineBotApi, WebhookHandler
# from linebot.exceptions import InvalidSignatureError
# from linebot.models import MessageEvent, TextMessage, TextSendMessage
# import openai
# import os
# from dotenv import load_dotenv
# import logging
# from flask_sqlalchemy import SQLAlchemy
# from database import create_connection, close_connection

# # 環境変数の読み込み
# load_dotenv()

# # Flaskアプリケーションの設定
# app = Flask(__name__)

# # SQLAlchemyのデータベースURL設定
# app.config['SQLALCHEMY_DATABASE_URI'] = (
#     f"mysql+pymysql://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@"
#     f"{os.getenv('DB_HOST')}:{3306}/{os.getenv('DB_NAME')}"
# )
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False  # Optional: Turn off track modifications to avoid overhead

# # SQLAlchemyのインスタンスを作成
# db = SQLAlchemy(app)

# # LINE API設定
# line_bot_api = LineBotApi(os.getenv("CHANNEL_ACCESS_TOKEN"))
# handler = WebhookHandler(os.getenv("CHANNEL_SECRET"))

# # OpenAI API設定
# openai.api_key = os.getenv("OPENAI_API_KEY")

# # ロギングの設定
# logging.basicConfig(level=logging.INFO)
# logger = logging.getLogger(__name__)

# @app.route("/callback", methods=["POST"])
# def callback():
#     signature = request.headers.get("X-Line-Signature")
#     body = request.get_data(as_text=True)

#     try:
#         handler.handle(body, signature)
#     except InvalidSignatureError:
#         logger.error("Invalid signature error.")
#         abort(400)
#     return "OK"

# @handler.add(MessageEvent, message=TextMessage)
# def handle_message(event):
#     user_id = event.source.user_id
#     user_message = event.message.text

#     try:
#         # データベース接続の作成
#         connection = create_connection()
#         cursor = connection.cursor()

#         # ユーザー情報の保存
#         cursor.execute("INSERT IGNORE INTO users (user_id) VALUES (%s)", (user_id,))
#         connection.commit()

#         # 過去のメッセージ履歴の取得
#         cursor.execute("SELECT message, response FROM messages WHERE user_id = %s", (user_id,))
#         messages = cursor.fetchall()

#         # 会話履歴の作成
#         conversation_history = "\n".join([f"{row[0]}: {row[1]}" for row in messages])

#         # ChatGPTにメッセージを送信
#         response = openai.ChatCompletion.create(
#             model="gpt-4",
#             messages=[
#                 {"role": "system", "content": "You are a helpful assistant."},
#                 {"role": "user", "content": conversation_history},
#                 {"role": "user", "content": user_message}
#             ]
#         )

#         reply_text = response.choices[0].message['content']

#         # メッセージと応答を保存
#         cursor.execute(
#             "INSERT INTO messages (user_id, message, response) VALUES (%s, %s, %s)",
#             (user_id, user_message, reply_text)
#         )
#         connection.commit()
#     except Exception as e:
#         logger.error(f"An error occurred: {e}")
#         reply_text = "Sorry, I couldn't process your request."
#     finally:
#         # データベース接続のクローズ
#         cursor.close()
#         close_connection(connection)

#     # LINEに返信
#     try:
#         line_bot_api.reply_message(
#             event.reply_token,
#             TextSendMessage(text=reply_text)
#         )
#     except Exception as e:
#         logger.error(f"Failed to send message: {e}")

# if __name__ == "__main__":
#     app.run(host="0.0.0.0", port=5000)

from flask import Flask, request, abort, jsonify
from linebot import LineBotApi, WebhookHandler
from linebot.exceptions import InvalidSignatureError
from linebot.models import MessageEvent, TextMessage, TextSendMessage
import openai
import os
from dotenv import load_dotenv
import logging
from flask_sqlalchemy import SQLAlchemy
from database import create_connection, close_connection

# 環境変数の読み込み
load_dotenv()

# Flaskアプリケーションの設定
app = Flask(__name__)

# SQLAlchemyのデータベースURL設定
app.config['SQLALCHEMY_DATABASE_URI'] = (
    f"mysql+pymysql://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@"
    f"{os.getenv('DB_HOST')}:{3306}/{os.getenv('DB_NAME')}"
)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False  # Optional: Turn off track modifications to avoid overhead

# SQLAlchemyのインスタンスを作成
db = SQLAlchemy(app)

# LINE API設定
line_bot_api = LineBotApi(os.getenv("CHANNEL_ACCESS_TOKEN"))
handler = WebhookHandler(os.getenv("CHANNEL_SECRET"))

# OpenAI API設定
openai.api_key = os.getenv("OPENAI_API_KEY")

# ロギングの設定
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route("/callback", methods=["POST"])
def callback():
    signature = request.headers.get("X-Line-Signature")
    body = request.get_data(as_text=True)

    try:
        handler.handle(body, signature)
    except InvalidSignatureError:
        logger.error("Invalid signature error.")
        abort(400)
    return "OK"

@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    user_id = event.source.user_id
    user_message = event.message.text

    try:
        # データベース接続の作成
        connection = create_connection()
        cursor = connection.cursor()

        # ユーザー情報の保存
        cursor.execute("INSERT IGNORE INTO users (user_id) VALUES (%s)", (user_id,))
        connection.commit()

        # 過去のメッセージ履歴の取得
        cursor.execute("SELECT message, response FROM messages WHERE user_id = %s", (user_id,))
        messages = cursor.fetchall()

        # 会話履歴の作成
        conversation_history = "\n".join([f"{row[0]}: {row[1]}" for row in messages])

        # ChatGPTにメッセージを送信
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": conversation_history},
                {"role": "user", "content": user_message}
            ]
        )

        reply_text = response.choices[0].message['content']

        # メッセージと応答を保存
        cursor.execute(
            "INSERT INTO messages (user_id, message, response) VALUES (%s, %s, %s)",
            (user_id, user_message, reply_text)
        )
        connection.commit()
    except Exception as e:
        logger.error(f"An error occurred: {e}")
        reply_text = "Sorry, I couldn't process your request."
    finally:
        # データベース接続のクローズ
        cursor.close()
        close_connection(connection)

    # LINEに返信
    try:
        line_bot_api.reply_message(
            event.reply_token,
            TextSendMessage(text=reply_text)
        )
    except Exception as e:
        logger.error(f"Failed to send message: {e}")

# テスト用エンドポイントの追加
@app.route("/add_message", methods=["POST"])
def add_message():
    data = request.json
    user_id = data.get('user_id')
    message = data.get('message')
    response = data.get('response')
    
    if not user_id or not message or not response:
        return jsonify({"error": "Missing data"}), 400
    
    try:
        # データベース接続の作成
        connection = create_connection()
        cursor = connection.cursor()
        
        # メッセージと応答をデータベースに追加
        cursor.execute(
            "INSERT INTO messages (user_id, message, response) VALUES (%s, %s, %s)",
            (user_id, message, response)
        )
        connection.commit()
        
        return jsonify({"message": "Message added successfully"}), 201
    except Exception as e:
        logger.error(f"An error occurred: {e}")
        return jsonify({"error": "Failed to add message"}), 500
    finally:
        # データベース接続のクローズ
        cursor.close()
        close_connection(connection)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)


