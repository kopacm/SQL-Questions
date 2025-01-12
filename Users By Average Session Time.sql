"Calculate each user's average session time, where a session is defined as the time difference 
between a page_load and a page_exit. Assume each user has only one session per day. If there are 
multiple page_load or page_exit events on the same day, use only the latest page_load and the earliest 
page_exit, ensuring the page_load occurs before the page_exit. Output the user_id and their average session time."

select
user_id,
avg(session_duration) as session_time

from (
SELECT
 user_id,
timestamp,
IF(action = 'page_load', @last_load := timestamp, NULL) AS load_time,
IF(action = 'page_exit' AND @user_id = user_id AND @last_load 
IS NOT NULL, timestampDIFF(SECOND, @last_load, timestamp), NULL) 
AS session_duration,
@user_id := user_id
FROM facebook_web_log
ORDER BY user_id, timestamp
) as session
where session_duration is not null
group by user_id
