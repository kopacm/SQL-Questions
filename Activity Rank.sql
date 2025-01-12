"Find the email activity rank for each user. Email activity rank is defined by the total number of emails sent. 
The user with the highest number of emails sent will have a rank of 1, and so on. Output the user, total emails, and their activity rank.

•	Order records first by the total emails in descending order.
•	Then, sort users with the same number of emails in alphabetical order by their username.
•	In your rankings, return a unique value (i.e., a unique rank) even if multiple users have the same number of emails."


select 
from_user as user_name,
count(from_user) as num_emails,
row_number() over (order by count(from_user) desc,from_user) as ranking
from google_gmail_emails
group by from_user
