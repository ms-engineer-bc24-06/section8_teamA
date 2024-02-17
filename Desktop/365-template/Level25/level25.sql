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
    tweet_id INT NOT NULL,
    comment VARCHAR(100) NOT NULL,
    date_time TIMESTAMP NOT NULL,
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