# level25 
## 課題１

- 環境構築
　1.docker-composeファイルの作成、保存

```
<!-- 設定内容 -->
<!-- Docker composeのバージョンとサービスの定義 -->
<!-- Docker Composeバージョン3を使用、1つのサービス db が定義されている -->
version: "3"
services:
  db:  

  <!-- MySQLコンテナの設定 -->
    image: mysql:5.7       <!-- MySQLのDockerイメージを使用し、バージョン5.7を指定 -->
    restart: always         <!-- コンテナが停止した場合に自動的に再起動 -->
    platform: linux/x86_64  <!-- コンテナが動作するプラットフォームを指定 -->

    <!-- ホストのポート 3306 をコンテナのポート 3306 にマッピング -->
    <!-- ホストの 3306 ポートに接続すると、コンテナ内のMySQLが使用できる -->
    ports:
      - "3306:3306"

 <!-- 環境変数の設定 -->
    environment:
      MYSQL_ROOT_PASSWORD: password     <!-- rootユーザーのパスワード指定 -->
      MYSQL_DATABASE: bluegold      <!-- データベースの名前（bluegold）の指定 -->
      MYSQL_USER: admin             <!-- 新しいユーザー名（admin）を指定 -->
      MYSQL_PASSWORD: password      <!-- 新しいユーザー admin のパスワードを指定 -->

    <!-- MySQLデータベースのデータを永続化するためのボリュームを設定 -->
    <!-- mysql_data という名前のボリュームが作成され、MySQLのデータはホストマシンの /var/lib/mysql に保存される -->
    volumes:
      - mysql_data:/var/lib/mysql

 <!-- ボリュームの定義 -->
 <!-- ボリューム mysql_data を定義 => データがボリュームに永続的に保存され、コンテナが再起動してもデータが失われない -->
 volumes:
  mysql_data:

```

　2.上記１で作成したファイル（docker-compose.yml）を保存したディレクトリに移動
　3. docker-composeファイルの起動

    ```
    docker-compose -f /Users/tsukudasayoko/Desktop/365-template/Level25/docker-compose.yml up
    ```

- MySQL dockerコンテナのデータベースへ接続
    Workbenchを使い、GUIで接続（下記サイト参考）
    [【MySQL】MySQL Workbench 使い方 - Qiita](https://qiita.com/oden141/items/b6e754f3b788343c4896)

- データベースの作成
    - ER図：<https://drive.google.com/file/d/1Kaa619_vQ-4FhltawX30SB9g40cdSueU/view?usp=sharing>
    - 旅行予約テーブルSQL：travel_reservation.sql
    - つぶやきテーブルSQL:tweet.sql

    SQLでテーブルの作成、データの追加等の操作を行う（下記サイト参考）
    [よく使うMySQLコマンド&構文集 - Qiita](https://qiita.com/CyberMergina/items/f889519e6be19c46f5f4)
