"Calculate the friend acceptance rate for each date when friend requests were sent. 
A request is sent if action = sent and accepted if action = accepted. 
If a request is not accepted, there is no record of it being accepted in the table. 
The output will only include dates where requests were sent and at least one of them was accepted, 
as the acceptance rate can only be calculated for those dates. Show the results ordered from the earliest to the latest date."

  
"multiple WITH separate by ',' for second one don't use WITH again"
with sent as
(select *  from fb_friend_requests where action='sent'),
accepted as
(select *  from fb_friend_requests  where action='accepted')
select  sent.date,
count(accepted.user_id_receiver)/count(sent.user_id_sender) as ratio
from sent 
"left join for that reason because there will be always more or same sent request than accepted" 
left join accepted on sent.user_id_sender= accepted.user_id_sender and sent.user_id_receiver= accepted.user_id_receiver 
group by date
