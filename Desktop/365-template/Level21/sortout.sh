#!/bin/bash

# ダウンロードフォルダのパス
DOWNLOADS_DIR="/Users/tsukudasayoko/downloads"

# ダウンロードフォルダ内のファイルをループ処理
for file in "$DOWNLOADS_DIR"/*; do

    if [[ -f "$file" ]]; then
        # ファイルの作成日を取得（%Y-%m-%d形式の日付）
        file_date=$(date -r "$file" +%Y-%m-%d)

        # ファイルの拡張子を取得
        file_extension=${file##*.}

        # 同じ名前のファイルの存在確認
        if [ ! -e "$DOWNLOADS_DIR/$file_extension/$file_date" ]; then
            # ファイルが存在する日付のフォルダを作成
            mkdir -p "$DOWNLOADS_DIR/$file_extension/$file_date"
        fi
    
        # ファイルを日付のフォルダに移動 (同一ファイルがあれば上書きするかどうか確認)
        read -p "同名ファイルが存在します。上書きしますか？（yes/no): " overwrite_decision
        if [ "$overwrite_decision" == "yes" ]; then
            mv "$file" "$DOWNLOADS_DIR/$file_extension/$file_date/"
            echo "Moved $file to $DOWNLOADS_DIR/$file_extension/$file_date/"
        else
            echo "上書きを中止しました。"
        fi

    else 
        echo "移動が必要なファイルはありません。"
    fi

done
