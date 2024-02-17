-- エンティティ作成
/* 顧客情報 */
-- 名前、メールアドレス、フォロー数、フォロワー数、パスワード
CREATE TABLE Users (
    id INT PRIMARY KEY NOT NULL,
    name VARCHAR(20) NOT NULL,
    email VARCHAR(40) NOT NULL,
    password VARCHAR(64) NOT NULL
);

/* フォロー機能 */
CREATE TABLE Relations (
    id INT PRIMARY KEY NOT NULL,
    followed_id INT NOT NULL,
    followers_id INT NOT NULL,
    FOREIGN KEY (followed_id) REFERENCES Users(id),
    FOREIGN KEY (followers_id) REFERENCES Users(id)
);

/* つぶやき機能 */
-- つぶやき投稿
CREATE TABLE Tweets (
    id INT PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    tweet VARCHAR(100) NOT NULL,
    date_time TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- コメント機能
CREATE TABLE Comments (
    id INT PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    comment VARCHAR(100) NOT NULL,
    date_time TIMESTAMP NOT NULL,
    tweet_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (tweet_id) REFERENCES Tweets(id)
);

-- いいね機能
CREATE TABLE Favorites (
    id INT PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    tweet_id INT NOT NULL,
    comment_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (tweet_id) REFERENCES Tweets(id),
    FOREIGN KEY (comment_id) REFERENCES Comments(id)
);

/* DM機能 */
-- ルームテーブル作成
CREATE TABLE Rooms (
    id INT PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);
-- DMテーブル作成
CREATE TABLE DMs (
    id INT PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    message VARCHAR(100) NOT NULL,
    date_time TIMESTAMP NOT NULL,
    room_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (room_id) REFERENCES Rooms(id)
);

-- 列定義の変更
-- NULL値を許可する
ALTER TABLE Favorites MODIFY COLUMN tweet_id INT;
ALTER TABLE Favorites MODIFY COLUMN comment_id INT;


-- データの追加
    /* Usersテーブルに情報を追加 */
    INSERT INTO Users VALUES (1,'Hitomi','Hitomi@mse.com','password1'),(2,'Sayoko','Sayoko@mse.com','password2'),(3,'Takumi','Takumi@mse.com','password3');
    INSERT INTO Users VALUES (4,'Kaito','Kaito@mse.com','password4'),(5,'Souma','Souma@mse.com','password5'),(6,'Akari','Akari@mse.com','password6');
    /* Tweetsテーブルに情報を追加 */
    INSERT INTO Tweets VALUES (1,1,'やるか！超やるか！！',now()),(2,2,'モンブラン美味しい',now()),(3,3,'Zehi!',now()); 
    /* Relationsテーブルに情報を追加 */
    INSERT INTO Relations VALUES (1,1,2),(2,1,3),(3,1,4),(4,5,4),(5,3,2),(6,3,6),(7,2,1),(8,5,1),(9,5,2),(10,5,3); 
    /* Commentsテーブルに情報を追加 */
    INSERT INTO Comments VALUES (1,5,'お疲れ様です！',now(),1),(2,3,'美味しそう！',now(),2);
    /* Favoritesテーブルに情報を追加 */ 
    INSERT INTO Favorites VALUES (1,2,1,2),(2,2,1,NULL),(3,2,1,NULL),(4,3,2,NULL),(5,1,3,NULL),(6,1,3,NULL),(7,6,2,1),(8,5,3,1),(9,4,2,2),(10,4,2,NULL);


-- ユーザーごとのフォロー数を集計する
    -- LEFT JOIN を使用して Users テーブルと Relations テーブルを結合し、ユーザーごとのフォロー数を COUNT 関数を使って集計(以下同様にフォロワー数、いいね数を集計)
    -- LEFT JOIN(左外部結合) を使うと左のテーブル(Users)は全て表示される
SELECT u.id, u.name, COUNT(r.followed_id) AS follow_count
FROM Users u
LEFT JOIN Relations r ON u.id = r.followed_id
GROUP BY u.id, u.name;

-- ユーザーごとのフォロワー数を集計する
SELECT u.id, u.name, COUNT(r.followers_id) AS followers_count
FROM Users u
LEFT JOIN Relations r ON u.id = r.followers_id
GROUP BY u.id, u.name;

-- ツイートごとのいいね数を集計する
SELECT t.id, t.tweet, COUNT(f.id) AS favorite_count
FROM Tweets t
LEFT JOIN Favorites f ON t.id = f.tweet_id
GROUP BY t.id, t.tweet;
