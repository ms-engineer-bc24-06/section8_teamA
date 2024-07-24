import mysql.connector
from mysql.connector import Error
import os
from dotenv import load_dotenv
import logging

# 環境変数の読み込み
load_dotenv()

# ロギングの設定
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def create_connection():
    """MySQLデータベースへの接続を作成する関数"""
    try:
        connection = mysql.connector.connect(
            host=os.getenv("DB_HOST"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            database=os.getenv("DB_NAME")
        )
        if connection.is_connected():
            logger.info("Database connection established.")
            return connection
    except Error as e:
        logger.error(f"Error: {e}")
    return None

def close_connection(connection):
    """MySQLデータベース接続をクローズする関数"""
    if connection and connection.is_connected():
        try:
            connection.close()
            logger.info("Database connection closed.")
        except Error as e:
            logger.error(f"Error closing connection: {e}")

