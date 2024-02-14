use ig_clone;

-- 1. find the 5 oldest users

select * from users;

select *
from users
order by created_at asc
limit 5;

-- 2.  What day of the week do most users register on? We need to figure out when to schedule an ad campaign

SELECT 
    DAYNAME(created_at) AS day_of_week,
    COUNT(*) AS total_registrations
FROM users
GROUP BY day_of_week
ORDER BY total_registrations DESC
LIMIT 1;
-- the campaign can be schedules on thrusday

-- 3. We want to target our inactive users with an email campaign.Find the users who have never posted a photo

SELECT u.id, u.username, u.created_at
FROM users u
LEFT JOIN photos p ON u.id = p.user_id
WHERE p.id IS NULL;

-- 4.We're running a new contest to see who can get the most likes on a single photo.WHO WON??!!
 
select * from likes;

select user_id, photo_id , count(*) as total_likes
from likes
group by user_id, photo_id
order by total_likes asc
limit 1;

-- 5. Our Investors want to know… How many times does the average user post?HINT - *total number of photos/total number of users*

-- Calculate the average number of times each user posts
SELECT COUNT(*) AS total_photos
FROM photos;

SELECT COUNT(*) AS total_users
FROM users;

SELECT
  (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS average_posts_per_user;
  
  
  -- 6. user ranking by postings higher to lower
  
  select * from users;
  select * from photos;

SELECT
  u.username,
  COUNT(p.id) AS num_postings
FROM
  users u
LEFT JOIN
  photos p ON u.id = p.user_id
GROUP BY
  u.username
ORDER BY
  num_postings DESC;
  
  -- 7. total numbers of users who have posted at least one time.

SELECT COUNT(DISTINCT user_id) AS total_users_with_posts
FROM photos;

-- 8. A brand wants to know which hashtags to use in a post

select tag_name
from tags;


-- 9. What are the top 5 most commonly used hashtags?

select tag_name
from tags
order by tag_name desc
 limit 5;

-- 10. We have a small problem with bots on our site...Find users who have liked every single photo on the site .

SELECT DISTINCT l.user_id
FROM likes l
LEFT JOIN photos p ON l.photo_id = p.id
GROUP BY l.user_id
HAVING COUNT(DISTINCT p.id) = (SELECT COUNT(*) FROM photos);

-- 11. Find users who have never commented on a photo.

SELECT u.id, u.username
FROM users u
LEFT JOIN comments c ON u.id = c.user_id
WHERE c.user_id IS NULL;

