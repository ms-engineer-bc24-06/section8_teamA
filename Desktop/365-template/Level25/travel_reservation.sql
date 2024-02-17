-- エンティティ作成
/* 顧客情報 */
-- 会員ランク、クーポン情報
CREATE TABLE Memberships (
    id INT PRIMARY KEY NOT NULL,
    member_rank VARCHAR(20),
    discount_rate DECIMAL NOT NULL
);
-- 名前、パスワード
CREATE TABLE Users (
    id INT PRIMARY KEY NOT NULL,
    name VARCHAR(20) NOT NULL,
    password VARCHAR(64) NOT NULL,
    membership_id INT,
    FOREIGN KEY (membership_id) REFERENCES Memberships(id)
);

/* 支払い */
-- 支払い方法、支払い状況
CREATE TABLE Payments (
    id INT PRIMARY KEY NOT NULL,
    payment_type VARCHAR(10) NOT NULL,
    payment_status VARCHAR(5) NOT NULL
);

/* ホテル情報 */
-- 部屋タイプ、空室情報
CREATE TABLE RoomTypes (
    id INT PRIMARY KEY NOT NULL,
    room_type VARCHAR(20) NOT NULL,
    available BOOLEAN
);
-- ホテル名
CREATE TABLE Hotels (
    id INT PRIMARY KEY NOT NULL,
    name VARCHAR(30) NOT NULL,
    room_type_id INT,
    FOREIGN KEY (room_type_id) REFERENCES RoomTypes(id)
);

/* 予約状況 */
-- キャンセル状況
CREATE TABLE Cancellations (
    id INT PRIMARY KEY NOT NULL,
    cancellation BOOLEAN,
    reason VARCHAR(100) 
);
-- 予約状況詳細
CREATE TABLE Reservations (
    id INT PRIMARY KEY NOT NULL,
    user_id INT,
    checkin DATE NOT NULL,
    checkout DATE NOT NULL,
    payment_id INT,
    hotel_id INT,
    cancellation_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (payment_id) REFERENCES Payments(id),
    FOREIGN KEY (hotel_id) REFERENCES Hotels(id),
    FOREIGN KEY (cancellation_id) REFERENCES Cancellations(id)
);

-- テーブルの設定変更 => ALTER TABLE [テーブル名] ADD [追加カラム名] [型];
    /* 予約テーブルにユーザーテーブルのidを外部キーとして追加する場合 */
    ALTER TABLE Reservations
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES Users(id);

    /* クーポンデーブルの割引率のデータ型を固定小数点に変更する場合 */
    ALTER TABLE Memberships
    MODIFY COLUMN discount_rate DECIMAL;

-- テーブルの削除 => DROP TABLE [テーブル名]
    DROP TABLE Memberships;
-- テーブルが存在する時のみテーブル削除 => DROP TABLE IF EXISTS [テーブル名]
    DROP TABLE IF EXISTS Memberships;

-- データの追加 => INSERT INTO [テーブル名] [フィールド名] VALUES [値]
    /* 会員テーブルに３種類の会員情報を追加 */
    -- 一行ずつ追加
    INSERT INTO Memberships (id,member_rank,discount_rate) VALUES ('1','ゲスト','0.1');
    INSERT INTO Memberships (id,member_rank,discount_rate) VALUES ('2','一般会員','0.3');
    INSERT INTO Memberships (id,member_rank,discount_rate) VALUES ('3','プレミア会員','0.5');
    -- まとめて追加
    INSERT INTO Memberships VALUES ('1','ゲスト','0.1'),('2','一般会員','0.3'),('3','プレミア会員','0.5');

-- データの削除 => TRUNCATE TABLE [テーブル名] ,DELETE FROM [テーブル名] WHERE [条件式]
   /* 会員テーブル内の全データを削除 */
   TRUNCATE TABLE Memberships;  --    ロールバック不可、処理速度が早い、条件指定不可、外部キー参照を解除しないと使えない
   DELETE FROM Memberships;     --    ロールバック可、処理速度が遅い、条件指定可
   /* 会員テーブル内の一般会員データを削除 */
   DELETE FROM Memberships WHERE id = 2;

-- データの更新 => UPDATE [テーブル名] SET [フィールド名]=[値] WHERE [条件式]
   /* プレミア会員の割引率を更新 */
   UPDATE Memberships SET discount_rate = 0.4 WHERE id = 3;