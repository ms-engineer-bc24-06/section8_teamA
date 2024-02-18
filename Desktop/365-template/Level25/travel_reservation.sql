-- エンティティ作成
/* 顧客情報 */
-- 会員ランク、クーポン情報
CREATE TABLE Memberships (
    id INT PRIMARY KEY NOT NULL,
    member_rank VARCHAR(20),
    discount_rate DECIMAL(3,2) NOT NULL
);
-- 名前、パスワード
CREATE TABLE Users (
    id INT PRIMARY KEY NOT NULL,
    name VARCHAR(20) NOT NULL,
    password VARCHAR(64),
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
-- ホテル名
CREATE TABLE Hotels (
    id INT PRIMARY KEY NOT NULL,
    name VARCHAR(30) NOT NULL
);

-- 部屋タイプ、空室情報
CREATE TABLE RoomTypes (
    id INT PRIMARY KEY NOT NULL,
    hotel_id INT NOT NULL,
    room_type VARCHAR(20) NOT NULL,
    available BOOLEAN,
    price INT NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES Hotels(id)
);

/* 予約状況 */
-- 予約状況詳細
CREATE TABLE Reservations (
    id INT PRIMARY KEY NOT NULL,
    user_id INT,
    checkin DATE NOT NULL,
    checkout DATE NOT NULL,
    payment_id INT,
    room_type_id INT,
    cancellation BOOLEAN,
    option_charge INT,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (payment_id) REFERENCES Payments(id),
    FOREIGN KEY (hotel_id) REFERENCES Hotels(id)
);

-- テーブルの設定変更 => ALTER TABLE [テーブル名] ADD [追加カラム名] [型];
    /* 予約テーブルにユーザーテーブルのidを外部キーとして追加する場合 */
    ALTER TABLE Reservations ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES Users(id);

    /* クーポンデーブルの割引率のデータ型を固定小数点に変更する場合 */
    ALTER TABLE Memberships MODIFY COLUMN discount_rate DECIMAL(3,2);

    /* RoomTypesテーブルに値段を追加する場合 */
    ALTER TABLE RoomTypes ADD price INT;

-- テーブルの削除 => DROP TABLE [テーブル名]
    DROP TABLE Memberships;
-- テーブルが存在する時のみテーブル削除 => DROP TABLE IF EXISTS [テーブル名]
    DROP TABLE IF EXISTS Memberships;

-- データの追加 => INSERT INTO [テーブル名] [フィールド名] VALUES [値]
    /* Membershipsテーブルに３種類の会員情報を追加 */
    -- 一行ずつ追加
    INSERT INTO Memberships (id,member_rank,discount_rate) VALUES (1,'ゲスト',0);
    INSERT INTO Memberships (id,member_rank,discount_rate) VALUES (2,'一般会員',0.1);
    INSERT INTO Memberships (id,member_rank,discount_rate) VALUES (3,'プレミア会員',0.3);

    -- まとめて追加
    INSERT INTO Memberships VALUES (1,'ゲスト',0),(2,'一般会員',0.1),(3,'プレミア会員',0.3);

    -- ユーザー情報追加
    INSERT INTO Users VALUES (1,'Hitomi',NULL,1),(2,'Sayoko','password2',2),(3,'Takumi','password3',3);

    -- ホテル情報追加
    INSERT INTO RoomTypes VALUES (1, 22, 'シングル', FALSE, 8000), (2, 22, 'ツイン', TRUE, 16000), (3, 22, 'トリプル', TRUE, 24000);
    INSERT INTO RoomTypes VALUES (4, 11, 'シングル', FALSE, 10000), (5, 11, 'ツイン', TRUE, 20000), (6, 11, 'トリプル', TRUE, 30000);
    INSERT INTO RoomTypes VALUES (7, 33, 'シングル', FALSE, 15000), (8, 33, 'ツイン', TRUE, 30000), (9, 33, 'トリプル', TRUE, 90000);

    INSERT INTO Hotels VALUES (11,'ヒルトン'),(22,'アパ'),(33,'ミラコスタ');

    -- 決済情報追加
    INSERT INTO Payments VALUES (100,'クレジットカード','完了'),(101,'現地','未完了'),(102,'現地','未完了');

    -- 予約情報追加
    INSERT INTO Reservations VALUES (1, 1, '2022-07-12', '2022-07-14', 100, 11, FALSE, NULL),
                                 (2, 2, '2022-07-21', '2022-07-24', 101, 22, FALSE, 8000),
                                 (3, 3, '2022-08-12', '2022-08-14', 102, 33, TRUE, NULL);


-- データの削除 => TRUNCATE TABLE [テーブル名] ,DELETE FROM [テーブル名] WHERE [条件式]
   /* Membershipsテーブル内の全データを削除 */
   TRUNCATE TABLE Memberships;  --    ロールバック不可、処理速度が早い、条件指定不可、外部キー参照を解除しないと使えない
   DELETE FROM Memberships;     --    ロールバック可、処理速度が遅い、条件指定可
   /* Membershipsテーブル内の一般会員データを削除 */
   DELETE FROM Memberships WHERE id = 2;

-- データの更新 => UPDATE [テーブル名] SET [フィールド名]=[値] WHERE [条件式]
   /* プレミア会員の割引率を更新 */
   UPDATE Memberships SET discount_rate = 0.4 WHERE id = 3;


-- データ操作
-- 消費税率を変数として定義
    SET @tax_rate := 0.1;

-- 支払い金額計算
    SELECT
        r.id As reservation_id,
        u.id As user_id,
        r.checkin As checkin_date,
        r.checkout As checkout_date,
        r.room_type_id,
        h.name As hotel_name,
        -- 部屋料金を計算（RoomTypeテーブルprice * 宿泊日数）
        rt.room_type,
        rt.available,
        rt.price * (DATEDIFF(r.checkout,r.checkin)) As room_charge,
        -- 会員ランクごとの割引率を取得
        m.discount_rate,
        -- 割引後の部屋料金を計算
        (rt.price * (DATEDIFF(r.checkout, r.checkin))) * (1 - m.discount_rate) AS discounted_room_charge,
        -- オプション料金・消費税の加算
        ((rt.price * (DATEDIFF(r.checkout,r.checkin))) * (1 - m.discount_rate) + r.option_charge) * (1 + @tax_rate) As total_payment_amount
        FROM 
            Reservations r
        INNER JOIN 
            Users u ON r.user_id = u.id
        INNER JOIN 
            Memberships m ON u.membership_id = m.id
        INNER JOIN 
            RoomTypes rt ON r.room_type_id = rt.id
        INNER JOIN
            Hotels h ON rt.hotel_id = h.id
        INNER JOIN
            Payments p ON r.payment_id = p.id
        WHERE
            r.id = 2;

