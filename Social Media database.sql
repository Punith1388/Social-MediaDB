CREATE DATABASE SocialMediaDB;
USE SocialMediaDB;


CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE Posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);




CREATE TABLE Comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);


CREATE TABLE Likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (post_id, user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);



CREATE TABLE Followers (
    follower_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    follower_user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, follower_user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (follower_user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

show tables;
select * from Users;
select * from Posts;
select * from Comments;
select * from Likes;
select * from Followers;


-- Users
INSERT INTO Users (username, email, full_name) VALUES
('john_doe', 'john@example.com', 'John Doe'),
('jane_smith', 'jane@example.com', 'Jane Smith'),
('alex_w', 'alex@example.com', 'Alex White');

-- Posts
INSERT INTO Posts (user_id, content) VALUES
(1, 'Enjoying my vacation!'),
(2, 'Learning MySQL is fun!'),
(3, 'Check out my new blog post.');

-- Comments
INSERT INTO Comments (post_id, user_id, comment_text) VALUES
(1, 2, 'Looks awesome!'),
(2, 1, 'Totally agree with you.');

-- Likes
INSERT INTO Likes (post_id, user_id) VALUES
(1, 2),
(1, 3),
(2, 1),
(2, 3),
(3, 1);

-- Followers
INSERT INTO Followers (user_id, follower_user_id) VALUES
(1, 2),
(1, 3),
(2, 1),
(3, 1);



-- Trending posts
SELECT p.post_id, p.content, u.username, COUNT(l.like_id) AS like_count
FROM Posts p
JOIN Users u ON p.user_id = u.user_id
LEFT JOIN Likes l ON p.post_id = l.post_id
GROUP BY p.post_id
ORDER BY like_count DESC
LIMIT 5;

-- Active users
SELECT u.username, 
       COUNT(DISTINCT p.post_id) AS total_posts,
       COUNT(DISTINCT c.comment_id) AS total_comments,
       (COUNT(DISTINCT p.post_id) + COUNT(DISTINCT c.comment_id)) AS activity_score
FROM Users u
LEFT JOIN Posts p ON u.user_id = p.user_id
LEFT JOIN Comments c ON u.user_id = c.user_id
GROUP BY u.user_id
ORDER BY activity_score DESC
LIMIT 5;