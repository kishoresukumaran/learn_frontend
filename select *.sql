select *
from orders
where merchant_id = "749103" and client_created_time between "2019-05-01 00:00" and "2019-05-16 23:59";

#counting the number of orders on a specific time frame based on merchant
select merchant_id, count(id) order_count
from orders
where merchant_id = "749103" and client_created_time between "2019-05-01 00:00" and "2019-05-16 23:59"
GROUP BY merchant_id;

#looking at payment data for a specific time frame 
select b.*
from orders a
join payment b on b.order_id = a.id
where a.merchant_id = "749103" and a.client_created_time between "2019-05-01 00:00" and "2019-05-16 23:59"
order by b.client_created_time desc;

#finding the uuid and serial of devices 
select a.uuid, c.serial
from orders a
join payment b on b.order_id = a.id
join meta.device c on b.device_id = c.id
where a.merchant_id = "749103" and a.client_created_time between "2019-05-01 00:00" and "2019-05-16 23:59"
order by b.client_created_time desc;

#use for finding account id basedb on role
select * from merchant_role mr 
join account a on a.id = mr.account_id 
where account_id=48115;

#BULLDOG find the shard where the data is located and the merchant and so on 
SELECT orders_shard_id shard_num,
m.id AS m_id,mg.id AS mg_id,m.name AS MerchantName,m.uuid AS CID,
    SUBSTRING_INDEX(mg.partner_uuid,':',1) AS MID,
    SUBSTRING_INDEX(substring_index(partner_uuid,':',-2),':',1) AS TID,
    CASE WHEN mg.config NOT LIKE '%group_id%' THEN NULL ELSE SUBSTRING_INDEX(SUBSTRING_INDEX(mg.config,'\"group_id\"\:\"',-1),'\"',1) END AS GroupID,
    CASE WHEN mg.config NOT LIKE '%debit_key_code%' THEN NULL ELSE SUBSTRING_INDEX(SUBSTRING_INDEX(mg.config,'\"debit_key_code\"\:\"',-1),'\"',1) END AS DebitKeyCode,
    CASE WHEN mg.config NOT LIKE '%bemid%' THEN NULL ELSE SUBSTRING_INDEX(SUBSTRING_INDEX(mg.config,'\"bemid\"\:\"',-1),'\"',1) END AS BEMID,
    CASE WHEN mg.config NOT LIKE '%platform%' THEN NULL ELSE SUBSTRING_INDEX(SUBSTRING_INDEX(mg.config,'\"platform\"\:\"',-1),'\"',1) END AS Platform,
    r.name AS ResellerName,
    r.uuid AS ResellerUUID,
    m.created_time AS MerchantCreatedTime 
FROM meta.merchant m 
INNER JOIN meta.merchant_gateway mg ON m.merchant_gateway_id = mg.id 
INNER JOIN meta.reseller r ON m.reseller_id = r.id
INNER JOIN meta.merchant_placement mp ON m.id = mp.merchant_id
WHERE mg.config LIKE '%844215704884%'\G;

#Get primary account info for email address Self Boarding
select a.id as account_id, a.uuid as account_uuid, mr.id as merchant_role_id, a.email,
    m.id as merchant_id, m.uuid as merchant_uuid,
    CASE WHEN (a.primary_merchant_role_id = mr.id) THEN 1 ELSE 0 END as is_primary_account, m.`name`
    from meta.account a
    join meta.merchant_role mr on mr.account_id = a.id
    join meta.merchant m on m.id = mr.merchant_id
    where a.email = 'TEXASMARK@GMAIL.COM';
 
#Pull microshard and shard placement given merchant uuid:
select mp.merchant_id, mp.orders_shard_id as microshard,
case when mp.orders_shard_id in (0,1,2,3,4,5,6) then mp.orders_shard_id 
when mp.orders_shard_id in (111,124,137,150,163,176,189,20,202,33,46,59,7,72,85,98) then 7
when mp.orders_shard_id in (112,125,138,151,164,177,190,203,21,34,47,60,73,8,86,99) then 8
when mp.orders_shard_id in (100,113,126,139,152,165,178,191,204,22,35,48,61,74,87,9) then 9
when mp.orders_shard_id in (10,101,114,127,140,153,166,179,192,205,23,36,49,62,75,88) then 10
when mp.orders_shard_id in (102,11,115,128,141,154,167,180,193,206,24,37,50,63,76,89) then 11
when mp.orders_shard_id in (103,116,12,129,142,155,168,181,194,207,25,38,51,64,77,90) then 12
when mp.orders_shard_id in (104,117,13,130,143,156,169,182,195,208,26,39,52,65,78,91) then 13
when mp.orders_shard_id in (105,118,131,14,144,157,170,183,196,209,27,40,53,66,79,92) then 14
when mp.orders_shard_id in (106,119,132,145,15,158,171,184,197,210,28,41,54,67,80,93) then 15
when mp.orders_shard_id in (107,120,133,146,159,16,172,185,198,211,29,42,55,68,81,94) then 16
when mp.orders_shard_id in (108,121,134,147,160,17,173,186,199,212,30,43,56,69,82,95) then 17
when mp.orders_shard_id in (109,122,135,148,161,174,18,187,200,213,31,44,57,70,83,96) then 18
when mp.orders_shard_id in (110,123,136,149,162,175,188,19,201,214,32,45,58,71,84,97) then 19 
else null end as shard
from meta.merchant m join meta.merchant_placement mp on mp.merchant_id = m.id where m.uuid ='3HQFVKZCCXP11';

#Pull microshard and host placement given mid:
select m.uuid,mp.merchant_id, mp.orders_shard_id as microshard,
case when mp.orders_shard_id in (0,1,2,3,4,5,6) then mp.orders_shard_id 
when mp.orders_shard_id in (111,124,137,150,163,176,189,20,202,33,46,59,7,72,85,98) then 7
when mp.orders_shard_id in (112,125,138,151,164,177,190,203,21,34,47,60,73,8,86,99) then 8
when mp.orders_shard_id in (100,113,126,139,152,165,178,191,204,22,35,48,61,74,87,9) then 9
when mp.orders_shard_id in (10,101,114,127,140,153,166,179,192,205,23,36,49,62,75,88) then 10
when mp.orders_shard_id in (102,11,115,128,141,154,167,180,193,206,24,37,50,63,76,89) then 11
when mp.orders_shard_id in (103,116,12,129,142,155,168,181,194,207,25,38,51,64,77,90) then 12
when mp.orders_shard_id in (104,117,13,130,143,156,169,182,195,208,26,39,52,65,78,91) then 13
when mp.orders_shard_id in (105,118,131,14,144,157,170,183,196,209,27,40,53,66,79,92) then 14
when mp.orders_shard_id in (106,119,132,145,15,158,171,184,197,210,28,41,54,67,80,93) then 15
when mp.orders_shard_id in (107,120,133,146,159,16,172,185,198,211,29,42,55,68,81,94) then 16
when mp.orders_shard_id in (108,121,134,147,160,17,173,186,199,212,30,43,56,69,82,95) then 17
when mp.orders_shard_id in (109,122,135,148,161,174,18,187,200,213,31,44,57,70,83,96) then 18
when mp.orders_shard_id in (110,123,136,149,162,175,188,19,201,214,32,45,58,71,84,97) then 19 
else null end as shard
from meta.merchant m join meta.merchant_placement mp on mp.merchant_id = m.id 
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
where SUBSTRING_INDEX(mg.partner_uuid,':',1) = 215230035994;

#find the shard using mid 
select m.uuid, mp.merchant_id, mp.orders_shard_id as shard 
from meta.merchant m 
join meta.merchant_placement mp on mp.merchant_id = m.id 
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
where SUBSTRING_INDEX(mg.partner_uuid,':',1) = '487982932997';

#Get merchant_boarding_application for associated email
select * from meta.merchant_boarding_application mba 
join meta.merchant m on m.owner_account_id = mba.owner_account_id 
where m.id in ('1671245','1672389');

#super payment query
select
  d.serial, 
  o.device_id, 
  p.device_id, 
  o.uuid as order_uuid, 
  o.pay_type, 
  p.uuid as payment_uuid, 
  gt.response_code, 
  gt.response_message,  
  gt.client_id as TRANS_ID,
  gt.type,
  gt.entry_type,
  gt.captured,
  concat(gt.card_type,' ', gt.first4,'xxx', gt.last4) CardNum,
  gt.authcode,
  CASE WHEN gt.extra LIKE '%cvmResult%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(gt.extra,'\"cvmResult\"\:\"',-1),'\"',1) ELSE NULL END AS cvmResul,
  gt.amount*.01 as GTinitAMT,
  gt.adjust_amount*.01 as GT_TIP,
  p.amount*.01 as PayAMT, 
  p.tip_amount*.01 as PayTipAMT, 
  p.tax_amount*.01 as PayTX,
  p.cash_tendered*.01 as cash_tendered,
  p.result,
  mt.label, 
  CONVERT_TZ(p.client_created_time, '+00:00','-04:00') as payment_client_created_time,
  CONVERT_TZ(p.created_time, '+00:00','-04:00') as payment_server_created_time,
  CONVERT_TZ(o.client_created_time, '+00:00','-04:00') as order_client_created_time,
  CONVERT_TZ(o.created_time, '+00:00','-04:00') as order_server_created_time,
  p.offline,
  pr.id as payment_refund_id,
  pr.gateway_tx_id,
  CONVERT_TZ(pr.created_time, '+00:00','-04:00') as payment_refund_created_time,
  pr.reason as payment_refund_reason,
  concat(cc.first_name, ' ', cc.last_name ) name_on_card,
  concat(c.first_name, ' ', c.last_name ) customer_name
FROM payment p
JOIN orders o on p.order_id = o.id
JOIN meta.merchant_tender mt ON p.merchant_tender_id = mt.id
left JOIN refund r ON r.payment_id = p.id
left JOIN gateway_tx gt ON p.gateway_tx_id = gt.id
left JOIN payment_refund pr on pr.id = p.payment_refund_id
left JOIN meta.device d ON p.device_id = d.id
left JOIN customer c ON c.id = o.customer_id
left JOIN customer_card cc ON cc.gateway_tx_id = gt.id 
where p.uuid in ("D8MS4ZWN5DCWP")
order by o.created_time ASC;

#Scan 2 pay add
select pa.*, #pac.*, 
  d.serial, 
  o.device_id, 
  p.device_id, 
  o.uuid as order_uuid, 
  o.pay_type, 
  p.uuid as payment_uuid, 
  gt.response_code, 
  gt.response_message,  
  gt.client_id as TRANS_ID,
  gt.type,
  gt.entry_type,
  gt.captured,
  concat(gt.card_type,' ', gt.first4,'xxx', gt.last4) CardNum,
  gt.authcode,
  CASE WHEN gt.extra LIKE '%cvmResult%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(gt.extra,'\"cvmResult\"\:\"',-1),'\"',1) ELSE NULL END AS cvmResul,
  gt.amount*.01 as GTinitAMT,
  gt.adjust_amount*.01 as GT_TIP,
  p.amount*.01 as PayAMT, 
  p.tip_amount*.01 as PayTipAMT, 
  p.tax_amount*.01 as PayTX,
  p.cash_tendered*.01 as cash_tendered,
  p.result,
  mt.label, 
  CONVERT_TZ(p.client_created_time, '+00:00','-04:00') as payment_client_created_time,
  CONVERT_TZ(p.created_time, '+00:00','-04:00') as payment_server_created_time,
  CONVERT_TZ(o.client_created_time, '+00:00','-04:00') as order_client_created_time,
  CONVERT_TZ(o.created_time, '+00:00','-04:00') as order_server_created_time,
  p.offline,
  pr.id as payment_refund_id,
  pr.gateway_tx_id,
  CONVERT_TZ(pr.created_time, '+00:00','-04:00') as payment_refund_created_time,
  pr.reason as payment_refund_reason,
  concat(cc.first_name, ' ', cc.last_name ) name_on_card,
  concat(c.first_name, ' ', c.last_name ) customer_name
FROM payment p
JOIN orders o on p.order_id = o.id
JOIN meta.merchant_tender mt ON p.merchant_tender_id = mt.id
left JOIN refund r ON r.payment_id = p.id
left JOIN gateway_tx gt ON p.gateway_tx_id = gt.id
left JOIN payment_refund pr on pr.id = p.payment_refund_id
left JOIN meta.device d ON p.device_id = d.id
left JOIN customer c ON c.id = o.customer_id
left JOIN customer_card cc ON cc.gateway_tx_id = gt.id 
join payment_attribute pa on pa.payment_id = p.id
#join payment_additional_charge pac on p.id = pac.payment_id
where o.merchant_id = 2857515 AND o.client_created_time between '2021-12-01 00:00:00' and '2021-12-06 23:59:59' and pa.value = "s2p"#AND pac.additional_charge_id = 197000000000027 and pa.value = "s2p"
order by o.created_time ASC;

#for Merchant_id lookup for payments 
select
  d.serial, 
  o.device_id, 
  p.device_id, 
  o.uuid as order_uuid, 
  o.pay_type, 
  p.uuid as payment_uuid, 
  gt.response_code, 
  gt.response_message,  
  gt.client_id as TRANS_ID,
  gt.type,
  gt.entry_type,
  gt.captured,
  concat(gt.card_type,' ', gt.first4,'xxx', gt.last4) CardNum,
  gt.authcode,
  CASE WHEN gt.extra LIKE '%cvmResult%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(gt.extra,'\"cvmResult\"\:\"',-1),'\"',1) ELSE NULL END AS cvmResul,
  gt.amount*.01 as GTinitAMT,
  gt.adjust_amount*.01 as GT_TIP,
  p.amount*.01 as PayAMT, 
  p.tip_amount*.01 as PayTipAMT, 
  p.tax_amount*.01 as PayTX,
  p.cash_tendered*.01 as cash_tendered,
  p.result,
  mt.label, 
  CONVERT_TZ(p.client_created_time, '+00:00','-04:00') as payment_client_created_time,
  CONVERT_TZ(p.created_time, '+00:00','-04:00') as payment_server_created_time,
  CONVERT_TZ(o.client_created_time, '+00:00','-04:00') as order_client_created_time,
  CONVERT_TZ(o.created_time, '+00:00','-04:00') as order_server_created_time,
  p.offline,
  pr.id as payment_refund_id,
  pr.gateway_tx_id,
  CONVERT_TZ(pr.created_time, '+00:00','-04:00') as payment_refund_created_time,
  pr.reason as payment_refund_reason,
  concat(cc.first_name, ' ', cc.last_name ) name_on_card,
  concat(c.first_name, ' ', c.last_name ) customer_name
FROM payment p
JOIN orders o on p.order_id = o.id
JOIN meta.merchant_tender mt ON p.merchant_tender_id = mt.id
left JOIN refund r ON r.payment_id = p.id
left JOIN gateway_tx gt ON p.gateway_tx_id = gt.id
left JOIN payment_refund pr on pr.id = p.payment_refund_id
left JOIN meta.device d ON p.device_id = d.id
left JOIN customer c ON c.id = o.customer_id
left JOIN customer_card cc ON cc.gateway_tx_id = gt.id 
where o.merchant_id = "" AND o.client_created_time between '2021-01-03 00:00:00' and '2021-01-03 23:59:59' 
order by o.created_time ASC;

#Super Query but quick on Timeframe 
SELECT o.uuid
  ,o.total*.01 as order_amount
  ,do.serial as order_device
  ,p.uuid Payment_UUID
  ,p.amount *.01 as payment_amount 
  ,dp.serial as payment_device, 
  p.client_created_time as Payment_Time
  ,concat(gtx.first4, "XX",gtx.last4) as cardnum
  ,p.result
  ,gtx.type
  ,gtx.card_type
  ,gtx.response_code
  ,gtx.response_message
  ,gtx.state
  ,pr.reason
  ,gtx.authcode
FROM payment AS p 
INNER JOIN orders AS o FORCE INDEX (merchant_id)  ON p.order_id = o.id 
LEFT OUTER JOIN payment_service_charge As c on c.payment_id = p.id 
LEFT OUTER JOIN meta.account AS e ON p.account_id = e.id 
LEFT OUTER JOIN gateway_tx AS gtx ON p.gateway_tx_id = gtx.id 
LEFT OUTER JOIN meta.device dp ON p.device_id = dp.id
LEFT OUTER JOIN meta.device do ON o.device_id = do.id
LEFT OUTER JOIN payment_refund pr ON p.payment_refund_id = pr.id
WHERE o.merchant_id = 1476211 
 AND o.deleted_timestamp IS NULL
# AND p.payment_refund_id IS NOT NULL
#AND p.client_created_time > DATE_SUB(NOW(),INTERVAL 2 DAY)
#AND p.client_created_time < now()
#AND o.modified_time >= DATE_SUB(NOW(),INTERVAL 2 DAY)
AND p.client_created_time > "2021-06-13 22:00:00"
AND p.client_created_time < "2021-06-14 23:59:00"
AND o.modified_time >= "2021-05-02 05:00:00"
ORDER BY p.client_created_time;

#tax rate by Merchant
select i.uuid as item_uuid, i.name as item_name, tr.name as tax_name, itr.deleted_time as tax_rate_deleted_time, itr.modified_time
from meta.merchant m
join meta.item i on i.merchant_id = m.id
join meta.item_tax_rate itr on itr.item_id = i.id
join meta.tax_rate tr on tr.id = itr.tax_rate_id
where m.uuid = "26DWMNRRB9BW4"
AND tr.uuid = "B8840EA93DRT8";

#Orders tied to customers by customer uuid
select c.created_time as customer_created, c.uuid as CustomerID, concat(c.first_name,' ',c.last_name) as Custname, concat(cc.first_name,' ',cc.last_name) as CardName, concat(gt.card_type,' ',gt.first4,'xx',gt.last4) as CardNum, o.created_time as OrderDate, p.created_time as server_created_time, p.client_created_time as payment_device_created_time, p.cash_tendered, o.uuid as OrderID, p.uuid as PaymentID, pr.reason as void_reason, p.result, p.amount 
from orders_4.customer c
join orders_4.orders o ON o.customer_id = c.id
join meta.merchant m ON m.id = o.merchant_id
left join orders_4.payment p ON p.order_id = o.id
left JOIN orders_4.gateway_tx gt ON p.gateway_tx_id = gt.id
left join orders_4.customer_address ca ON ca.customer_id = c.id
left join orders_4.customer_phone_number cpn ON cpn.customer_id = c.id
left join orders_4.customer_email_address cea ON cea.customer_id = c.id
left JOIN orders_4.customer_card cc ON cc.gateway_tx_id = gt.id 
left JOIN orders_4.payment_refund pr on pr.id = p.payment_refund_id
where c.uuid in ('7S1JGEQ0DDVR8')
order by p.id; 

#find line items in inventory 
select o.uuid order_uuid, o.total*.01 as order_total, p.amount*.01 as  payment_amount, li.name line_item_name, li.unit_price*.01 as  line_item_price, lim.amount line_item_modification_amount, li.qty, convert_tz(li.created_time, '+00:00','-04:00') as created_time_est, litr.*, lita.*
FROM orders o 
left JOIN payment p on p.order_id = o.id
left JOIN line_item li on o.id = li.order_id
left JOIN line_item_modification lim ON lim.line_item_id = li.id
left JOIN line_item_tax_rate litr ON litr.line_item_id = li.id
left join line_item_tax_amount lita on lita.line_item_id = li.id
where o.uuid IN ('VZ1WRGMHYV8NA');

#shows orders and payments based on id and created time
select o.uuid as order_id,p.uuid as payment_id, CONVERT_TZ(p.client_created_time, '+00:00','-04:00') as payment_client_created_time, p.payment_refund_id, gt.client_id 
from orders o 
left join payment p on o.id=p.order_id left 
join gateway_tx gt on gt.id=p.gateway_tx_id 
where o.merchant_id=1419495 and p.client_created_time between '2019-01-03 00:00:00' and '2019-01-03 23:59:59'
order by p.client_created_time;

#app lookup by merchant and on what device
select m.id as merchant_id, m.name as merchant_name, m.uuid as CID, d.serial as device_serial, r.version as RomVersion, da.app_package_name as app_name, da.app_version_code as app_version, da.app_update_time as app_updated_time
FROM meta.merchant m 
JOIN meta.device_provision dp on dp.merchant_id = m.id 
JOIN meta.device d on dp.serial_number = d.serial 
JOIN meta.device_app da on d.id = da.device_id 
JOIN meta.rom r on r.id = d.current_rom_id 
where m.uuid in ("XP71ZEKN628R1")
order by d.serial;

#app lookup by device and specific app
select m.id as merchant_id, m.name as merchant_name, m.uuid as CID, dp.serial_number as device_serial, r.version as RomVersion, da.app_package_name as app_name, da.app_version_code as app_version, da.app_update_time as app_updated_time, dp.activated_time
FROM meta.merchant m 
JOIN meta.device_provision dp on dp.merchant_id = m.id 
JOIN meta.device d on dp.serial_number = d.serial 
JOIN meta.device_app da on d.id = da.device_id 
JOIN meta.rom r on r.id = d.current_rom_id 
where dp.serial_number in ("C050UQ82330080") AND da.app_package_name = "com.clover.transactions"
order by d.serial;

#checks when an app was updated related to Merchant Group 
select r.name,m.id,m.name,m.uuid,mgr.merchant_group_id,mgrp.name, da.app_package_name as app_name, da.app_version_code as app_version, da.app_update_time as app_updated_time 
FROM meta.merchant m 
inner JOIN meta.reseller r ON m.reseller_id = r.id
inner JOIN meta.device_provision dp on dp.merchant_id = m.id 
inner JOIN meta.device d on dp.serial_number = d.serial 
inner JOIN meta.device_app da on d.id = da.device_id 
inner JOIN meta.rom ro on ro.id = d.current_rom_id 
inner JOIN meta.merchant_groups mgr on mgr.merchant_id = m.id 
inner JOIN meta.merchant_group mgrp on mgrp.id = mgr.merchant_group_id 
where mgrp.uuid IN ('RA3D3SB419W0P') AND da.app_package_name = "com.telecheck.clovertelecheck"
order by m.name LIMIT 10000;

#lookup by merchant group, app and device 
 select distinct (m.id) #as merchant_id, m.name as merchant_name, m.uuid as CID, d.serial as device_serial, r.version as RomVersion, da.app_package_name as app_name, da.app_version_code as app_version, from_unixtime(floor(da.app_update_time/1000)) as app_updated_time
FROM meta.merchant m 
JOIN meta.device_provision dp on dp.merchant_id = m.id 
JOIN meta.device d on dp.serial_number = d.serial 
JOIN meta.device_app da on d.id = da.device_id 
JOIN meta.rom r on r.id = d.current_rom_id 
JOIN meta.merchant_groups mgr on mgr.merchant_id = m.id 
JOIN meta.merchant_group mgrp on mgrp.id = mgr.merchant_group_id 
where da.app_package_name = 'com.gyft.gyftcard' AND mgrp.uuid IN ('1WD2NMETTM0PT', 'KT8NFDPK52N68', 'Z11M10DNCV1C4', 'HQ98ZTCQV8ZBM', 'PMRHRTDEVQCS2', 'D1N8WZ36KNF9P', '57HB9QKQ3T35M', 'BG55F53K3FWVC', '26V859PBFA6J0', 'ZJXA49DX4BJ12', 'K5D19WVZST9WM') and d.serial like "C053%"
order by d.serial; 

#Batch Query 
select o.uuid order_uuid, p.uuid payment_uuid, gt.created_time gateway_time, gt.id gateway_tx_id, gt.type, gt.amount*.01 gateway_amount, CONCAT(gt.card_type,' ',gt.first4,'xx',gt.last4) CardNum, gt.authcode,gt.response_message,gt.captured, b.*
from gateway_tx gt
join (
  select m.name merchant_name,m.uuid CloverID,SUBSTRING_INDEX(mg.partner_uuid,':',1) AS MID, m.id merchant_id, mg.id merchant_gateway_id, b.uuid batch_uuid, b.first_gateway_tx_id, b.last_gateway_tx_id, b.tx_count, b.total_batch_amount*.01 batch_total_amount, b.created_time batch_created_time from batch b
  join meta.merchant m ON m.id = b.merchant_id
  join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
  where b.uuid IN
  ('D8603AFHTHAGJ')
) b ON b.merchant_gateway_id = gt.merchant_gateway_id
join payment p on p.gateway_tx_id = gt.id
left JOIN meta.device d ON p.device_id = d.id
join orders o on p.order_id = o.id
where gt.merchant_gateway_id AND gt.id between b.first_gateway_tx_id AND b.last_gateway_tx_id AND gt.type IN ('auth','preauth') AND gt.response_message NOT LIKE '%DECLINE%' order by b.merchant_id;

#Batch query to see manual and auto and user that made manual
select b.created_time, b.batch_type, a.name from batch b 
left join meta.account a ON a.id = b.account_id
where b.merchant_id = '1236329' order by b.created_time DESC;

#case Query for 2019
SELECT assigned_to_name, MAX(CASE WHEN region = "us" THEN number_of_cases END) "us", MAX(CASE WHEN region = "eu" THEN number_of_cases END) "eu", MAX(CASE WHEN region = "ca" THEN number_of_cases END) "ca", sum(number_of_cases) as total,
CASE WHEN month = 1 THEN 'January'
    WHEN month = 2 THEN 'February'
    WHEN month = 3 THEN 'March'
    WHEN month = 4 THEN 'April'
    WHEN month = 5 THEN 'May'
    WHEN month = 6 THEN 'June'
    WHEN month = 7 THEN 'July'
    WHEN month = 8 THEN 'August'
    WHEN month = 9 THEN 'September'
    WHEN month = 10 THEN 'October'
    WHEN month = 11 THEN 'November'
   WHEN month = 12 THEN 'December'
    ELSE NULL END AS month_name
FROM (select case when us.assigned_to_name = "David Britton" then "Dave Britton" else us.assigned_to_name end as assigned_to_name, 'us' as region, count(us.assigned_to_name) as number_of_cases, extract(month from us.created_date) month
from us_sf_cases us
where us.created_date between "2019-01-01" AND "2019-12-31" and us.assigned_to_name in ("Adam Myers", "Mark Brunell", "Rusheen Watson", "Alejandro Sahagun", "George Gong", "Robert Heslep", "Tony Dellinger", "Vidya Chockalingam", "Yuting Ko", "Esther Bamberg","Scott Doman","Mason Bone","Vinny Mandarapu", "Matt Boddie", "David Britton", "Cory Johnston")
group by us.assigned_to_name, month 
union 
select eu.assigned_to_name, 'eu' as region, count(eu.assigned_to_name) as number_of_cases, extract(month from eu.created_date) month
from eu_sf_cases eu
where eu.created_date between "2019-01-01" AND "2019-12-31"and eu.assigned_to_name in ("Adam Myers", "Mark Brunell", "Rusheen Watson", "Alejandro Sahagun", "George Gong", "Robert Heslep", "Tony Dellinger", "Vidya Chockalingam", "Yuting Ko", "Esther Bamberg","Scott Doman","Mason Bone","Vinny Mandarapu", "Matt Boddie", "Dave Britton", "Cory Johnston")
group by eu.assigned_to_name, month 
union 
select case when ca.assigned_to_name = "David Britton" then "Dave Britton" else ca.assigned_to_name end as assigned_to_name, 'ca' as region, count(ca.assigned_to_name) as number_of_cases, extract(month from ca.created_date) month
from ca_sf_cases ca
where ca.created_date between "2019-01-01" AND "2019-12-31" and ca.assigned_to_name in ("Adam Myers", "Mark Brunell", "Rusheen Watson", "Alejandro Sahagun", "George Gong", "Robert Heslep", "Tony Dellinger", "Vidya Chockalingam", "Yuting Ko", "Esther Bamberg","Scott Doman","Mason Bone","Vinny Mandarapu", "Matt Boddie", "David Britton", "Cory Johnston")
group by ca.assigned_to_name, month order by  region, assigned_to_name) t group by month, assigned_to_name order by month;

#case query for 2020
SELECT assigned_to_name, MAX(CASE WHEN region = "us" THEN number_of_cases END) "us", MAX(CASE WHEN region = "eu" THEN number_of_cases END) "eu", MAX(CASE WHEN region = "ca" THEN number_of_cases END) "ca", sum(number_of_cases) as total,
CASE WHEN month = 1 THEN 'January'
    WHEN month = 2 THEN 'February'
    WHEN month = 3 THEN 'March'
    WHEN month = 4 THEN 'April'
    WHEN month = 5 THEN 'May'
    WHEN month = 6 THEN 'June'
    WHEN month = 7 THEN 'July'
    WHEN month = 8 THEN 'August'
    WHEN month = 9 THEN 'September'
    WHEN month = 10 THEN 'October'
    WHEN month = 11 THEN 'November'
   WHEN month = 12 THEN 'December'
    ELSE NULL END AS month_name
FROM (select case when us.assigned_to_name = "David Britton" then "Dave Britton" else us.assigned_to_name end as assigned_to_name, 'us' as region, count(us.assigned_to_name) as number_of_cases, extract(month from us.created_date) month
from us_sf_cases us
where us.created_date > "2020-01-01" and us.assigned_to_name in ("Adam Myers", "Mark Brunell", "Rusheen Watson", "Alejandro Sahagun", "George Gong", "Robert Heslep", "Tony Dellinger", "Vidya Chockalingam", "Yuting Ko", "Esther Bamberg","Scott Doman","Mason Bone","Vinny Mandarapu", "Matt Boddie", "David Britton", "Cory Johnston")
group by us.assigned_to_name, month 
union 
select eu.assigned_to_name, 'eu' as region, count(eu.assigned_to_name) as number_of_cases, extract(month from eu.created_date) month
from eu_sf_cases eu
where eu.created_date > "2020-01-01" and eu.assigned_to_name in ("Adam Myers", "Mark Brunell", "Rusheen Watson", "Alejandro Sahagun", "George Gong", "Robert Heslep", "Tony Dellinger", "Vidya Chockalingam", "Yuting Ko", "Esther Bamberg","Scott Doman","Mason Bone","Vinny Mandarapu", "Matt Boddie", "Dave Britton", "Cory Johnston")
group by eu.assigned_to_name, month 
union 
select case when ca.assigned_to_name = "David Britton" then "Dave Britton" else ca.assigned_to_name end as assigned_to_name, 'ca' as region, count(ca.assigned_to_name) as number_of_cases, extract(month from ca.created_date) month
from ca_sf_cases ca
where ca.created_date > "2020-01-01" and ca.assigned_to_name in ("Adam Myers", "Mark Brunell", "Rusheen Watson", "Alejandro Sahagun", "George Gong", "Robert Heslep", "Tony Dellinger", "Vidya Chockalingam", "Yuting Ko", "Esther Bamberg","Scott Doman","Mason Bone","Vinny Mandarapu", "Matt Boddie", "David Britton", "Cory Johnston")
group by ca.assigned_to_name, month order by  region, assigned_to_name) t group by month, assigned_to_name order by month;

#case query for 2021
SELECT assigned_to_name, MAX(CASE WHEN region = "us" THEN number_of_cases END) "us", MAX(CASE WHEN region = "eu" THEN number_of_cases END) "eu", MAX(CASE WHEN region = "ca" THEN number_of_cases END) "ca", sum(number_of_cases) as total,
CASE WHEN month = 1 THEN 'January'
    WHEN month = 2 THEN 'February'
    WHEN month = 3 THEN 'March'
    WHEN month = 4 THEN 'April'
    WHEN month = 5 THEN 'May'
    WHEN month = 6 THEN 'June'
    WHEN month = 7 THEN 'July'
    WHEN month = 8 THEN 'August'
    WHEN month = 9 THEN 'September'
    WHEN month = 10 THEN 'October'
    WHEN month = 11 THEN 'November'
   WHEN month = 12 THEN 'December'
    ELSE NULL END AS month_name
FROM (select case when us.assigned_to_name = "David Britton" then "Dave Britton" else us.assigned_to_name end as assigned_to_name, 'us' as region, count(us.assigned_to_name) as number_of_cases, extract(month from us.created_date) month
from us_sf_cases us
where us.created_date >= "2021-01-01" and us.assigned_to_name in ('Adam Myers', 'Jacob Milligan', 'Asha Daggupati', 'Matt McCurley', 'Karina Samaroo', 'Mark Brunell', 'Alejandro Sahagun', 'Tony Dellinger','Mason Bone','Vinny Mandarapu','David Britton', 'Cory Johnston', 'Rusheen Watson', 'Lisa Lee')
group by us.assigned_to_name, month
union
select eu.assigned_to_name, 'eu' as region, count(eu.assigned_to_name) as number_of_cases, extract(month from eu.created_date) month
from eu_sf_cases eu
where eu.created_date >= "2021-01-01" and eu.assigned_to_name in ('Adam Myers', 'Jacob Milligan', 'Asha Daggupati', 'Matt McCurley','Karina Samaroo', 'Mark Brunell', 'Alejandro Sahagun', 'Tony Dellinger','Mason Bone','Vinny Mandarapu','Dave Britton', 'Cory Johnston', 'Rusheen Watson', 'Lisa Lee')
group by eu.assigned_to_name, month
union
select case when ca.assigned_to_name = "David Britton" then "Dave Britton" else ca.assigned_to_name end as assigned_to_name, 'ca' as region, count(ca.assigned_to_name) as number_of_cases, extract(month from ca.created_date) month
from ca_sf_cases ca
where ca.created_date >= "2021-01-01" and ca.assigned_to_name in ('Adam Myers', 'Jacob Milligan', 'Asha Daggupati', 'Matt McCurley','Karina Samaroo', 'Mark Brunell', 'Alejandro Sahagun', 'Tony Dellinger','Mason Bone','Vinny Mandarapu','David Britton', 'Cory Johnston', 'Rusheen Watson', 'Lisa Lee')
group by ca.assigned_to_name, month order by  region, assigned_to_name) t group by month, assigned_to_name order by month;

#Salesforce Cases lookup by device 
    select usc.case_number, usc.created_date, usc.subject, uscc.comment_body, usc.resolution_comments
from us_merchant_metadata umm
join us_sf_cases usc on usc.key_merchant_id = umm.key_merchant_id
join us_sf_case_comments uscc on uscc.case_number = usc.case_number
where usc.serial_numbers like "%C053%" AND usc.created_date between '2020-04-01 00:00:00' and '2020-08-05 23:59:59'
#where (uscc.comment_body like "%C053%" OR usc.subject like "PRO") AND usc.created_date between '2020-04-01 00:00:00' and '2020-08-05 23:59:59'
order by usc.created_date desc;

#Germany Payment Query 
select m.name as merchant_name,
m.uuid as CID,
case when mg.config not like '%mid%' then null else substring_index(substring_index(mg.config,'\"mid\"\:\"',-1),'\"',1) end as MID,
case when mg.config not like '%storeId%' then null else substring_index(substring_index(mg.config,'\"storeId\"\:\"',-1),'\"',1) end as store_id,
d.serial,
o.uuid as order_uuid,
p.uuid as payment_uuid,
gt.response_code,
gt.response_message, 
gt.client_id as transaction_id,
gt.type,
gt.authcode,
case when gt.extra not like '%terminalId%' then null else substring_index(substring_index(gt.extra,'\"terminalId\"\:\"',-1),'\"',1) end as terminalId,
gt.amount*.01 as gateway_amount,
gt.adjust_amount*.01 as gateway_tip_amount,
p.amount*.01 as payment_amount,
p.tip_amount*.01 as payment_tip_amount,
p.result,
mt.label,
gt.card_type,
convert_tz(p.created_time, '+00:00','+02:00') as payment_time_cet,
case when p.offline = 1 then 'yes' else 'no' end as offline,
case when pe.value not like '%transactionCaseGermany%' then null else substring_index(substring_index(pe.value,'\"transactionCaseGermany\"\:\"',-1),'\"',1) end as ipg_response,
case when pe.value not like '%configProductLabel%' then null else substring_index(substring_index(pe.value,'\"configProductLabel\"\:\"',-1),'\"',1) end as card_type,
case when pe.value not like '%hostResponsePrintDataBM60%' then null else substring_index(substring_index(pe.value,'\"hostResponsePrintDataBM60\"\:\"',-1),'\"',1) end as receipt_text,
case when gt.extra not like '%gerReceiptNumber%' then null else substring_index(substring_index(gt.extra,'\"gerReceiptNumber\"\:\"',-1),'\"',1) end as ipg_receipt_number,
case when gt.extra not like '%ipgTxId%' then null else substring_index(substring_index(gt.extra,'\"ipgTxId\"\:\"',-1),'\"',1) end as ipg_transaction_id,
r.uuid as refund_uuid,
convert_tz(r.created_time, '+00:00','+02:00') as refund_time_cet
from payment p
join orders o on p.order_id = o.id
join meta.merchant_tender mt on p.merchant_tender_id = mt.id
left join refund r on r.payment_id = p.id
left join gateway_tx gt on p.gateway_tx_id = gt.id
left join payment_refund pr on pr.id = p.payment_refund_id
left join meta.device d on p.device_id = d.id
left join customer c on c.id = o.customer_id
left join customer_card cc on cc.gateway_tx_id = gt.id
left join gateway_tx_debug gtd on gt.id = gtd.gateway_tx_id
left join meta.merchant m on m.id = p.merchant_id
left join meta.merchant_gateway mg on mg.id = m.merchant_gateway_id
left join payment_extra pe on pe.payment_id = p.id
where p.uuid in ("T2XT0AXNHBTVR") 
order by p.created_time asc;

#monitoring rollouts by merchant group ids
SELECT left(mg.name,30) mg_name,mgs.merchant_group_uuid AS MG_UUID,DATE(mg.created_time) AS ReleaseDate,usc.owner_name,usc.account_name,usc.key_merchant_id,usc.case_number,usc.status, SUBSTRING(usc.subject,1,30) AS subject, usc.created_date AS CreatedTime, usc.description 
FROM reporting.us_sf_cases usc 
JOIN reporting.us_merchant_metadata umm ON usc.key_merchant_id = umm.key_merchant_id 
JOIN dev_reporting.merchant_groups mgs ON umm.id = mgs.merchant_id JOIN dev_reporting.merchant_group mg ON mgs.merchant_group_id = mg.id 
WHERE usc.created_date > DATE(DATE_SUB(NOW(), INTERVAL 1 DAY)) AND umm.key_merchant_id NOT REGEXP '^1+$' AND umm.key_merchant_id != -1 AND mg.uuid in ('XXC326S6B75RY','VBNFCWRZHDBK0','2DNXG20W7JM5P') AND usc.created_date > mg.created_time GROUP BY usc.case_number ORDER BY mg_name;

#Order line item lookup
select o.uuid order_uuid, o.total*.01 as order_total, p.amount*.01 as  payment_amount, li.name line_item_name, li.unit_price*.01 as  line_item_price, lim.amount line_item_modification_amount, li.qty, convert_tz(li.created_time, '+00:00','-04:00') as created_time_est, litr.*
FROM orders o 
left JOIN payment p on p.order_id = o.id
left JOIN line_item li on o.id = li.order_id
left JOIN line_item_modification lim ON lim.line_item_id = li.id
left JOIN line_item_tax_rate litr ON litr.line_item_id = li.id
left join line_item_tax_amount lita on lita.line_item_id = li.id
where o.uuid IN ('96P4GE7P78TPW');

#pulls CFD or POS mode for merchant id 
select * 
from meta.setting 
where merchant_id=1825819 and name in ('TOS_BILLING_MODEL', 'DEVICE_OPERATING_MODE');

#inventory lookup
select i.id, uuid, name, price, item_code, sku, deleted, i.modified_time, iss.count, iss.quantity, iss.deleted_time, iss.modified_time 
from item i 
join item_stock iss on i.id = iss.item_id 
where merchant_id = 1471377 and name like '%CHAKRA%BALANCE%QUARTZ%PENDANT%';

#Utilized to find Apps and when installed 
select da.name, da.uuid as Dev_App, ma.uuid as Merch_App, ma.created_time, ma.deleted_time
from meta.merchant_app ma
join meta.developer_app da on da.id = ma.app_id
where merchant_id = 2651323;

#Search for if app is installed for a specific Developer App UUID on MID: 
select m.name, m.uuid, da.name, ma.created_time, ma.deleted_time
from meta.merchant_app ma
join meta.merchant m on m.id = ma.merchant_id
join meta.developer_app da on da.id = ma.app_id
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
where SUBSTRING_INDEX(mg.partner_uuid,':',1) in ()AND da.uuid = "M5VDWB8SKJHZ0";

#Merchants who have installed an app by developer UUID
select m.uuid as merchant_name, m.name as Clover_ID, da.name, da.uuid, ma.uuid, ma.created_time, ma.deleted_time
from meta.merchant_app ma
join meta.developer_app da on da.id = ma.app_id
join meta.merchant m on ma.merchant_id = m.id
where da.uuid = "AXKRX2N6Y4F21" AND ma.deleted_time is null;

# get list of offline device settings
 select m.uuid cloverid,d.serial,md.* from meta.device d
join meta.merchant_device md ON md.device_id = d.id
join meta.merchant m ON m.id = md.merchant_id
 where md.merchant_id IN (1409907) AND md.offline_payments = 1;

#Inventory export pull 
select a.CloverID, a.name, a.alternate_name, a.price*.01 as price, a.price_type, case when (a.tax_rates is null  and itr.deleted_time is null) then tr.name when (a.tax_rates is not null  and itr.deleted_time is null) then a.tax_rates else null end as tax_rate, a.cost*.01 as cost, a.product_code, a.sku, a.modifier_groups, a.quantity, group_concat(case when (t.name is null and ti.deleted = 0) then '' when (t.name is not null and ti.deleted = 0) then t.name else null end) as labels, a.hidden, a.is_revenue  
from (select i.id as item_id, i.uuid as CloverID, i.name as Name, i.alternate_name, i.price, i.price_type, case when default_tax_rates=1 then 'Default' else null end as tax_rates, i.cost, i.item_code as product_code, i.sku, group_concat(case when (mg.name is null and img.deleted=0) then '' when (mg.name is not null and img.deleted=0) then mg.name else null end) as modifier_groups,
i_s.quantity,i.hidden, i.is_revenue 
from item i 
left join item_modifier_group img on i.id=img.item_id
left join modifier_group mg on img.modifier_group_id=mg.id
left join item_stock i_s on i_s.item_id=i.id
where i.merchant_id=284491 and i.deleted=0 
group by i.id) a 
left join tag_item ti on a.item_id=ti.item_id
left join tag t  on t.id=ti.tag_id
left join item_tax_rate itr on a.item_id=itr.item_id 
left join tax_rate tr on tr.id=itr.tax_rate_id 
group by a.item_id;

#Get Check Info based on Note
select m.name, m.uuid, p.uuid payment_uuid, p.amount*.01 as payment_amount, CONVERT_TZ(p.client_created_time, '+00:00','-05:00') as payment_device_created_time_est, CONVERT_TZ(o.client_created_time, '+00:00','-05:00') as order_client_created_time_est, p.note, p.external_payment_id
from orders o
join meta.merchant m ON m.id = o.merchant_id
left join payment p ON p.order_id = o.id
where m.id = 985828 and p.client_created_time between "2019-05-30" and "2019-07-10" and p.note like "%Check%"
order by p.client_created_time;

--TINA--INPUT MerchantID. OUTPUT: Who manually batched out with timezone shift:
select audit_events.type, account.name, CONVERT_TZ(audit_events.created_at, '+00:00','-04:00') 
FROM meta.audit_events,account 
where audit_events.account_id = account.id and audit_events.merchant_id = 169732 and audit_events.type like '%CLOSE%' and audit_events.created_at > '2015-09-01';

--ALEX--SHIFT HISTORY for CLoverID:
select mr.nickname,mr.role,s.id, s.uuid, s.in_time,s.override_in_time,s.override_in_account_id,s.out_time,s.override_out_time,s.override_out_account_id 
FROM meta.employee_shift s, merchant_role mr, account a
    where mr.account_id = a.id
    and s.account_id = a.id
    and mr.merchant_id = 77599
    and s.in_time >= '2015-03-14'
    and s.in_time <= '2015-03-16'
    and out_time is NULL;

    --ALEX--SHIFT HISTORY from CloverID and Account ID
select a.name,a.id,mr.role,s.in_time,s.override_in_time,s.override_in_account_id,s.out_time,s.override_out_time,s.override_out_account_id 
FROM meta.employee_shift s
    JOIN meta.account a on a.id = s.account_id
    JOIN meta.merchant_role mr on mr.account_id = s.account_id
where
    s.merchant_id = '80211' 
    AND
    s.in_time > '2015-04-01'
    AND
    a.id = '500111';

    #query for SF look case lookup by uuid 
    select usc.case_number, usc.created_date, usc.subject, uscc.comment_body, usc.resolution_comments
from us_merchant_metadata umm
join us_sf_cases usc on usc.key_merchant_id = umm.key_merchant_id
join us_sf_case_comments uscc on uscc.case_number = usc.case_number
where umm.clover_id in "MSX5PKCYQM5Q1";

#comparing the employee who created the order to who created the payment
select o.uuid as order_uuid, oa.name as order_account_name, do.serial as order_serial, p.uuid as payment_uuid, pa.name as payment_account_name, dp.serial as payment_serial 
from orders o
left join payment p  on p.order_id = o.id
left join meta.device do on o.device_id = do.id
left join meta.device dp on p.device_id = dp.id
left join meta.account oa on o.account_id = oa.id
left join meta.account pa on p.account_id = pa.id
where p.uuid in ('X0CGEM46JPAHC');

#Order device vs Payment device with response messages between a time frame 
select o.uuid as order_uuid, oa.name as order_account_name, do.serial as order_serial, p.uuid as payment_uuid, pa.name as payment_account_name, dp.serial as payment_serial, 
gt.response_code, 
gt.response_message,
gt.amount*.01 as GTinitAMT,
gt.adjust_amount*.01 as GT_TIP,
p.amount*.01 as PayAMT, 
  p.tip_amount*.01 as PayTipAMT, 
  p.tax_amount*.01 as PayTX,
  p.cash_tendered*.01 as cash_tendered,
  p.result,  
p.client_created_time as payment_client_created_time,
p.created_time as payment_server_created_time,
o.client_created_time as order_client_created_time,
o.created_time as order_server_created_time
from orders o
left join payment p  on p.order_id = o.id
left join meta.device do on o.device_id = do.id
left join meta.device dp on p.device_id = dp.id
left join meta.account oa on o.account_id = oa.id
left join meta.account pa on p.account_id = pa.id
left JOIN gateway_tx gt ON p.gateway_tx_id = gt.id
where o.merchant_id = 2363209 and p.client_created_time between '2021-06-05 04:00:00' and '2021-06-06 05:59:59'
order by o.created_time ASC;

#find sim cards by status and reseller 
select s.uuid,s.iccid,.s.status,sdp.created_time,sdp.deleted_time,dp.serial_number,dp.merchant_id 
FROM meta.device_provision dp 
inner JOIN meta.sim_device_provision sdp on dp.id = sdp.device_provision_id 
inner JOIN meta.sim s on sdp.sim_id = s.id 
inner join meta.merchant m ON m.id = dp.merchant_id
inner join meta.reseller r ON r.id = m.reseller_id
where (s.status = 'active') and sdp.deleted_time is null and r.name = 'cardnet';

#field Test query 
SELECT left(mg.name,30) mg_name,mgs.merchant_group_uuid AS MG_UUID,DATE(mg.created_time) AS ReleaseDate,usc.owner_name,usc.account_name,usc.key_merchant_id,usc.case_number,usc.status, SUBSTRING(usc.subject,1,30) AS subject, usc.created_date AS CreatedTime 
FROM reporting.us_sf_cases usc 
JOIN reporting.us_merchant_metadata umm ON usc.key_merchant_id = umm.key_merchant_id 
JOIN dev_reporting.merchant_groups mgs ON umm.id = mgs.merchant_id 
JOIN dev_reporting.merchant_group mg ON mgs.merchant_group_id = mg.id 
WHERE usc.created_date > DATE(DATE_SUB(NOW(), INTERVAL 3 DAY)) AND umm.key_merchant_id NOT REGEXP '^1+$' AND umm.key_merchant_id != -1 AND mg.uuid in ('AZBX99V8EDYFY') AND usc.created_date > mg.created_time 
GROUP BY usc.case_number ORDER BY mg_name;

#manual refund id look up
select d.serial refund_SN,gt.created_time, mt.label, concat(gt.type,' ',gt.card_type,' ',gt.first4,'xx',gt.last4) CardNum, gt.entry_type, cr.amount refund_amount, cr.uuid refund_id, gt.response_code, gt.response_message,cr.* 
from credit cr
join gateway_tx gt ON gt.id = cr.gateway_tx_id
left join payment p ON p.gateway_tx_id = cr.gateway_tx_id
left join meta.merchant_tender mt ON mt.id = cr.merchant_tender_id
left join meta.device d ON d.id = cr.device_id
where cr.uuid in ("Z3WAYG0ASFDT6", "5A48E8T75PYQT", "KHC7D4BJTVCVG");

#lookup by timeframe
select d.serial refund_SN,gt.created_time, mt.label, concat(gt.type,' ',gt.card_type,' ',gt.first4,'xx',gt.last4) CardNum, gt.entry_type, gt.id, cr.amount*.01 as refund_amount, cr.uuid as refund_uuid, gt.response_code, gt.response_message#cr.* 
from credit cr
join gateway_tx gt ON gt.id = cr.gateway_tx_id
left join payment p ON p.gateway_tx_id = cr.gateway_tx_id
left join meta.merchant_tender mt ON mt.id = cr.merchant_tender_id
left join meta.device d ON d.id = cr.device_id
where cr.merchant_id = 2860977 and cr.created_time between '2021-08-01 00:00:00' and '2021-09-28 23:59:59';

#Rapid Deposit look up by merchant uuid
select m.name as merchant_name, m.uuid as cid, substring_index(pp.name,'-',-2) as payment_pocessor_name, SUBSTRING_INDEX(partner_uuid,':',1) as mid, d.amount*.01 as deposit_amount, d.status, d.requested_time, d.deposited_time, d.failed_time, d.modified_time
from meta.merchant m
join meta.merchant_gateway mg on mg.merchant_id = m.id
join meta.payment_processor pp on mg.payment_processor_id = pp.id
join deposit d on d.merchant_id = m.id
where m.uuid = 'H9S8NTSR14MK1'
order by d.requested_time desc;

#if they ever had a app package by uuid
select m.uuid,m.name,d.serial,da.app_package_name,da.app_version_code from meta.device_app as da
join meta.device as d on d.id=da.device_id
join meta.merchant_device as md on md.device_id = da.device_id
join meta.merchant as m on m.id=md.merchant_id
where da.app_package_name='com.vitu.pay.cfp';

#App pull by package name
select SUBSTRING_INDEX(mg.partner_uuid,':',1) AS MID, m.name as merchant_name, m.uuid as CID, d.serial as device_serial, r.version as RomVersion, da.app_package_name as app_name, da.app_version_code as app_version, da.app_update_time as app_updated_time
FROM meta.merchant m 
JOIN meta.device_provision dp on dp.merchant_id = m.id 
join merchant_gateway mg on mg.merchant_id = m.id
JOIN meta.device d on dp.serial_number = d.serial 
JOIN meta.device_app da on d.id = da.device_id 
JOIN meta.rom r on r.id = d.current_rom_id 
where da.app_package_name = "com.vitu.pay.cfp"
order by da.app_version_code;

#Pulling US SF case info by case number
select usc.case_number, usc.created_date, umm.business_name as merchant_name, umm.key_merchant_id as MID,umm.clover_id as CID, usc.serial_numbers as serial_number
from us_sf_cases usc
left join us_merchants umm on umm.key_merchant_id = usc.key_merchant_id
where usc.case_number IN (72276037);

#US case data and jira table
select '||Case Number||Created Date||Name||MID||CID||Serials||'union
select concat('|',s.case_number ,'|',s.created_date,'|',s.dba_name,'|',s.key_merchant_id,'|',m.clover_id,'|',serial_numbers,'|')  from us_sf_cases s
join us_merchants m on s.key_merchant_id = m.key_merchant_id 
where case_number in (59898533);

#EU Case data and jira table
select '||Case Number||Created Date||Name||MID||CID||Reseller||'union
select concat('|',usc.case_number,'|',usc.created_date,'|',usc.dba_name,'|',usc.key_merchant_id,'|',um.clover_id,'|',um.reseller_name,'|') 
from eu_sf_cases usc
join eu_merchants um on usc.key_merchant_id = um.key_merchant_id 
where usc.case_number in (08162621);

#Auth server Rollout pull
select m.name, SUBSTRING_INDEX(mg.partner_uuid,':',1) AS MID, r.name
from merchant m
join reseller r on m.reseller_id = r.id
join merchant_gateway mg on mg.merchant_id = m.id
where m.uuid in ();

#US Get child cases attached to parent
select usf.case_number,usf.created_date, umm.business_name as Name, usf.key_merchant_id as MID, umm.clover_id
from us_sf_cases usf 
left join us_merchants umm on umm.key_merchant_id = usf.key_merchant_id
where usf.parent_case_number = 73484865;

#CA Get child cases attached to parent 
select usf.case_number,umm.business_name as Name, usf.key_merchant_id as MID, umm.clover_id
from ca_sf_cases usf 
left join us_merchants umm on umm.key_merchant_id = usf.key_merchant_id
where usf.parent_case_number = '54070011';

#payment and transaction number info for a merchant
select o.uuid as order_id,p.uuid as payment_id, CONVERT_TZ(p.client_created_time, '+00:00','-04:00') as payment_client_created_time, CONVERT_TZ(p.created_time, '+00:00','-04:00') as payment_created_time,CONVERT_TZ(gt.created_time, '+00:00','-04:00') as gateway_created_time, gt.client_id, p.amount*.01 as payment_amount, p.cash_tendered*.01 as cash_amount
from orders o 
left join payment p on o.id=p.order_id left 
join gateway_tx gt on gt.id=p.gateway_tx_id 
where o.merchant_id = 921251 and p.client_created_time between '2019-10-03 00:00:00' and '2019-10-10 23:59:59'
order by p.client_created_time;

#Pulls merchant id's for Station Pro 
select SUBSTRING_INDEX(mg.partner_uuid,':',1) AS MID 
from meta.device_provision dp
join meta.merchant m on dp.merchant_id = m.id
LEFT JOIN meta.merchant_gateway mg ON m.merchant_gateway_id = mg.id 
where dp.serial_number like "C053%" and dp.merchant_id is not null and m.name not like "%demo%";

#pulls cases related to merchant id's
select case_number, key_merchant_id, status, created_date, subject, account_name, description, resolution_comments from us_sf_cases 
where key_merchant_id in (825351309885,825333964880,825327687885,896202803889,984220065887,984233171888,215236466995,215216249999,953205636889,945203729880,929203721881,924202191889,
984235251886,896212840889,367359437889,355166550887,218232172997,215229096999,159201985888,958201099883,374248080888,372857020880,958203679880,939201743886,825346737885,883160070883,
984229205880,218505231991,209204800889,984208105887,940208577889,374242277886,924200577881,984215042883,844211739884,918160220888,958209373884,953205369887,984233796882) 
and created_date > '2019-09-24' order by created_date desc;

#Tax rates by uuid 
select tr .*
from meta.merchant m
join tax_rate tr on m.id = tr.merchant_id
where m.uuid = "1TJ0KTSFJMS91";

#pulling app name and number of merchants 
select merchant.name, merchant.uuid, device.serial, app_package_name, app_version_code,FROM_UNIXTIME(SUBSTR(app_update_time,1,10)) as UpdateTime 
FROM meta.device_app,device,device_provision,merchant 
where device.id = device_app.device_id and device_provision.serial_number = device.serial and device_provision.merchant_id = merchant.id and ( app_package_name like '%com.bluepumpsoftware.application%')
group by merchant.name;

#check p804 shipping history
select * from `eu_regenersis_shipping_info` eu where eu.old_serial_number IN ('SN1','SN2') OR eu.new_serial_number IN ('SN1','SN2');

#Looking up tender type change by CID
select mt.* 
from meta.merchant m
left join meta.merchant_tender mt on m.id = mt.merchant_id
where m.uuid = "GS37PMN4AT540";

#Employee permissions look up by merchant id
select mr.nickname,mr.account_id,mr.pin,mr.created_time as EmployeeCreated,mr.modified_time as EmployeeMod, mr.deleted_time as EmployeeDel,mr.role,r.name,r.system_role,r.modified_time as RoleMod,psr.modified_time as PermSetRoleMod,psr.deleted_time as PermSetRoleDel,ps.label,ps.name as PermSetName,ps.employee_default,ps.manager_default,ps.permissions,ps.modified_time as PermSetMod 
FROM meta.merchant_role mr 
JOIN meta.role r on r.id = mr.role_id
left JOIN meta.permission_set_role psr on psr.role_id = r.id
left JOIN meta.permission_set ps on ps.id = psr.permission_set_id
where mr.merchant_id = '530432'
order by mr.nickname,psr.modified_time;

#Search based on device id
select * from meta.device where hex(uuid)=‘CF006B20D0DD42F4A5861047325862F2’;

#pull tax rates based on id and time fram of merchant 
select order_id, payment.id payment_id, payment.uuid payment_uuid, payment.amount total_paid, payment.tax_amount total_tax,
tax_rate_id, rate, taxable_amount, payment_tax_rate.tax_amount tax_paid_at_this_rate
from payment
left join payment_tax_rate on payment_id=payment.id
where merchant_id=69673 and client_created_time >= '2019-10-04 5:00' and client_created_time <= '2019-10-05 4:59' and result='success' and tax_rate_id=138201;

#lookup order id based on uuid
select * 
from orders 
where uuid = "6NT9BGRPYHXDY";

#lookup Discounts and names 
select * 
from adjustment 
where order_id=17896330997 
order by line_item_id;

#batch query for timeframe
select * from meta.merchant_gateway mg join meta.merchant m on  m.id = mg.merchant_id
join merchant_tenancy mt on m.id = mt.merchant_id
join meta.merchant_boarding mb on m.id = mb.merchant_id
where  mg.closing_time between "07:51" and "07:57"
and mb.account_status =16
and not exists (select 1 from batch b where b.merchant_id =m.id
and  b.created_time >'2019-12-03 00:00:00'
and b.state = 'CLOSED' )
and mt.readable = 1;
#Scratch surrounding timeframe In kibana the time seen within the body is (60minsx7hrs = 420mins past midnight, + 52mins = 472 minutes past midnight)
#Kibana Query class: BatchSettlePreAuth AND "gateways for interval"

#orders pull by time range 
select * from orders o 
left join payment p  on p.order_id = o.id
left join gateway_tx g on p.gateway_tx_id = g.id
where o.created_date between "2019-05-01 00:00" and "2019-05-16 23:59" and o.merchant_id = "";

#count of customers
select count(*) from customer where merchant_id=1027594;

#count showing by created time too 
select * from customer where merchant_id=1027594 order by created_time asc limit 1;

#find the debit key code transactions for a specific timeframe 
select *
from gateway_tx
where ksn_prefix = "FFFF110302" and created_time between '2019-12-12 00:00:00' and '2019-12-12 23:59:59';

#email bounce check 
select * from meta.email_bounce where email = 'jbadoyen@MPXUSA.com';

#lookup tamper report by uuid
select m.name as merchant_name, m.uuid as clover_id, dp.serial_number as device_serial, a.created_time as tamper_created_time, a.report_type, a.message, r.name, a.cleartext
from (select hex(device_uuid) device_uuid, created_time, report_type, message, cleartext
FROM meta.secure_report
where created_time > '2018-10-01' and report_type in ('tamper','not_provisioned')) a
inner join (select hex(uuid) device_uuid,serial,device_provision_id
FROM meta.device) b on a.device_uuid = b.device_uuid
inner JOIN meta.device_provision dp on b.device_provision_id = dp.id
inner JOIN meta.merchant m on dp.merchant_id = m.id
join meta.reseller r ON r.id = m.reseller_id
where m.uuid = 'AMAT6F2TND131'
order by a.created_time;

#unhex deviceid's to serials
select m.uuid CloverID, SUBSTRING_INDEX(mg.partner_uuid,':',1) AS MID, m.name, r.name, hex(d.uuid), d.serial from meta.device d 
join meta.device_provision dp ON dp.serial_number = d.serial
join meta.merchant m ON m.id = dp.merchant_id
JOIN meta.reseller r ON m.reseller_id = r.id
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
where d.uuid IN (unhex('5e2024e6e5b34f198f93dd9c811f53b5')
,unhex('4228d3d4939f47d4ac497dd2a35fd873')
,unhex('647d4f36eef045ed88d0b1a9813adf40'),unhex('992d3f2ec4764446852339867e551921')
,unhex('7fba0293cbfc42e2ae33a9f30591085a'));

#customer lookup by uuid
select c.uuid CustomerID,concat(c.first_name,' ',c.last_name) Custname,c.created_time customer_created, cpn.phone_number,cea.email_address,o.created_time OrderDate, o.uuid OrderID, p.uuid PaymentID, o.deleted_timestamp OrderDeleted 
from customer c
left join orders o ON o.customer_id = c.id
left join meta.merchant m ON m.id = o.merchant_id
left join payment p ON p.order_id = o.id
left join customer_address ca ON ca.customer_id = c.id
left join customer_phone_number cpn ON cpn.customer_id = c.id
left join customer_email_address cea ON cea.customer_id = c.id
where c.uuid IN ('DZ5MHK2GNEP1Y')
order by c.uuid ASC; 

#search based on device on merchant Group  ------- use group by m.uuid for merchants affected
select m.id as merchant_id, m.name as merchant_name, m.uuid as CID, d.serial as device_serial, r.version as RomVersion, da.app_package_name as app_name, da.app_version_code as app_version, from_unixtime(floor(da.app_update_time/1000)) as app_updated_time
FROM meta.merchant m 
JOIN meta.device_provision dp on dp.merchant_id = m.id 
JOIN meta.device d on dp.serial_number = d.serial 
JOIN meta.device_app da on d.id = da.device_id 
JOIN meta.rom r on r.id = d.current_rom_id 
JOIN meta.merchant_groups mgr on mgr.merchant_id = m.id 
JOIN meta.merchant_group mgrp on mgrp.id = mgr.merchant_group_id 
where da.app_package_name = 'com.clover.tables2' and mgrp.uuid IN ('9N18ZY8AHVH50','QXBQA4CFRC39T','BT6A8PYHMZ53Y') and da.app_version_code = 54
order by d.serial; 

#Search by Merchant ID to see if removed Line item was added or not 
select * from setting where merchant_id=89413 and name='AUDIT_REMOVED_LINE_ITEMS';

#Customer export Info 
select c.id, c.uuid, c.last_name, c.first_name, ca.*, cpn.*, cm.* from customer c 
left join customer_address ca on ca.customer_id = c.id
left join customer_email_address cea on cea.customer_id = c.id
left join customer_phone_number cpn on cpn.customer_id = c.id
left join customer_metadata cm on cm.customer_id = c.id
where c.merchant_id = 1529053;

#Customer Export Updated!
select c.uuid as 'Customer ID', c.first_name as 'First Name', c.last_name as 'Last Name', cph.phone_number as 'Phone Number', cea.email_address as 'Email Address', ca.address_1 as 'Address Line 1', ca.address_2 as 'Address Line 2', ca.address_3 as 'Address Line 3', ca.city as 'City', ca.state as 'State / Province', ca.zip as 'Postal / Zip Code', ca.country as 'Country', CONVERT_TZ(c.created_time, '+00:00','-06:00') as 'Customer Since', case when c.marketing_allowed = 0 then 'No' else 'Yes' end as 'Marketing Allowed'
from customer c
left join customer_email_address cea on cea.customer_id = c.id
left join customer_phone_number cph on cph.customer_id = c.id
left join customer_address ca on ca.customer_id = c.id
where c.merchant_id = 827423 and c.deleted_time is NULL;

#self boarding query with automatic pipes 
  select '||account_id||account_uuid||merchant_role_id||email||merchant_id||merchant_uuid||is_primary_account||Name||'union
    select concat('|',account_id ,'|',account_uuid,'|',merchant_role_id,'|',email,'|',merchant_id,'|',merchant_uuid,'|',is_primary_account,'|',name,'|') from (
select a.id as account_id, a.uuid as account_uuid, mr.id as merchant_role_id, a.email,
    m.id as merchant_id, m.uuid as merchant_uuid,
    CASE WHEN (a.primary_merchant_role_id = mr.id) THEN 1 ELSE 0 END as is_primary_account, m.`name`
    from meta.account a
    join meta.merchant_role mr on mr.account_id = a.id
    join meta.merchant m on m.id = mr.merchant_id
    where a.email in ( 'mike@wildslicepizzeria.com')) tmp;

#Duplicate Charges Pull
select o.id, o.uuid, o.merchant_id, o.total, sum(p.amount), o.client_created_time, count(p.amount) as nbr_payments
from orders o inner join payment p on (p.order_id=o.id and p.result='success' and p.gateway_tx_id IS NOT NULL)
where o.client_created_time >= '2020-02-11 00:00:00' and o.client_created_time < '2020-02-12 00:00:00'
group by o.id, o.uuid, o.merchant_id, o.total
having sum(p.amount) = 2*o.total and count(p.amount) = 2;

select case when mb.account_status = 02 then 'Fraud' when mb.account_status = 16 then 'Active' when mb.account_status = 13 or mb.account_status = 'C' then 'Closed' else mb.account_status end as account_status, count(DISTINCT(m.uuid)) merchant_count 
FROM meta.unified_report_group urg 
JOIN meta.unified_report ur ON ur.unified_report_group_id = urg.id
JOIN meta.merchant m ON ur.merchant_id = m.id
LEFT JOIN meta.merchant_partner_app mpa ON mpa.merchant_id = m.id
LEFT JOIN meta.developer_app da ON da.id = mpa.developer_app_id
LEFT JOIN meta.merchant_boarding mb ON mb.merchant_id = m.id
where urg.uuid = '2V0X481Z35QER' group by account_status order by account_status;
12:34
# run merchant crash group to get metadata + account status to determine if closed account
select DISTINCT(m.uuid) cloverid, m.name, da.name, case when mb.account_status = 02 then 'Fraud' when mb.account_status = 16 then 'Active' when mb.account_status = 13 or mb.account_status = 'C' then 'Closed' else mb.account_status end as "account_status" FROM meta.unified_report_group urg 
JOIN meta.unified_report ur ON ur.unified_report_group_id = urg.id
JOIN meta.merchant m ON ur.merchant_id = m.id
LEFT JOIN meta.merchant_partner_app mpa ON mpa.merchant_id = m.id
LEFT JOIN meta.developer_app da ON da.id = mpa.developer_app_id
LEFT JOIN meta.merchant_boarding mb ON mb.merchant_id = m.id
where urg.uuid = '2V0X481Z35QER' order by account_status;

--1get list of merchant_id's in a crash group uuid (any shard) with merchant_partner_app
select DISTINCT(m.uuid), m.name, da.name, r.name 
FROM meta.unified_report_group urg 
JOIN meta.unified_report ur ON ur.unified_report_group_id = urg.id
JOIN meta.merchant m ON ur.merchant_id = m.id
join meta.reseller r on r.id = m.reseller_id
LEFT JOIN meta.merchant_partner_app mpa ON mpa.merchant_id = m.id
LEFT JOIN meta.developer_app da ON da.id = mpa.developer_app_id
where urg.uuid = 'CXCWB971KQVWM';

#pull OLO online status
select m.id merchantid,m.uuid cloverid, m.name, oom.enabled, oom.business_info_done, oom.service_info_done, oom.status, oom.created_time, oom.modified_time, a.email 
from meta.online_order_merchant oom 
join meta.merchant m ON m.id = oom.merchant_id 
join meta.account a ON a.id = m.owner_account_id 
where oom.created_time > '2019-12-01'  AND (a.email NOT LIKE '%@clover.com%' OR m.name NOT LIKE '%demo%') order by oom.created_time;

#Search by address!!
select m.name, m.uuid, ma.address_1, ma.address_2, ma.address_3, ma.city, ma.state, ma.zip
from merchant_address ma
join merchant m on m.address_id = ma.id
where ma.address_1 like "%702 Washington St%";


#pull batch details
select * from batch where uuid in ("5K70Q1EBB8WG8", "YG88XEX14MEC4");

#devices Active by region 
select SUM(active_last_90_days) active_last_90_days, SUM(active_last_60_days) active_last_60_days ,SUM(active_last_30_days) active_last_30_days, 'US' as region
from us_merchant_metadata m
join us_devices d on m.id = d.m_id
where is_demo = 0 and (active_last_90_days = 1 OR active_last_60_days = 1 OR active_last_30_days = 1) 
union
select SUM(active_last_90_days) active_last_90_days, SUM(active_last_60_days) active_last_60_days ,SUM(active_last_30_days) active_last_30_days, locale_country as region
from eu_merchant_metadata m
join eu_devices d on m.id = d.m_id
where is_demo = 0 and (active_last_90_days = 1 OR active_last_60_days = 1 OR active_last_30_days = 1)
group by region
union
select  SUM(active_last_90_days) active_last_90_days, SUM(active_last_60_days) active_last_60_days ,SUM(active_last_30_days) active_last_30_days ,(case when has_clover_go_only=1 then 'US Clover GO only' else 'US clover GO with other device' end )as region from us_merchant_metadata where is_demo = 0 and (active_last_90_days = 1 OR active_last_60_days = 1 OR active_last_30_days = 1);

#2 factor lookup by Clover ID  
select r.name, a.name, a.email, af.*
from account a
join account_auth_factor aaf on a.id = aaf.account_id
join auth_factchor af on af.id = aaf.auth_factor_id
join merchant_role mr on mr.account_id = a.id
join merchant m on m.id = mr.merchant_id
join reseller r on r.id = m.reseller_id
where m.uuid = "6X84VEXXE62H1"
group by r.name, af.type;


# count of online order removing demo accounts
select DATE_FORMAT(oo.created_time, "%Y-%m-%d") as order_created_time, count(*) from orders o 
join online_order oo ON oo.order_id = o.id 
join meta.merchant m ON m.id = oo.merchant_id 
join meta.account a ON a.id = m.owner_account_id
where o.client_created_time >= DATE(DATE_SUB(NOW(), interval 6 month)) AND  m.name NOT LIKE '%DEMO%' AND a.email NOT like '%google.com%' AND a.email NOT like '%clover.com%' group by DATE_FORMAT(oo.created_time, "%Y-%m-%d") ;

#Merchant Group by merchant number 
select m.uuid, mgs.* from meta.merchant_groups mgs
join meta.merchant_group mg on mg.id = mgs.merchant_group_id
join meta.merchant m on mgs.merchant_id = m.id
where mg.uuid = "52HEX42SB0AJT";

#Merchant Group Based on day recieved  
select mg.uuid merchant_group_uuid, mg.name,  m.uuid merchant_uuid, m.name merchant_name, mgs.created_time added_to_merchant_group from meta.merchant_groups mgs
join meta.merchant_group mg on mg.id = mgs.merchant_group_id
join meta.merchant m on mgs.merchant_id = m.id
where mg.uuid =  'X1BH34PYSAVYY' order by mgs.created_time asc;

select *, round(timestampdiff(minute, (last_escalated_date), NOW())/60/24,2) as age 
from (select c.case_number, c.assigned_to_name,  c.created_date, c.subject,case when assigned_to_name in ("Adam Myers", "Mark Brunell", "Alejandro Sahagun",  "Tony Dellinger","Mason Bone","Vinny Mandarapu",  "Matt   Boddie","David Britton","Cory Johnston") then 'Tier 3' when assigned_to_name in ("Delilah Haas") then 'Provisioning' when assigned_to_name = 'Rusheen Watson' then 'Billing'  when subject  like  'PARENT%' then 'Parent' else 'Tier 3' end as Queue, 
  (select max(created_date) 
  from us_sf_case_history ch 
  where ch.case_number = c.case_number and ch.new_value='Clover West - Tier 3')  last_escalated_date, severity,priority  
  from us_sf_cases c where c.owner_name = 'Clover West - Tier 3' and c.status not in ('Closed','Closed Unresolved', 'Closed Resolved') and c.status_detail != 'Enhancement Request'  and c.assigned_to_name !='Yuting Ko' and c.assigned_to_name !='George Gong' and c.created_date > '2019-10-18' 
  union select cca.case_number,cca.assigned_to_name,  cca.created_date, cca.subject,case when assigned_to_name in ("Adam Myers", "Mark Brunell", "Alejandro Sahagun",  "Tony Dellinger","Mason Bone","Vinny Mandarapu", "Matt Boddie","David Britton","Cory Johnston") then 'Tier 3' when assigned_to_name in ("Delilah Haas") then 'Provisioning' when assigned_to_name = 'Rusheen Watson' then 'Billing'  when subject like 'PARENT%' then 'Parent' else 'Tier 3' end as Queue, 
  (select max(created_date) from ca_sf_case_history cach where cach.case_number = cca.case_number and cach.new_value='Clover West - Tier 3') last_escalated_date, severity, priority 
  from ca_sf_cases cca where owner_name = 'Clover West - Tier 3' and status not in ('Closed','Closed Unresolved', 'Closed Resolved')) 
r order by Queue, age;

#Use payment id where refnum is for gateway response 
select * from gateway_tx where refnum = 'DBPNTDEYWD2V4';

#check ROM for Argentina 
pattern: "/v2/internal/ota_status" AND deviceid: 7DBB602E1C744C02B542D955310F1368

#pull on SF cases and how old they are
select *, round(timestampdiff(minute, (last_escalated_date), NOW())/60/24,2) as age 
from (
select c.case_number, 
    c.assigned_to_name,  
    c.created_date, 
    c.subject,
    case when assigned_to_name in ("Adam Myers", "Mark Brunell", "Alejandro Sahagun", "Tony Dellinger", "Mason Bone", "Vinny Mandarapu", "Matt Boddie", "David Britton", "Dave Britton" "Cory Johnston") then 'Tier 3' 
    when assigned_to_name in ("Delilah Haas") then 'Provisioning' 
    when assigned_to_name = 'Rusheen Watson' then 'Billing'  
    when subject like 'PARENT%' then 'Parent' else 'Tier 3' end as Queue, 
      (select max(created_date) 
      from us_sf_case_history ch 
      where ch.case_number = c.case_number and ch.new_value='Clover West - Tier 3') last_escalated_date, 
      case when severity = -1 then 3 
      when severity is NULL then 3 else severity end as severity, 
      priority,
      'US' as region
      from us_sf_cases c 
      where c.owner_name = 'Clover West - Tier 3' 
      and c.status not in ('Closed','Closed Unresolved', 'Closed Resolved') 
      and c.status_detail != 'Enhancement Request'  
      and c.assigned_to_name !='Yuting Ko' 
      and c.assigned_to_name !='George Gong' 
      and c.created_date > '2019-10-18' 
      union
      select concat('0', eca.case_number), 
      eca.assigned_to_name, 
      eca.created_date, 
      eca.subject, 
      case when assigned_to_name in ("Adam Myers", "Mark Brunell", "Alejandro Sahagun",  "Tony Dellinger","Mason Bone","Vinny Mandarapu", "Matt Boddie","Dave Britton","Cory Johnston") then 'Tier 3' 
      when assigned_to_name in ("Delilah Haas") then 'Provisioning' 
      when assigned_to_name = 'Rusheen Watson' then 'Billing'  
      when subject like 'PARENT%' then 'Parent' else 'Tier 3' end as Queue, 
      (select max(created_date) 
      from eu_sf_case_history esch 
      where esch.case_number = concat('0', eca.case_number) and esch.new_value='Clover US Tier 3 Queue') last_escalated_date, 
      case when severity is NULL then 3
      when severity = 'S4' then 3
      when severity = 'S3' then 3
      when severity = 'S2' then 2
      when severity = 'S1' then 1 end as severity, 
      case when priority = 'Low' then 3
      when priority = 'Medium' then 2
      when priority = 'High' then 1 end as priority,
      'UK/IE' as region
      from eu_sf_cases eca 
      where owner_name = 'Clover US Tier 3 Queue' and status not in ('Closed','Closed Unresolved', 'Closed Resolved')
      union 
      select cca.case_number, 
      cca.assigned_to_name, 
      cca.created_date, 
      cca.subject, 
      case when assigned_to_name in ("Adam Myers", "Mark Brunell", "Alejandro Sahagun",  "Tony Dellinger","Mason Bone","Vinny Mandarapu", "Matt Boddie","David Britton","Cory Johnston") then 'Tier 3' 
      when assigned_to_name in ("Delilah Haas") then 'Provisioning' 
      when assigned_to_name = 'Rusheen Watson' then 'Billing'  
      when subject like 'PARENT%' then 'Parent' else 'Tier 3' end as Queue, 
      (select max(created_date) 
      from ca_sf_case_history cach 
      where cach.case_number = cca.case_number and cach.new_value='Clover West - Tier 3') last_escalated_date, 
      case when severity is NULL then 3 
      when severity = -1 then 3 else severity end as severity, 
      priority,
      'CA' as region
      from ca_sf_cases cca 
      where owner_name = 'Clover West - Tier 3' and status not in ('Closed','Closed Unresolved', 'Closed Resolved')) r order by field(Queue, 'Parent') desc, age desc;

#look for MAD tickets that are open
project = MAD AND status not in (CLOSE,RESOLVED) ORDER BY status DESC

#payment look up by check 
select p.uuid payment_uuid, p.amount*.01 as payment_amount, CONVERT_TZ(p.client_created_time, '+00:00','-04:00') as payment_device_created_time_est, CONVERT_TZ(o.client_created_time, '+00:00','-04:00') as order_client_created_time_est, p.note, p.external_payment_id as trace_id
from orders o
join meta.merchant m ON m.id = o.merchant_id
left join payment p ON p.order_id = o.id
where m.id = 848401 and p.client_created_time between "2020-04-02" and "2020-04-04" and p.note like "%Check%"
order by p.client_created_time;

#show TOA or COLO meta status
select m.id merchantid,m.uuid cloverid, m.name, oom.created_time online_merchant_added, oom.status menu_status, colo_provider.provider_name colo_name, colo_provider.enabled colo_enabled, colo_provider.oos_created_time colo_signup_started, toa_provider.provider_name toa_name, toa_provider.enabled toa_enabled,toa_provider.oos_created_time toa_signup_started from meta.online_order_merchant oom 
join meta.merchant m ON m.id = oom.merchant_id 
join meta.account a ON a.id = m.owner_account_id  
join meta.merchant_address ma ON ma.id = m.address_id  
left join (select oos.merchant_id oos_merchant_id, oop.name provider_name, oos.enabled, oos.created_time oos_created_time from meta.online_order_service oos
join meta.online_order_provider oop ON oop.id = oos.provider_id 
join meta.developer_app da ON da.id = oop.developer_app_id where da.package_name = 'com.clover.colo') colo_provider ON colo_provider.oos_merchant_id = m.id
left join (select oos.merchant_id oos_merchant_id, oop.name provider_name, oos.enabled, oos.created_time oos_created_time from meta.online_order_service oos
join meta.online_order_provider oop ON oop.id = oos.provider_id 
join meta.developer_app da ON da.id = oop.developer_app_id where da.package_name = 'is.mavn.clover') toa_provider ON toa_provider.oos_merchant_id = m.id
where oom.created_time > '2019-12-01'  AND  m.name NOT LIKE '%DEMO%' AND a.email NOT like '%google.com%' AND a.email NOT like '%clover.com%' order by status DESC;

#Who assigned what case to who within Salesforce 
select created_by_name, count(distinct(case_number)) from (
select *, case when created_by_name = new_value then true else false end as own from us_sf_case_history where field = 'Assigned_To__c' and created_date between '2020-01-01' and '2020-04-30' ) r  group by created_by_name;


#COLO Payments + TOA taken for any OLO provider based on Order ID that shows the Order State
select m.uuid as Cloverid, m.name as merchant_name, o.uuid as Order_UUID, p.uuid as Payment_UUID, gt.type, gt.entry_type,p.amount, p.tax_amount*.01 as PayTX, p.tip_amount*.01 as PayTipAMT, gt.response_message, gt.captured, p.result, oop.name as Order_Provider, oo.order_state as Order_Status, oo.created_time as order_created_time_utc
from orders o
join payment p ON p.order_id = o.id
join gateway_tx gt ON gt.id = p.gateway_tx_id
join online_order oo ON oo.order_id = o.id
join meta.online_order_provider oop ON oop.id = oo.provider_id
join meta.merchant m ON m.id = oo.merchant_id
where m.uuid = "YQHP06MPM0NX1";

#COLO Payments on timeframe:
select m.uuid as Cloverid, m.name as merchant_name, o.uuid as Order_UUID, p.uuid as Payment_UUID, gt.type, gt.entry_type,p.amount, p.tax_amount*.01 as PayTX, p.tip_amount*.01 as PayTipAMT, gt.response_message,pr.reason, gt.captured, p.result, oop.name as Order_Provider, oo.order_state as Order_Status, oo.created_time as order_created_time_utc
from orders o
join payment p ON p.order_id = o.id
join gateway_tx gt ON gt.id = p.gateway_tx_id
join online_order oo ON oo.order_id = o.id
join meta.online_order_provider oop ON oop.id = oo.provider_id
left JOIN payment_refund pr on pr.id = p.payment_refund_id
join meta.merchant m ON m.id = oo.merchant_id
where m.uuid = "AJ9J1S62R4TF1" AND p.client_created_time between '2021-04-30 00:00:00' and '2021-05-14 23:59:59' AND oop.name = "Clover Online Ordering";

#colo lookup order type for Merchants based on Ordertype id 
select m.uuid as Cloverid, m.name as merchant_name, o.uuid as Order_UUID, o.state as Order_State, o.order_type_id as Order_Type_ID, mot.label, oop.name as Order_Provider, oo.order_state as Order_Status, oo.created_time as order_created_time_utc, o.deleted_timestamp
from orders o
join merchant_order_type mot on o.order_type_id = mot.id 
join online_order oo ON oo.order_id = o.id
join meta.online_order_provider oop ON oop.id = oo.provider_id
join meta.merchant m ON m.id = oo.merchant_id
#where o.order_type_id = 138000000004654 and o.state = "open";
where o.uuid in ("AKZ3W8GFRKFAP", "2CAJR589TZ4X2", "T1T9FRX719350");

#Pull Online Ordering Enabled vs Disabled from the Database by Clover ID: 
select m.name as Merchant_Name, m.uuid as Clover_ID, oop.name as Provider_Name, oos.uuid as Service_UUID, oos.type as OLO_Order_Type, oos.enabled, oos.created_time, oos.modified_time, oos.start_time, oos.activated
from online_order_provider oop 
join online_order_service oos on oop.id = oos.provider_id
join merchant m on oos.merchant_id = m.id
where m.uuid = "PKRRH3ZWVCEPE";

#Pull Crash Report by Device Serial
select cr.* from crash_report cr
join meta.device d on d.id = cr.device_id
where d.serial = 'C032UQ83950186';

#Pull Crash 2.0
select ur.uuid, ur.report_type, ur.created_time, d.serial
from unified_report ur
join device d on d.id = ur.device_id
where d.serial IN ("C030UD65221028") and report_type = 'clover_debug';

#pull Last activation code
select last_activation_code from meta.device_provision where serial_number = 'C053UQ01530377';

#open orders validation 
select * from orders o 
left join payment p  on p.order_id = o.id
left join gateway_tx g on p.gateway_tx_id = g.id
where o.client_created_time between '2020-04-17 12:30:00' and '2020-04-18 17:32:00'  and o.state <> 'locked'
and p.uuid is null and o.total >0 and deleted_timestamp is null
and o.merchant_id =897946;

#Query to check delay
SELECT TIMEDIFF(NOW(),created_time) AS delay FROM orders.gateway_tx ORDER BY created_time DESC LIMIT 1;

#checks feature flags 
select * FROM meta.setting s
where s.merchant_id = '114925';

#device events query
select * from meta.device_events de 
join meta.merchant m on de.merchant_id = m.id 
where de.serial_number = "C010UQ60420271";

--find what shard an enterprise merchant is on
select mp.merchant_id, mp.orders_shard_id as shard
from enterprise e
join merchant_placement mp on mp.merchant_id = e.reference_merchant_id
where e.uuid = '0AATF04JBC5PY';

--enterprise merchant inventory(shows different location inventory)
select i.uuid, i.name as item_name, i.price*.01 as item_price, ist.quantity as item_quantity, rmo.reference_merchant_id as enterprise_merchant_id, m.id as merchant_id, m.uuid as merchant_uuid, m.name as merchant_name
from reference_merchant_object rmo
join meta.merchant m on m.id = rmo.target_merchant_id
join item i on i.uuid = rmo.reference_object_uuid
left join item_stock ist on ist.item_id = i.id
where rmo.reference_merchant_id = 1766593 and rmo.object_type like '%item%'
order by m.name;

#Pull account password History 
select *
from password_history
where account_id = 4804023;

#search for Devices based on UUID by Device type
select m.name, m.uuid as merchant_uuid, r.name as reseller_name, SUBSTRING_INDEX(mg.partner_uuid,':',1) AS MID, dp.serial_number, CASE WHEN dp.activated_time IS NOT NULL THEN 'Yes' ELSE 'No'  END AS activated, CONVERT_TZ(dp.activated_time, '+00:00','-07:00') as activated_time_pst 
from meta.device_provision dp 
right join meta.merchant m on m.id = dp.merchant_id
left join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
left join meta.reseller r on dp.reseller_id = r.id
where m.uuid in () AND dp.serial_number like 'C053%' and dp.merchant_id is not null and m.name not like "%demo%" order by m.uuid desc;

#search for merchant Plan Group by merchant uuid:
select mp.* 
from merchant m 
join audit_events ae on m.id=ae.merchant_id 
join merchant_plan mp on mp.id=ae.payload_int1 
where m.uuid in ("9FSNXQMWZKQD1");

#eu Salesforce case pull no zero 
select usc.case_number, usc.created_date, umm.business_name as merchant_name, umm.key_merchant_id as MID,umm.clover_id as CID, usc.serial_numbers as serial_number
from eu_sf_cases usc
left join eu_merchant_metadata umm on umm.key_merchant_id = usc.key_merchant_id
where usc.case_number IN ('6708631', '6678067');

#plan info for 3rd party app
select m.name, m.uuid, mp.name plan_name, da.name, mp.merchant_plan_group_id, ma.created_time, ma.deleted_time
FROM meta.merchant_app ma
JOIN meta.merchant m ON ma.merchant_id = m.id
JOIN meta.developer_app da ON da.id = ma.app_id
join meta.merchant_plan mp on mp.id = m.merchant_plan_id
where da.uuid = "HY42H05N7ABXC" and m.name not like "%Demo%" group by 2;

#pulling batch totals for a time frame by merchant
select m.id, m.uuid, m.name, b.total_batch_amount*.01 as Batch_Total, b.batch_type, b.state, b.created_time, b.modified_time
from meta.merchant m  
join batch b on b.merchant_id = m.id 
where m.uuid in ("12J5PQ8VVZFZ1") AND b.created_time between '2020-06-18 12:00:00' and '2020-06-23 23:59:59';

#searching for specific fields on a table 
select table_name, column_name from information_schema.columns where column_name like '%bank%';

#Search for the Shifts app by employee uuid between a time frame: 
select a.name, a.uuid, es.*
    from meta.employee_shift es
    join meta.account a on a.id = es.account_id
    where a.id in ("9097459", "13271137") AND es.in_time between '2020-06-29 00:00:00' and '2020-07-28 23:59:59'
    order by es.in_time desc;

#Get Employee role editing information
select mr.nickname,mr.account_id,mr.pin,mr.created_time as EmployeeCreated,mr.modified_time as EmployeeMod, mr.deleted_time as EmployeeDel,mr.role,r.name,r.system_role,r.modified_time as RoleMod,psr.modified_time as PermSetRoleMod,psr.deleted_time as PermSetRoleDel,ps.label,ps.name as PermSetName,ps.employee_default,ps.manager_default,ps.permissions,ps.modified_time as PermSetMod
FROM meta.merchant_role mr
JOIN meta.role r on r.id = mr.role_id
left JOIN meta.permission_set_role psr on psr.role_id = r.id
left JOIN meta.permission_set ps on ps.id = psr.permission_set_id
where mr.merchant_id = '530432'
order by mr.nickname,psr.modified_time;

# get summary payments against OLO orders
select m.name, m.uuid cloverid, .01*sum(p.amount) payment_sum, count(*) payment_count from online_order oo
join payment p ON oo.order_id = p.order_id
join meta.merchant m ON m.id = oo.merchant_id
join meta.account a ON a.id = m.owner_account_id
where m.name NOT LIKE '%DEMO%' AND a.email NOT like '%google.com%' AND a.email NOT like '%clover.com%' AND a.email NOT like '%fiserv%' AND a.email NOT like '%firstdata%'
group by m.name, m.uuid;

#device info 
select d.serial as device_serial,d.modified_time, r.*, ae.*
FROM meta.device d
JOIN meta.rom r on r.id = d.current_rom_id
join audit_events ae on ae.device_id = d.id
where d.serial in ('C050UQ93420050');

#Serial Number Audit Events 
select de.device_event, m.uuid as Clover_ID, m.name as Merchant_Name, de.timestamp, de.account_id Account_ID_Who_Made_A_Change, a.name as Account_Name, a.email as Account_Email  
from meta.device_events de 
join meta.merchant m on de.merchant_id = m.id
left join meta.account a on a.id = de.account_id 
where de.serial_number = "C050UQ94130180"
order by de.timestamp desc;

#John Wallace Request
select SUBSTRING_INDEX(mg.partner_uuid,':',1) AS MID, s.name, s.value 
FROM meta.merchant m 
join setting s on s.merchant_id = m.id
join merchant_gateway mg on mg.merchant_id = m.id
where m.merchant_id = "1874901" AND s.name = "SIGNATURE_THRESHOLD";

#List merchants per device UUID
select m.uuid, SUBSTRING_INDEX(SUBSTRING_INDEX(mg.partner_uuid, ':', 2), ':', -1) AS MID, m.name, d.serial from meta.merchant m
join meta.merchant_gateway mg on m.id = mg.merchant_id
join meta.merchant_device md on md.merchant_id = m.id 
join meta.device d on d.id = md.device_id 
where hex(d.uuid) in ("000000861085E6CA7638C80F7F2F588D",
"0000008ADE1C1454148C0577A08EE63D");

#HIPAA lookup
    select m.uuid, m.name, mm.old_merchant_plan_id, mm.new_merchant_plan_id, case when mg.config not like '%mcc%' then null else substring_index(substring_index(mg.config,'\"mcc\"\:\"',-1),'\"',1) end as mcc, ae.account_id, a.name, a.email, ae.type, mm.changed_timestamp
from meta.merchant_merchant_plan_history mm
join meta.merchant m on m.id = mm.merchant_id
join meta.merchant_gateway mg on mg.merchant_id = m.id
join meta.audit_events ae on ae.merchant_id = m.id
left join meta.account a on a.id = ae.account_id
where mm.old_merchant_plan_id in (211, 213) and mm.new_merchant_plan_id not in (211, 213) and minute(mm.changed_timestamp) = 43 and ae.type = "CHANGE_MERCHANT_PLAN" AND m.name != "Demo: NOT FOR ACTUAL USE"
order by changed_timestamp desc;

#TOA FF enabled but TOA not enrolled as a provider
select * from meta.merchant m
join meta.account a ON a.id = m.owner_account_id
join (select merchant_id, value from meta.setting where name = 'OLO_TOA_ENABLED' AND value = 1) setting ON setting.merchant_id = m.id
left join meta.online_order_merchant_provider oop ON oop.merchant_id = m.id
where a.email like 'robert+%@clover.com' AND oop.id is null;

#query to pull based on agent id
select m.uuid, m.name, m.created_time, mp.name 
from meta.merchant m 
join meta.merchant_plan mp on mp.id = m.merchant_plan_id
where SUBSTRING_INDEX(SUBSTRING_INDEX(hierarchy,'"',4),'"',-1) in (896970013885, 896970014883) and m.created_time >= "2020-07-01 00:00:00";

#tables look up on register lite
select m.name, m.uuid as Clover_uuid, da.name, da.package_name, da.uuid as developer_app_uuid, ma.uuid as merchant_app_uuid, ma.created_time, ma.deleted_time, mp.name
from merchant m 
Left join meta.merchant_app ma on m.id = ma.merchant_id
Left join meta.developer_app da on da.id = ma.app_id
Left join merchant_plan mp on mp.id = m.merchant_plan_id 
where da.package_name = "com.clover.tables2" AND mp.id = "7";

#mid look up in EU
select *
from meta.merchant m 
join meta.merchant_placement mp on mp.merchant_id = m.id 
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
where SUBSTRING_INDEX(SUBSTRING_INDEX(mg.partner_uuid,':',2),':',-1) in (520334509814141);

#Impact vs Last week 
select response_code, response_message, sum(current) as current, sum(previous) as previous, (1-(sum(previous)/sum(current)))*100 as diff  from(
select 1 as current, 0 as previous ,id,gateway_tx.response_message,gateway_tx.response_code 
from gateway_tx
#Change period below to impacted timeframe
where gateway_tx.created_time between '2020-08-30 09:00:00' and '2020-08-30 16:00:00'
#and gateway_tx.type in (1,2,3)
union
select 0 as current, 1 as previous ,id,gateway_tx.response_message,gateway_tx.response_code 
from gateway_tx
#Change period below to timeframe to compare against
where gateway_tx.created_time between '2020-08-23 09:00:00' and '2020-08-23 16:00:00'
#and gateway_tx.type in (1,2,3)
) d 
group by 1,2 order by 3 desc;

--kirby version to show category and associated item uuid's (need to supply category id)
SELECT id AS id, uuid, name, items AS item_uuids, deleted, modified_time, sort_order FROM meta.item_layout where id = '7392957';

#Modifer groups linking to Modifers
select mg.id, mg.uuid, mg.name, mm.modifier_id, mm.name
from layout l
left join modifier_group mg on l.id = mg.layout_id
left join modifier m on m.modifier_group_id = mg.id
left join modifier_menu mm on mm.modifier_id = m.id
where mm.merchant_id = 2511536;

--Impact count just by response message
select gateway_tx.response_message, count(1) as count, sum(gateway_tx.amount)*.01 as amount
from gateway_tx
where gateway_tx.created_time between '2020-07-03 23:50:03' and '2020-07-03 23:55:03'
group by 1;

--Impact pivoted
select meta.reseller.name, gateway_tx.response_message, count(1) as count, sum(gateway_tx.amount)*.01 as local_currency_amount
#Uncomment line below to get USD amount. Make sure to change currency exchange
#, (sum(gateway_tx.amount)*.01)/75.71 as usd_amount
from gateway_tx
left join meta.merchant_gateway on gateway_tx.merchant_gateway_id = meta.merchant_gateway.id
left join meta.merchant on meta.merchant_gateway.merchant_id = meta.merchant.id
left join meta.reseller ON meta.reseller.id = meta.merchant.reseller_id
left join meta.payment_processor on meta.merchant_gateway.payment_processor_id = meta.payment_processor.id
left join payment on payment.gateway_tx_id = gateway_tx.id
left join meta.device on payment.device_id = meta.device.id
where gateway_tx.created_time between '2020-09-22 14:05:00' and '2020-09-22 14:35:00'
group by 1,2 order by 3 desc;

#Impact per response comparing two periods
select response_code, response_message, sum(current) as current, sum(previous) as previous, (1-(sum(previous)/sum(current)))*100 as diff  from(
select 1 as current, 0 as previous ,g.id,g.response_message,g.response_code
from gateway_tx g
#Change period below to impacted timeframe
where g.created_time between '2020-08-30 09:00:00' and '2020-08-30 16:00:00'
union
select 0 as current, 1 as previous ,g.id,g.response_message,g.response_code
from gateway_tx g
#Change period below to timeframe to compare against
where g.created_time between '2020-08-23 09:00:00' and '2020-08-23 16:00:00') d
group by 1,2 order by 3 desc;

#pulling black screen tickets 
select concat('0', esc.case_number) as case_number, esc.created_date, emm.reseller_name, emm.business_name as merchant_name, emm.key_merchant_id as MID, emm.clover_id as CID
from eu_sf_cases esc
left join eu_merchant_metadata emm on emm.key_merchant_id = esc.merchant_id
#where esc.case_number in ('6781495', '6785450', '6792660');
where esc.reason_subtype_detail = 'Hibernation - Flex' and esc.owner_name = 'Clover US Tier 3 Queue' and esc.created_date > '2020-09-01';

#find the enterprise id
select distinct e.id, e.name, e.created_time
from enterprise e 
join enterprise_membership em on e.id = em.ancestor_id 
join merchant m on m.id = em.descendant_id 
join account a on a.id = m.owner_account_id 
where a.email = 'clover@playabowls.com';

#Multi-location Primary and Child Merchants associated
select m.id as m_id, m.uuid as m_uuid, m.name as m_name, a.id as a_id, a.uuid as a_uuid, a.name as a_name, e.id as e_id, e.uuid as e_uuid, e.name as e_name, em.created_time 
from enterprise e 
join enterprise_membership em on e.id = em.ancestor_id 
join merchant m on m.id = em.descendant_id 
join account a on a.id = m.owner_account_id 
where e.id = 4975;

#multi-location Primary Merchant
select m.id as m_id, m.uuid as m_uuid, m.name as m_name, a.id as a_id, a.uuid as a_uuid, a.name as a_name, e.id as e_id, e.uuid as e_uuid, e.name as e_name 
from account a 
join merchant m on a.id = m.owner_account_id 
join enterprise e on m.id = e.reference_merchant_id 
where e.id = 19141;

# ML get list of list of roles and merchant accounts from email
select m.uuid cloverid, m.name merchant_name, r.name role_name, a.email account_email, ao.email owner_email from meta.merchant_role mr
join meta.account a ON a.id = mr.account_id
join meta.merchant m ON m.id = mr.merchant_id
join meta.role r ON r.id = mr.role_id
left join meta.account ao ON ao.id = m.owner_account_id
where a.email = 'robert+workregister@clover.com';

# ML get list of list of roles and merchant accounts from email
select e.id enterpise_id, e.name ent_name, m.uuid cloverid, m.name merchant_name,  case when mb.account_status = '13' or mb.account_status = 'C' then "Closed" when mb.account_status = '16' then 'Open' else mb.account_status end as account_status,
mp.name plan_name, mp.type plan_type, mp.plan_code, r.name role_name, a.email account_email, ao.email owner_email 
from meta.merchant_role mr
join meta.account a ON a.id = mr.account_id
join meta.merchant m ON m.id = mr.merchant_id
join meta.role r ON r.id = mr.role_id
join meta.merchant_boarding mb ON mb.merchant_id = m.id
join meta.merchant_plan mp ON mp.id = m.merchant_plan_id
join meta.enterprise_membership em ON m.id = em.descendant_id
left join meta.enterprise e ON e.id = em.ancestor_id 
left join meta.account ao ON ao.id = m.owner_account_id
where a.email = 'boxdropcc@gmail.com' order by e.id;

#find merchant account associated with enterprise(lost merchant account that dont link) Put in Merchant UUId affected 
select m.id as m_id, m.uuid as m_uuid, m.name as m_name, mp.name plan_name, a.id as a_id, a.uuid as a_uuid, a.name as a_name, e.id as e_id, e.uuid as e_uuid, e.name as e_name 
from enterprise e 
join enterprise_membership em on e.id = em.ancestor_id 
join merchant m on m.id = em.descendant_id 
join account a on a.id = m.owner_account_id 
join meta.merchant_plan mp ON m.merchant_plan_id = mp.id
where m.uuid = 'ASMQTQE5VM7B1';

--Parent Case Query with shard info
select usc.case_number, usc.created_date, umm.business_name as merchant_name, umm.key_merchant_id as MID,umm.clover_id as CID, usc.serial_numbers as serial_number, 
case when umm.orders_shard_id in (0,1,2,3,4,5,6) then umm.orders_shard_id
when umm.orders_shard_id in (111,124,137,150,163,176,189,20,202,33,46,59,7,72,85,98) then 7
when umm.orders_shard_id in (112,125,138,151,164,177,190,203,21,34,47,60,73,8,86,99) then 8
when umm.orders_shard_id in (100,113,126,139,152,165,178,191,204,22,35,48,61,74,87,9) then 9
when umm.orders_shard_id in (10,101,114,127,140,153,166,179,192,205,23,36,49,62,75,88) then 10
when umm.orders_shard_id in (102,11,115,128,141,154,167,180,193,206,24,37,50,63,76,89) then 11
when umm.orders_shard_id in (103,116,12,129,142,155,168,181,194,207,25,38,51,64,77,90) then 12
when umm.orders_shard_id in (104,117,13,130,143,156,169,182,195,208,26,39,52,65,78,91) then 13
when umm.orders_shard_id in (105,118,131,14,144,157,170,183,196,209,27,40,53,66,79,92) then 14
when umm.orders_shard_id in (106,119,132,145,15,158,171,184,197,210,28,41,54,67,80,93) then 15
when umm.orders_shard_id in (107,120,133,146,159,16,172,185,198,211,29,42,55,68,81,94) then 16
when umm.orders_shard_id in (108,121,134,147,160,17,173,186,199,212,30,43,56,69,82,95) then 17
when umm.orders_shard_id in (109,122,135,148,161,174,18,187,200,213,31,44,57,70,83,96) then 18
when umm.orders_shard_id in (110,123,136,149,162,175,188,19,201,214,32,45,58,71,84,97) then 19
else null end as shard,
umm.orders_shard_id as microshard
from us_sf_cases usc
left join us_merchants umm on umm.key_merchant_id = usc.key_merchant_id
where usc.parent_case_number = '60888764'
AND usc.created_date > "2020-09-01";

#Pull Mid by Clover ID: 
select SUBSTRING_INDEX(SUBSTRING_INDEX(mg.partner_uuid,':',2),':',1) as MID, m.uuid as Clover_id, m.name as Business_name
from meta.merchant m 
join meta.merchant_placement mp on mp.merchant_id = m.id 
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
where m.uuid in ("H1XTR2M6V0YER");

#how to find assignment reason: 
select m.uuid as 'merchant uuid', m.name as 'merchant name', mp.uuid as 'plan uuid', mp.name as 'plan name', mp.type as 'plan type', ae.payload_str2 as 'assignment reason' 
from merchant m 
join audit_events ae on m.id=ae.merchant_id 
join merchant_plan mp on mp.id=ae.payload_int1 
where m.uuid='4DPS98HRAJT61';

# get curbside order count
select m.name, m.uuid cloverid, count(*) from orders o
join online_order oo ON oo.order_id = o.id
join merchant_order_type mot ON mot.id = o.order_type_id
join meta.merchant m ON m.id = o.merchant_id
join service_order_type sot ON sot.merchant_order_type_id = mot.id
where mot.label like '%Curbside%' and o.client_created_time > '2020-10-01' group by 1,2;

# get scheduled order count
select m.name, m.uuid cloverid, count(*) from orders o
join online_order oo ON oo.order_id = o.id
join merchant_order_type mot ON mot.id = o.order_type_id
join meta.merchant m ON m.id = o.merchant_id
join service_order_type sot ON sot.merchant_order_type_id = mot.id
where oo.scheduled = 1 and o.client_created_time > '2020-11-01' group by 1,2;

#merchants enabled for curbside on CWO
select m.name, m.uuid cloverid from meta.online_order_service oos 
join meta.online_order_provider oop ON oop.id = oos.provider_id
join meta.developer_app da ON da.id = oop.developer_app_id
join meta.merchant m ON oos.merchant_id = m.id
join meta.account a ON a.id = m.owner_account_id
where da.package_name = 'com.clover.colo' and oos.deleted_time is null and oos.type = 'CURBSIDE' and oos.enabled = 1 AND m.name NOT LIKE '%DEMO%' AND a.email NOT like '%google.com%' AND a.email NOT like '%clover.com%' AND a.email NOT like '%fiserv%' AND a.email NOT like '%firstdata%' ;

#merchants enabled scheduled orders
select m.name, m.uuid cloverid from meta.merchant m  
join meta.online_order_merchant oom ON oom.merchant_id = m.id
join meta.account a ON a.id = m.owner_account_id
where oom.schedule_order = 1 AND m.name NOT LIKE '%DEMO%' AND a.email NOT like '%google.com%' AND a.email NOT like '%clover.com%' AND a.email NOT like '%fiserv%' AND a.email NOT like '%firstdata%';

#Lookup Payment UUID when paid for invoices: 
select SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(session_details,'paymentDetails',-1), "\"", 5), "\"", -1) as Payment_UUID, cs.* 
from checkout_session cs 
where cs.merchant_uuid = "0V4XE6R329EM8" and cs.status = "PAID";

#Lookup Payment UUID under checkout invoice: 
select SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(session_details,'paymentDetails',-1), "\"", 5), "\"", -1) as Payment_UUID, cs.*
from checkout_session cs 
where SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(session_details,'paymentDetails',-1), "\"", 5), "\"", -1) IN ("RE0HG32R2NCCA",
"VJ3EZT0T3V1KP",
"3K22YW0RESR28",
"QC0X42JE5ZKEC",
"5K4M77MRAQ3D6");

#show all Payment and totals 
select SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(session_details,'paymentDetails',-1), "\"", 5), "\"", -1) as Payment_UUID,
cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(session_details,'total', -1), "," , 1), ":", -1) as decimal (7,2))*.01 as Total, cs.*
from checkout_session cs
where cs.merchant_uuid = "XP71ZEKN628R1";

#invoice by Order UUID: 
select oi.order_uuid, i.id as Invoice_ID, cs.*
from invoice i
join order_invoice oi on i.id = oi.invoice_id
join checkout_session cs on cs.invoice_id = i.id
where i.merchant_uuid = "6G420FWGH3MW6" AND i.created_time between "2021-06-30 00:00:00" and "2021-07-02 23:59:59";

#Requested Report Results:
 select id,uuid,type,status,created_time 
 from meta.export_aggregation 
 where merchant_id = 2891604; 

#find payments with 2 tax rates: 
select payment_id, uuid, count(1) 
from payment 
join payment_tax_rate on payment_id = payment.id 
where payment.merchant_id = 67673 and client_created_time >= '2020-09-02 23:00' AND client_created_time <= '2020-12-01 23:00' 
group by payment_id having count(1) > 1;

#Cash vs Accrual Accounting
#if 1 its cash, also if blank its cash. Accrual when having the flag and its set to 0 (zero)
select id,name,left(value,20),modified_time,deleted_time 
from setting 
where merchant_id= 2110609 and name='ITEMS_REPORT_BY_PAYMENT_TIME';

#check OLAP Snowflake group: 
select * 
from meta.merchant_groups mg 
join meta.server_feature_override_group sfog on sfog.merchant_group_id =mg.merchant_group_id  
where mg.merchant_id= 39945 and mg.deleted_time is null;

#Search for Hex UUID
select m.uuid CloverID, SUBSTRING_INDEX(mg.partner_uuid,':',1) AS MID, m.name, r.name, hex(d.uuid), d.serial from meta.device d 
join meta.device_provision dp ON dp.serial_number = d.serial
join meta.merchant m ON m.id = dp.merchant_id
JOIN meta.reseller r ON m.reseller_id = r.id
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
where dp.serial_number = "C050UN95220061";

#cash log by account for date range: 
select a.name, cel.* 
from cash_event_log cel
join meta.account a on a.id = cel.account_id
where cel.merchant_id = 1597877 and timestamp between '2021-01-01 00:00:00' and '2021-02-11 23:59:59';

#Look up plan UUID and get the country its available (Example below with CSR plan)
select da.name app_name, da.package_name, asbc.country, asbc.active, asbc.description from meta.developer_app da
JOIN meta.app_app_bundle aab ON aab.developer_app_id = da.id
JOIN meta.app_bundle ab ON aab.app_bundle_id = ab.id
JOIN meta.merchant_plan mp ON mp.app_bundle_id = ab.id 
join meta.app_subscription asb ON asb.developer_app_id = da.id
join meta.app_subscription_country asbc ON asbc.app_subscription_id = asb.id
where mp.uuid='2K9TXRWZC86H4' AND asbc.country NOT IN ('DE','PL','IE','GB') order by da.name;

# #1 check if single location part of enterprise by merchant uuid OR name
select m.id merchant_id, m.uuid merchant_uuid ,m.name location_name, a.email merchant_owner_account,case when esl.merchant_id is not null then 1 else 0 end as ent_single_location, e.uuid enterprise_uuid, e.id ent_id, e.name ent_name from meta.merchant m
left join meta.enterprise_single_location esl ON esl.merchant_id = m.id
left join meta.enterprise_membership em ON em.descendant_id = m.id
left join meta.enterprise e ON e.id = em.ancestor_id
left join meta.account a ON a.id = m.owner_account_id
where m.uuid = '0TA2WJKENZ9W5' OR m.name = 'rh_dev1-oct19_1';

# #2 supply enterprise uuid OR name to see what single locations are associated
select m.id merchant_id, m.uuid merchant_uuid, m.name location_name, a.email merchant_owner_account, e.uuid enterprise_uuid, e.id enterprise_id, e.name enterprise_name from enterprise e
join enterprise_membership em on e.id = em.ancestor_id
left join meta.merchant m ON m.id = em.descendant_id
left join meta.account a ON a.id = m.owner_account_id
where e.uuid = 'HS213KTNNA1PG' OR e.name = 'rh_dev1-oct19_1' ;

# #3 supply email to see employee role OR owner at location
select a.id account_id, a.email, case when ao.id is not null then 1 else 0 end as owner_on_location , mr.role merchant_role, mr.id merchant_role_id, mr.merchant_id merchant_role_merchant_id, m.uuid merchant_uuid, m.name merchant_name from meta.account a
join meta.merchant_role mr ON mr.account_id = a.id
join meta.role r ON r.id = mr.role_id
join meta.merchant m ON mr.merchant_id = m.id
left join meta.account ao ON ao.id = m.owner_account_id
where a.email = 'robert+rh_dev1-enterprise_1@clover.com' and mr.deleted_time is null;

# look up Gift Card Transactions: 
select o.uuid, gc.uuid as gc_uuid, gc.payment_uuid as giftcard_payment_uuid, gc.created_time, gt.type, gt.card_type, gt.response_code, gt.response_message, gt.amount*.01 as amount,
case when gt.extra not like '%acctNum%' then null else substring_index(substring_index(gt.extra,'\"acctNum\"\:\"', -1),'\"', 1) end as giftcard_number
from giftcard_tx gc
join gateway_tx gt on gt.id = gc.gateway_tx_id
join meta.merchant m on m.merchant_gateway_id = gt.merchant_gateway_id
join payment p on p.uuid = gc.payment_uuid 
join orders o on o.id = p.order_id 
where gt.created_time between '2020-12-01 00:00' and '2020-12-25 00:00' and m.uuid = 'E0ET67Z1JQH7W';

#List merchants per device UUID
select m.uuid as clover_id, 
SUBSTRING_INDEX(SUBSTRING_INDEX(mg.partner_uuid, ':', 2), ':', -1) AS MID, #This is for EU merchants
#SUBSTRING_INDEX(mg.partner_uuid,':',1) AS MID, #This is for NA merchants
m.name, 
d.serial,
r.name
from meta.device d
left join meta.merchant_device md on md.device_id = d.id
left join meta.merchant m on m.id = md.merchant_id 
left join meta.merchant_gateway mg on m.id = mg.merchant_id 
join meta.reseller r on m.reseller_id = r.id
where hex(d.uuid) in ("0D5310875493470F99E9330BB5911092");

--check to see if the merchant email is different than enterprise email
select m.id as MID, m.uuid as CID, m.name as merchant_name, mp.name plan_name, a.uuid as merchant_owner_uuid, a.name as merchant_owner_name, a.email as merchant_owner_email,
  e.uuid as enterprise_uuid, e.name as enterprise_name, a2.uuid as enterprise_owner_uuid, a2.name as enterprise_owner_name, a2.email as enterprise_owner_email
from enterprise e 
join enterprise_membership em on e.id = em.ancestor_id 
join merchant m on m.id = em.descendant_id 
join account a on a.id = m.owner_account_id 
join meta.merchant_plan mp ON m.merchant_plan_id = mp.id
join enterprise_account_role ear on ear.enterprise_id = e.id
join account a2 on a2.id = ear.account_id 
where m.uuid in ('6JGHES8Q7F8Z1', '2PXNQR3M1ATQ1', '8B9XZQS4QRAT1');

#Query to pull Station Solo Field test Merchant cases after a date range:
select case_number, umm.business_name as merchant_name, umm.clover_id as CID, usc.key_merchant_id as MID, usc.serial_numbers as serial_number, usc.status, usc.created_date, usc.subject, usc.description, usc.resolution_comments 
from us_sf_cases usc
left join us_merchant_metadata umm on umm.key_merchant_id = usc.key_merchant_id
where usc.key_merchant_id in (209212303884,
984240584883,
100203974884,
526206608881,
953206231888,
374257468883,
945204196881,
239200719882,
376283103996,
846222608883,
844214317886,
218228797997,
235269330991,
844213559884,
235267034991,
341228309884,
235267570994,
844212902887,
825375566882,
374225334886,
846223151883,
844220082888,
953206054884,
334322999882,
844213247886,
526212208882,
209207167880,
844212959887,
235271732994) 
and usc.created_date > '2021-02-29' order by usc.created_date desc;

# 16 = Open, 13 = Closed for account status
select r.name, mb.account_status, count(DISTINCT(m.uuid))
from merchant m
LEFT JOIN meta.merchant_boarding mb ON mb.merchant_id = m.id
join meta.reseller r on r.id = m.reseller_id
where mb.account_status = 16 AND r.uuid = "S4D3ADCVE6GAY";

#check when password expires
 select a.email, a.name, ape.*
    from meta.account a
    join meta.account_password_expiry ape on a.id = ape.account_id 
    where a.email = "mason.bone+merchant@clover.com";

#Use to find batch values if you gave the Merchant_gateway_id:
select id, amount, card_type, refnum, response_code, response_message, created_time 
from gateway_tx where merchant_gateway_id = 2505691 and created_time > "2021-02-24 13:14:00" and type = 'preauthcapture';

#get order, line item, item, modifier group, and modifier information  + item_menu_name, modifier_menu, and modifier_group_name from order uuid
select o.uuid order_uuid, o.note, li.name lineitem_name, i.name item_name, imi.name item_menu_name, mg.name modifier_group_name, mgm.name modifier_group_menu_name, m.name modifier_name, mm.name modifier_menu_name from orders o
join line_item li ON li.order_id = o.id
join item i ON i.id = li.item_id
left join line_item_modification lim ON lim.line_item_id = li.id
left join modifier m ON m.id = lim.modifier_id
left join modifier_group mg ON mg.id = m.modifier_group_id
left join modifier_group_menu mgm ON mgm.modifier_group_id = mg.id
left join modifier_menu mm ON mm.modifier_id = m.id
left join item_menu_item imi ON imi.item_id = i.id
 where o.uuid = '62BB7QWC0JE0P' limit 100;

 #Check for Scheduled Orders for COLO: 
select o.uuid, oo.* from orders o
join online_order oo ON oo.order_id = o.id
where o.merchant_id = 2073623 and o.client_created_time > '2021-01-01' and oo.scheduled = 1;

#query to pull for pro delay
select usc.case_number, umm.clover_id, umm.key_merchant_id, umm.business_name, usc.created_date, usc.subject, usc.description, uscc.comment_body, usc.resolution_comments
from us_merchant_metadata umm
join us_sf_cases usc on usc.key_merchant_id = umm.key_merchant_id
join us_sf_case_comments uscc on uscc.case_number = usc.case_number
where (usc.serial_numbers like "%C053%" OR uscc.comment_body like "%C053%") AND (usc.subject like "%lag%" OR uscc.comment_body like "%delay%" OR uscc.comment_body like "%lag%" OR usc.description like "%lag%" OR usc.description like "stall%"OR usc.description like "%delay%" OR usc.resolution_comments like "%lag%") AND usc.created_date between '2021-01-01 00:00:00' and '2021-03-02 23:59:59'
order by usc.created_date;

#staton Solo Pull: 
select dp.serial_number, m.uuid, m.name from meta.device_provision dp 
left join meta.merchant m on m.id = dp.merchant_id 
where dp.serial_number like "C051%";

#duplicate Admin Roles: 
select m.uuid, m.name, r.merchant_id, count(r.merchant_id) as total 
 from meta.role r 
 join meta.merchant m on r.merchant_id = m.id
 where (r.system_role = "admin" and r.name = "admin") AND r.deleted_time is NULL
 group by r.merchant_id
 having total > 1;

 #lookup sim by device: 
select dp.serial_number, s.uuid,s.iccid,.s.status,sdp.created_time,sdp.deleted_time,dp.serial_number,dp.merchant_id 
FROM meta.device_provision dp 
inner JOIN meta.sim_device_provision sdp on dp.id = sdp.device_provision_id 
inner JOIN meta.sim s on sdp.sim_id = s.id 
inner join meta.merchant m ON m.id = dp.merchant_id
inner join meta.reseller r ON r.id = m.reseller_id
where dp.serial_number in ("C031UQ83050045"); 
#where m.uuid in ("");

# 3 week lookback for Clover Go
select Clover_ID, reseller_name, card_type, result,response_code,response_message,offline, first4,
CASE
    WHEN reseller_name = "FDC - BAMS" THEN "BAMS"
    WHEN reseller_name IN ("RSA", "EMPS") THEN "RSA"
    WHEN reseller_name = "Wells Fargo" THEN "Wells Fargo"
    WHEN reseller_name = "PNC" THEN "PNC"
    WHEN reseller_name IN ("Ignite","CARD CONNECT","Ignite - Omaha","CARD CONNECT") THEN "Card Connect"
    WHEN reseller_name = "FDC - BAMS" THEN "BAMS"
    ELSE "ISO" END as reseller,
impact_amount,
impact_count,
impact_week
from
((select r.name as reseller_name,
gtx.card_type as Card_Type,
gtx.first4,
gtx.amount *.01 as amount,
1 as impact_count,
p.client_created_time,
p.result,
p.offline,
gtx.response_code,
gtx.response_message,
m.uuid as Clover_ID,
0 as impact_week
from payment p
join gateway_tx gtx on p.gateway_tx_id = gtx.id
join meta.merchant m on m.id = p.merchant_id
join meta.reseller r on r.id = m.reseller_id
join meta.merchant_gateway mg on mg.id = m.merchant_gateway_id
join meta.device d on p.device_id = d.id
WHERE mg.payment_processor_id NOT IN(1,3,6)
AND p.client_created_time BETWEEN "2021-03-13 01:01:00" AND "2021-03-13 02:52:00" AND d.device_type_id = 21)
UNION
(select r.name as reseller_name,
gtx.card_type as Card_Type,
gtx.first4,
gtx.amount *.01 as amount,
1 as impact_count,
p.client_created_time,
p.result,
p.offline,
gtx.response_code,
gtx.response_message,
m.uuid as Clover_ID,
1 as impact_week
from payment p
join gateway_tx gtx on p.gateway_tx_id = gtx.id
join meta.merchant m on m.id = p.merchant_id
join meta.reseller r on r.id = m.reseller_id
join meta.merchant_gateway mg on mg.id = m.merchant_gateway_id
join meta.device d on p.device_id = d.id
WHERE mg.payment_processor_id NOT IN(1,3,6)
AND p.client_created_time BETWEEN "2021-03-06 01:01:00" AND "2021-03-06 02:52:00" AND d.device_type_id = 21)
UNION
(select r.name as reseller_name,
gtx.card_type as Card_Type,
gtx.first4,
gtx.amount *.01 as amount,
1 as impact_count,
p.client_created_time,
p.result,
p.offline,
gtx.response_code,
gtx.response_message,
m.uuid as Clover_ID,
2 as impact_week
from payment p
join gateway_tx gtx on p.gateway_tx_id = gtx.id
join meta.merchant m on m.id = p.merchant_id
join meta.reseller r on r.id = m.reseller_id
join meta.merchant_gateway mg on mg.id = m.merchant_gateway_id
join meta.device d on p.device_id = d.id
WHERE mg.payment_processor_id NOT IN(1,3,6)
AND p.client_created_time BETWEEN "2021-02-27 01:01:00" AND "2021-02-27 02:52:00" AND d.device_type_id = 21)
UNION
(select r.name as reseller_name,
gtx.card_type as Card_Type,
gtx.first4,
gtx.amount *.01 as amount,
1 as impact_count,
p.client_created_time,
p.result,
p.offline,
gtx.response_code,
gtx.response_message,
m.uuid as Clover_ID,
3 as impact_week
from payment p
join gateway_tx gtx on p.gateway_tx_id = gtx.id
join meta.merchant m on m.id = p.merchant_id
join meta.reseller r on r.id = m.reseller_id
join meta.merchant_gateway mg on mg.id = m.merchant_gateway_id
join meta.device d on p.device_id = d.id
WHERE mg.payment_processor_id NOT IN(1,3,6)
AND p.client_created_time BETWEEN "2021-02-20 01:01:00" AND "2021-02-20 02:52:00" AND d.device_type_id = 21)) as x

# Phone number by account 
select pn.* from meta.account a 
join meta.account_auth_factor aaf on a.id = aaf.account_id 
join meta.account_phone_number apn on a.uuid = apn.account_uuid
join meta.phone_number pn on apn.phone_number_uuid = pn.uuid
where email = "TREERAT311@HOTMAIL.COM"

--HIPPA plan query
select m.name, m.uuid, SUBSTRING_INDEX(mg.partner_uuid,':',1) AS MID, case when mg.config not like '%mcc%' then null else substring_index(substring_index(mg.config,'\"mcc\"\:\"',-1),'\"',1) end as mcc, mp.type
from merchant AS m
JOIN reseller r ON m.reseller_id = r.id
join merchant_gateway mg on mg.merchant_id = m.id
join merchant_plan mp ON mp.id = m.merchant_plan_id
join merchant_boarding mb ON mb.merchant_id = m.id
WHERE substring_index(substring_index(mg.config,'\"mcc\"\:\"',-1),'\"',1) in (4119,
5975,
5976,
5912,
8011,
8021,
8031,
8041,
8042,
8043,
8049,
8050,
8062,
8071,
8099) and mb.account_status = 16;

#Check Surcharge:
select * from additional_charge where merchant_id = 2760867;

# Check remote firing queue
select d.serial, o.uuid order_uuid, o.created_time order_created, p.created_time payment_created_time, peq.print_time, peq.created_time print_created_time,peq.modified_time print_modified_time, peq.deleted_time print_deleted_time from print_event_queue peq 
join meta.device d ON d.id = peq.device_id 
join orders o ON o.id = peq.order_id 
join payment p ON o.id = p.order_id  
where o.uuid = 'E291DZQSH637E';

#Grubhub Order Lookup by Clover ID: 
select m.name, o.uuid as Order_UUID, p.uuid as Payment_UUID, p.amount*.01 as Pay_Amount, p.tax_amount*.01 as PayTX, p.tip_amount*.01 as PayTipAMT, p.result, mot.label as Order_Type, oo.order_state as Order_Status, oo.created_time as order_created_time_utc 
from orders o
join payment p ON p.order_id = o.id
join online_order oo ON oo.order_id = o.id
join meta.online_order_provider oop ON oop.id = oo.provider_id
join merchant_order_type mot ON mot.id = o.order_type_id
join meta.merchant m ON m.id = o.merchant_id
join service_order_type sot ON sot.merchant_order_type_id = mot.id
where m.uuid = "5ZRXX3GQK5KH0" AND mot.label in ("Grubhub In-store Pickup", "GrubHub Delivery");

#check Requested report queue
select status, percent_complete, count(1) from export_aggregation group by 1,2;

#app charge query    
select
m.id as mmerchant_id,
m.uuid as merchant_uuid,
m.name as m_name,
r.name as reseller_name,
mb.account_status,
c.id,
c.uuid,
c.status,
c.amount*.01,
c.tax*.01,
c.type,
c.created_time,
da.name as app_name,
d.name as developer_name,
da.uuid as app_uuid,
d.uuid as developer_uuid,
c.export_month
from
charge c
join merchant_app_charge mac on mac.charge_id = c.id
join merchant_app ma on mac.merchant_app_id = ma.id
join merchant m on ma.merchant_id = m.id
join developer_app da on ma.app_id = da.id
join developer d on da.developer_id = d.id
join reseller r on m.reseller_id = r.id
left join merchant_boarding mb on mb.merchant_id = m.id
where m.uuid in ('ANPGBMS73DT31');

#plan charge query
select
m.uuid as merchant_uuid,
m.name as m_name,
r.name as reseller_name,
mb.account_status,
c.id,
c.uuid,
c.status,
c.amount*.01 as amount,
c.tax*.01 as tax,
c.amount*.01 as amount,
c.type,
c.created_time,
mp.name as plan_name,
c.start_date as plan_start_date,
c.end_date as plan_end_date,
mpc.num_of_devices as plan_num_of_devices,
mpc.plan_charge_type,
c.export_month
from
charge c
join merchant_plan_charge mpc on mpc.charge_id = c.id
join merchant m on mpc.merchant_id = m.id
join reseller r on m.reseller_id = r.id
join merchant_plan mp on mpc.merchant_plan_id = mp.id
left join merchant_boarding mb on mb.merchant_id = m.id
where m.uuid in ("NBZ729HQXTBA1");

#Check Uninstall reason if boarding related: 
select a.id, a.uuid, a.app_id, a.merchant_id, a.deleted_time, a.created_time, a.modified_time, a.uninstall_type,   d.id,d.uuid,d.name   
from meta.merchant_app a 
join meta.developer_app d on app_id=d.id   
where merchant_id=12746 order by d.name;

#Utilized to find Apps and when installed 
select da.name, da.uuid as Dev_App, ma.uuid as Merch_App, ma.created_time, ma.deleted_time
from meta.merchant_app ma
join meta.developer_app da on da.id = ma.app_id
where merchant_id = 2651323;

# Rapid Deposit ineligibe check
select mra.* 
from merchant_risk_assessment mra 
join meta.merchant m on m.id = mra.merchant_id 
where m.uuid = '3VGTZRVNCAYV1';

#converts a MID to a UUID 
select SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, m.uuid
from meta.merchant m 
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
where SUBSTRING_INDEX(mg.partner_uuid,':',1) in ('318000255154',
'318000292901',
'318000292900',
'31800008545',
'318891970887',
'318331142998',
'318904530991',
'25268830015',
'22317390011',
'22349510016',
'22302080015',
'22485950018',
'318397395993',
'22317390011',
'22499850014',
'22485090013',
'82444910012',
'82479490013',
'82479330011',
'82479390015');

#Look for merchant group based on Account and merchant group 
select m.id, m.uuid, m.name 
from merchant m 
join merchant_groups mgs on m.id = mgs.merchant_id 
join merchant_group mg on mgs.merchant_group_id = mg.id 
where mg.name = 'REQUIRED_MFA' and m.id IN (select distinct(merchant_id) from merchant_role where account_id = 9988585);

#device Request table lookup:
select dr.* 
from meta.device d
join meta.device_request dr on dr.device_id = d.id
where d.serial = "C031UD00220005";

#for single sharded regions (LA or EU), this query gives the pivot version in one run, if anyone is interested
select gateway_tx.response_message, count(1) as count, (sum(gateway_tx.amount))*.01 as amount
from gateway_tx
left join meta.merchant_gateway on gateway_tx.merchant_gateway_id = meta.merchant_gateway.id
left join meta.merchant on meta.merchant_gateway.merchant_id = meta.merchant.id
left join meta.reseller ON meta.reseller.id = meta.merchant.reseller_id
left join meta.payment_processor on meta.merchant_gateway.payment_processor_id = meta.payment_processor.id
left join payment on payment.gateway_tx_id = gateway_tx.id
left join meta.device on payment.device_id = meta.device.id
where gateway_tx.created_time between '2021-06-06 00:40:00' and '2021-06-06 01:15:59'
group by gateway_tx.response_message;

# Search for account 2FA details by email
select a.uuid as account_uuid, 
a.name, 
a.email,
a.locked_out as account_locked_out,
a.password_updated_time,
a.is_active as account_is_active,
a.last_login,
af.`type` as 2FA_type,
af.country_code,
af.phone_number,
af.created_time,
af.modified_time,
af.deleted_time
from meta.account a
join meta.account_auth_factor aaf on a.id = aaf.account_id
join meta.auth_factor af on aaf.auth_factor_id = af.id 
where a.email = "REGINA@CRA-ARRAY.COM";

#Batch Delay:
SELECT m.uuid as merchant_uuid, m.name as merchant_name, COALESCE(JSON_UNQUOTE(JSON_EXTRACT(mg.config, '$.bemid')),JSON_UNQUOTE(JSON_EXTRACT(mg.config, '$.mid'))) as FD_MID, 
r.uuid as reseller_uuid, r.name as reseller_name, 
closeout_time_difference,
DATE_FORMAT(convert_tz(b.created_time, '+00:00','-04:00'), '%H:%i') as batch_created_hour_minute,
mg.closing_time as auto_closeout_time, total_batch_amount*.01 as batch_amount
FROM batch b 
JOIN batch_details bd ON bd.batch_id = b.id 
JOIN meta.merchant m ON m.id = b.merchant_id 
JOIN meta.reseller r on m.reseller_id = r.id 
JOIN meta.merchant_gateway mg on mg.id = m.merchant_gateway_id 
WHERE b.created_time BETWEEN "2021-06-22 05:53:00" AND "2021-06-22 10:50:00" AND bd.closeout_time_difference < 0;

#find gateway tipping enabled based on merchant group!
select m.tips_enabled, mg.* from meta.merchant m 
join meta.merchant_gateway mg on m.merchant_gateway_id = mg.id
where  mg.config like '%"supports_tipping":"true"%' 
and m.id in (select mgs.merchant_id from meta.merchant_groups mgs join meta.merchant_group mg on mg.id = mgs.merchant_group_id where mg.uuid in ('J39ZNKWVQT78T','ANF9CDNFZZCCW','6P47BQ4CW1S92','JHZHSJNT9DAV8','FVV2T6R43F32Y','9W34VMFM62ZHP','YP8M2PW0T0Q26'));

#Manual Refund Super Query
select cr.uuid as Manual_Refund_UUID, 
o.uuid as Order_UUID,   
gt.response_code, 
gt.response_message,  
gt.client_id as TRANS_ID,
gt.type,
gt.entry_type,
gt.captured,
concat(gt.card_type,' ', gt.first4,'xxx', gt.last4) CardNum,
gt.authcode,
CASE WHEN gt.extra LIKE '%cvmResult%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(gt.extra,'\"cvmResult\"\:\"',-1),'\"',1) ELSE NULL END AS cvmResul,
gt.amount*.01 as GTinitAMT,
gt.adjust_amount*.01 as GT_TIP
from gateway_tx gt
left join credit cr on cr.gateway_tx_id = gt.id
left join orders o on o.id = cr.order_id
where cr.uuid in ("5DK5N84XK1QTT", "1C3XFQ0C9B3K0", "HAFRV4SX7RMEY")
order by cr.created_time ASC;

#Pull Merchant id on Merchant Table
select m.uuid as Clover_id, m.name as merchant_name, r.name as reseller_name   
from meta.merchant m 
join meta.reseller r on r.id = m.reseller_id 
where m.id in ();

#Check for Failed batches on timeframe
select uuid, merchant_id, tx_count, total_batch_amount*.01, state, batch_type, created_time 
from batch where state = "FAILED" AND created_time between '2021-08-17 02:00:00' and '2021-08-17 06:00:00';

#Service charge lookup by merchant and time
 select o.uuid as order_uuid, oa.name as order_account_name, do.serial as order_serial, p.uuid as payment_uuid, pa.name as payment_account_name, dp.serial as payment_serial, o.total, o.title, o.pay_type, p.amount, p.tip_amount, p.tax_amount , gt.type, 
 gt.entry_type, gt.card_type, p.client_created_time as payment_time, sr.percentage_decimal as service_charge_perc, sr.name as service_charge_name, psr.amount as payment_service_charge, sr.amount as order_service_charge
from orders o
left join payment p on o.id=p.order_id
left join gateway_tx gt on p.gateway_tx_id=gt.id
left join orders_service_charge sr on sr.order_id=o.id
left join payment_service_charge psr on psr.payment_id=p.id
left join meta.account oa on o.account_id = oa.id
left join meta.account pa on p.account_id = pa.id
left join meta.device do on o.device_id = do.id
left join meta.device dp on p.device_id = dp.id
where o.merchant_id = 343047 and o.client_created_time BETWEEN "2021-11-19 00:00" and "2021-11-20 23:59" and sr.name is not NULL;

#pull merchants based on Hierarchy
SELECT
m.id as 'merchant id',
m.name as 'merchant name',
m.reseller_id,
m.uuid,
m.created_time,
r.name as 'reseller name',
mp.name as 'plan name',
mp.type as 'plan type',
mb.account_status as 'account status',
a.name,
a.email
FROM merchant m
LEFT JOIN merchant_boarding mb on m.id = mb.merchant_id
LEFT JOIN reseller r on r.id = m.reseller_id
LEFT JOIN merchant_plan mp on mp.id = m.merchant_plan_id
LEFT JOIN account a on a.id = m.owner_account_id
WHERE m.hierarchy like '%"Corp":"825960940880"%';

#find if a merchant has a 3rd party app installed with a list of Clover ID's
select  m.uuid, m.uuid as merchant_name, m.name as Clover_ID, 
exists (select 1 from meta.merchant_app ma join meta.developer_app da on da.id = ma.app_id where da.uuid in ('YAEV42T6NX2X2', '1C9AKCT0C977A') and ma.merchant_id = m.id  and ma.deleted_time is null) as app_installed
from meta.merchant m
where m.uuid in ("");

#MID pull with reseller info 
select m.name as Merchant_name, m.uuid as Clover_ID, SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, r.name as Reseller_name, r.uuid as Reseller_UUID 
from meta.merchant m
join meta.merchant_placement mp on mp.merchant_id = m.id 
JOIN meta.reseller r on m.reseller_id = r.id 
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
where SUBSTRING_INDEX(mg.partner_uuid,':',1) in (496426111886);

#Serial Lookup including MID: 
select m.name as merchant_name, m.uuid as Clover_id, SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, dp.serial_number 
from meta.merchant m 
join meta.merchant_placement mp on mp.merchant_id = m.id 
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
join meta.device_provision dp on m.id = dp.merchant_id
JOIN meta.reseller r on m.reseller_id = r.id 
where serial_number in ("C032UQ00320625")
order by m.name ASC;

#List locations by hierarchy with plan group and plan name
select m.name, m.uuid, m.created_time, mpg.name as plan_group, mp.name as plan_name
from merchant m
join meta.merchant_plan mp on mp.id = m.merchant_plan_id
join merchant_plan_group mpg on mpg.id=mp.merchant_plan_group_id
where hierarchy like '%419960201996%' 
ORDER BY created_time desc;

#List of Locations by hierarchy and reseller with MID: 
select r.id, r.name as Reseller_Name, r.uuid as Reseller_UUID, m.name as Merchant_Name, m.uuid as Clover_ID, SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, mb.account_status, m.created_time, mpg.uuid as Plan_Group_UUID, mpg.name as Plan_Group, mp.uuid as Merchant_Plan_UUID, mp.name as Plan_Name
from meta.merchant m
join meta.reseller r on m.reseller_id = r.id
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
join meta.merchant_plan mp on mp.id = m.merchant_plan_id
join merchant_plan_group mpg on mpg.id=mp.merchant_plan_group_id
LEFT JOIN meta.merchant_boarding mb ON mb.merchant_id = m.id
where m.hierarchy like "%526986473886%"
ORDER BY created_time desc;

#Pulls accurate plan but maybe duplicates
select r.id, r.name as Reseller_Name, r.uuid as Reseller_UUID, m.name as Merchant_Name, m.uuid as Clover_ID, SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, mb.account_status, m.created_time, mpg.uuid as Plan_Group_UUID, mpg.name as Plan_Group, mp.uuid as Merchant_Plan_UUID, mp.name as Plan_Name
from meta.merchant m
join meta.reseller r on m.reseller_id = r.id
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
join meta.merchant_plan mp on mp.id = m.merchant_plan_id
join meta.merchant_plan_merchant_plan_group mpmpg on mp.id=mpmpg.merchant_plan_id
join meta.merchant_plan_group mpg on mpg.id=mpmpg.merchant_plan_group_id
LEFT JOIN meta.merchant_boarding mb ON mb.merchant_id = m.id
where m.hierarchy like "%526986473886%"
ORDER BY created_time desc;

#List of Locations by reseller with MID and Account_Status: 
select r.name as Reseller_Name, r.uuid as Reseller_UUID, m.name as Merchant_Name, m.uuid as Clover_ID, SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, mb.account_status, m.created_time, mpg.uuid as Plan_Group_UUID, mpg.name as Plan_Group, mp.uuid as Merchant_Plan_UUID, mp.name as Plan_Name
from merchant m
join reseller r on m.reseller_id = r.id
join meta.merchant_placement merp on merp.merchant_id = m.id 
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
join meta.merchant_plan mp on mp.id = m.merchant_plan_id
join merchant_plan_group mpg on mpg.id=mp.merchant_plan_group_id
LEFT JOIN meta.merchant_boarding mb ON mb.merchant_id = m.id
where r.uuid = "RZHHWJ30S8VMW"
ORDER BY created_time desc;

#Pull Modifier Groups for a merchant: 
select mg.uuid, mg.name, m.* 
from modifier_group mg 
join modifier m on m.modifier_group_id = mg.id
#for empty named items
#where mg.merchant_id = 3031906 and m.name = " ";
where m.uuid in ("AD2E4N69NCSYC", "JXK3W75AXZBW8")

#Pull a list of Serials that have been activated my MID: 
select m.name as merchant_name, m.uuid as Clover_id, SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, dp.serial_number 
from meta.merchant m 
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
join meta.device_provision dp on m.id = dp.merchant_id
JOIN meta.reseller r on m.reseller_id = r.id 
where SUBSTRING_INDEX(mg.partner_uuid,':',1) = 984173488888 and dp.activated_time is not null
order by m.name ASC;

#List of Locations by hierarchy and reseller with MID and Account_Status including mcc and device: 
select r.name as Reseller_Name, r.uuid as Reseller_UUID, m.name as Merchant_Name, m.uuid as Clover_ID, SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, mb.account_status, m.created_time, mpg.uuid as Plan_Group_UUID, mpg.name as Plan_Group, mp.uuid as Merchant_Plan_UUID, mp.name as Plan_Name, 
case when mg.config not like '%mcc%' then null else substring_index(substring_index(mg.config,'\"mcc\"\:\"',-1),'\"',1) end as mcc, group_concat(dp.serial_number) serial_numbers, count(dp.serial_number) as Number_of_Provisioned_Devices_Per_Merchant
from merchant m
join reseller r on m.reseller_id = r.id
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
join meta.merchant_plan mp on mp.id = m.merchant_plan_id
join merchant_plan_group mpg on mpg.id=mp.merchant_plan_group_id
LEFT JOIN meta.merchant_boarding mb ON mb.merchant_id = m.id
left join meta.device_provision dp on m.id = dp.merchant_id
where m.hierarchy like '%345547911882%' and mb.account_status = 16
ORDER BY created_time desc;

#lookup Device when not provisioned to Reseller: 
select d.id, d.serial_number, r.name as reseller_name, r.uuid, d.merchant_id, d.modified_time 
from device_provision d, reseller r 
where r.id = d.reseller_id and d.serial_number in ("C032UQ02270265",
"C032UQ02320146") 
order by r.uuid, d.serial_number;

#lookup serial on reseller: 
select d.serial_number, r.name as Device_Reseller_Name, m.name as Merchant_Name, m.uuid as Clover_ID, SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, rm.name as Merchant_Reseller 
from device_provision d 
join reseller r on r.id = d.reseller_id
join merchant m on m.id = d.merchant_id
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
join reseller rm on m.reseller_id = rm.id
where d.serial_number in ("C032UQ03020243")
order by r.uuid, d.serial_number;

#look up GH merchants for Online Ordering: 
select m.name as Merchant_Name, m.uuid as Clover_ID, SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, oop.name as Online_Order_Provider, oomp.status as OLO_Status
from online_order_provider oop
join online_order_merchant_provider oomp on oomp.provider_id = oop.id 
join merchant m on oomp.merchant_id = m.id 
join meta.merchant_placement mp on mp.merchant_id = m.id 
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
where oop.id = 5; 

#for Bundle Indicator Partner Control lookup by UUID below is for the RSA PC's:
select r.name as Reseller_Name, r.uuid as Reseller_UUID, m.name as Merchant_Name, m.uuid as Clover_ID, SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, mb.account_status, m.created_time, mpg.uuid as Plan_Group_UUID, mpg.name as Plan_Group, mp.uuid as Merchant_Plan_UUID, mp.name as Plan_Name, pc.name as PC_Name, pc.uuid as PC_Name
from partner_control pc 
join merchant_device_boarding mdb on mdb.bundle_indicator = pc.bundle_indicator
join merchant m on mdb.merchant_id = m.id
join meta.merchant_plan mp on mp.id = m.merchant_plan_id
join merchant_plan_group mpg on mpg.id=mp.merchant_plan_group_id
join reseller r on m.reseller_id = r.id
LEFT JOIN meta.merchant_boarding mb ON mb.merchant_id = m.id
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
#where pc.uuid = "AZ2G1MJVDQA24"and mp.uuid = "MN57CG0R4B0ZW" #RSA-P11
#where pc.uuid = "RADAX9A0M29E0" and mp.uuid = "JR97MP4KJERTA" #RSA-P10
#where pc.uuid = "XX6DW4HJ72XKA" AND mp.uuid = "JR97MP4KJERTA" #RSA-P09
where pc.uuid = "H1BZEEF823R4W" #AND mp.uuid = "GWG50V8KN76J0" #RSA-P12
group by m.uuid;

#lookup Audit events by merchant: 
select ae.* 
from merchant m 
join audit_events ae on m.id=ae.merchant_id
where m.uuid in ("Y58QD9562MYB1");

# Query for OLO Printing: 
select o.uuid, peq.* from orders o 
join print_event_queue peq ON peq.order_id = o.id 
where o.uuid = '7ZQM39PVENQQC';

#Customer activity info
select c.id, c.merchant_id, c.uuid as customer_uuid, c.first_name, c.last_name, c.created_time, c.deleted_time, 
cas.latest_marketing_activity_time, cas.latest_profile_activity_time, cas.latest_transaction_activity_time from customer c
join customer_activity_summary cas on cas.customer_id = c.id 
where c.uuid = "CGWAXD2CYTW6G";

#any print events
select * from print_event_queue where merchant_id = xxx;

#print event delay
select merchant_id, order_id, TIMESTAMPDIFF(second, created_time, deleted_time), created_time, deleted_time 
from print_event_queue  
where TIMESTAMPDIFF(second, created_time, deleted_time) > 600 
limit 50;

#print event delay by date
select DATE_FORMAT(created_time, "%Y-%m-%d") print_created, count(*) 
from print_event_queue 
where TIMESTAMPDIFF(second, created_time, deleted_time) > 600 
group by print_created order by print_created ;

#2FA search by phone number
select a.uuid as account_uuid, 
a.name, 
a.email,
a.locked_out as account_locked_out,
a.password_updated_time,
a.is_active as account_is_active,
a.last_login,
af.`type` as 2FA_type,
af.country_code,
af.phone_number,
af.created_time,
af.modified_time,
af.deleted_time
from meta.account a
join meta.account_auth_factor aaf on a.id = aaf.account_id
join meta.auth_factor af on aaf.auth_factor_id = af.id 
where replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(af.phone_number," ",""),"-",""),"/",""),".",""),"+",""),"(",""),")",""),"N",""),"#",""),";",""),"*","")
like "%6047715649%";


#lookup sim events by CID: 
select #dp.serial_number, s.uuid,s.iccid,.s.status,sdp.created_time,sdp.deleted_time,dp.serial_number,dp.merchant_id 
e.old_value, e.new_value, e.sim_iccid, e.timestamp 
FROM meta.device_provision dp 
inner JOIN meta.sim_device_provision sdp on dp.id = sdp.device_provision_id 
inner JOIN meta.sim s on sdp.sim_id = s.id 
inner join meta.merchant m ON m.id = dp.merchant_id
inner join meta.reseller r ON r.id = m.reseller_id
inner join meta.sim_event e ON s.iccid = e.sim_iccid
where m.uuid in ("MSA7F5K94RQ81"); 

#Get device uuid from main print_device to get serial number
select REPLACE(value,'-','') new_value 
from meta.setting 
where merchant_id = 32927 and deleted_time is null and name = 'DEFAULT_PRINTING_DEVICE';
select serial from meta.device where uuid = unhex('2c3576c3722d47d5beb194391077ef6d');

#lookup Online Ordering Print events
select d.serial, o.uuid, peq.category, peq.state, peq.print_time, peq.created_time, peq.modified_time, peq.deleted_time 
from orders o 
join meta.merchant m on m.id = o.merchant_id 
join print_event_queue peq ON peq.order_id = o.id 
join meta.device d on peq.device_id = d.id
where m.uuid = "B4S8P0A4D1JYW" AND peq.created_time between "2021-11-01 00:00" and "2021-11-08 23:59";

#add to any Payment Query to pull data: 
SUBSTRING_INDEX(SUBSTRING_INDEX(mg.config,'\"debit_key_code\"\:\"',-1),'\"',1) as debit_key_code,
  SUBSTRING(gt.ksn_prefix, 5, 4) as us_trans_keycode,
  #CASE WHEN pe.value LIKE '%reversalMacKsn%' THEN SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(pe.value,'\"reversalMacKsn\"\:\"',-1),'\"',1),5,4) ELSE NULL END AS canada_trans_keycode,

#IPG debit Keycode based lookup
select * from(
select request_key_code, 
COALESCE(NULLIF(response_key_code, ''), other_response_key_code) as ipg_response_code,  
server_start, 
server_end, 
device_serial 
from(select SUBSTRING_INDEX(SUBSTRING_INDEX(dr.request_body,'<ns2:debitKeyCode>',-1),'<',1) as request_key_code, 
SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(dr.response_body,'<ns2:iksn>FFFF',-1),'<',1),1,4) as response_key_code, 
SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(dr.response_body,'<ns3:iksn>FFFF',-1),'<',1),1,4) as other_response_key_code, 
dr.error_body as error, dr.server_start_time as server_start, dr.server_end_time as server_end, d.serial as device_serial
from device_request dr 
join device d on d.id = dr.device_id
join merchant_boarding mb on mb.merchant_id = dr.merchant_id 
where dr.merchant_id = 3177864 and dr.url = '/v2/internal/lc/rki'  and dr.server_start_time = (select max(dr2.server_start_time)
                        from device_request dr2
                        where dr2.device_id = dr.device_id))x)xy
where request_key_code is not NULL and request_key_code <> '' and request_key_code != ipg_response_code  ;

#Pull Hierarchy by MID: 
select SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, 
m.uuid as Clover_ID, 
m.merchant_gateway_id,
m.name, 
SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(m.hierarchy,'Business',-1), '\"', 3), '\"', -1) as Business_MID,  
SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(m.hierarchy,'Bank',-1), '\"', 3), '\"', -1) as Bank_MID,
SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(m.hierarchy,'Agent',-1), '\"', 3), '\"', -1) as Agent_MID,
SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(m.hierarchy,'Chain',-1), '\"', 3), '\"', -1) as Chain_MID,
SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(m.hierarchy,'Corp',-1), '\"', 3), '\"', -1) as Corp_MID,
m.bank_marker, 
r.name as reseller_name, 
r.id as reseller_id,
m.created_time,
SUBSTRING_INDEX(group_concat( dp.serial_number ),',',30) serial_number
from merchant m 
join merchant_gateway mg on m.merchant_gateway_id = mg.id
join reseller r on m.reseller_id = r.id
join device_provision dp on m.id = dp.merchant_id
where SUBSTRING_INDEX(mg.partner_uuid,':',1) = 526255525887;

#lookup plan uuid to find what Plan Group it is on: 
select mpg.uuid as Plan_Group_UUID, mpg.name as Plan_Group, mp.uuid as Merchant_Plan_UUID, mp.name as Plan_Name
from meta.merchant_plan mp
join merchant_plan_group mpg on mpg.id=mp.merchant_plan_group_id
#where mpg.uuid = "37SCFNPH9R3VC";
where mp.uuid = "3VRBT42WJ03SJ";

#check merchant and group based on app package: 
select m.id as merchantid, m.uuid as CID, d.serial, da.app_package_name, da.app_version_code, from_unixtime(floor(da.app_update_time/1000)) as app_updated_time, mg.name
from device d 
join device_app da on da.device_id = d.id 
join merchant_device md on md.device_id  = da.device_id 
join merchant m on m.id = md.merchant_id 
join merchant_groups mgs on mgs.merchant_id = m.id
join merchant_group mg on mg.id = mgs.merchant_group_id 
where m.uuid in ('70M1BAHT1RT1P', 'N5K6QRH9Q9D81','BZKWSN2X3KRT1','1QV2Q8FXN99J1','REKP4VXRC0311','1TS2536YHARM1','BZKWSN2X3KRT1') and da.app_package_name = 'com.clover.engine' and d.serial like 'C05%' and mg.name like '%jan 14 2022%'
group by d.serial;

#Find Sim Usage by reseller 
select r.name as Reseller_Name, r.uuid as Reseller_UUID, m.name as Merchant_Name, m.uuid as Clover_ID, SUBSTRING_INDEX(mg.partner_uuid,':',1) as MID, m.created_time as Merchant_Created_Time, dp.serial_number, s.iccid, s.status, max(su.date) as last_usage_date
from merchant m
join reseller r on m.reseller_id = r.id
join meta.merchant_placement merp on merp.merchant_id = m.id
join meta.merchant_gateway mg ON mg.id = m.merchant_gateway_id
join meta.merchant_plan mp on mp.id = m.merchant_plan_id
join meta.merchant_plan_group mpg on mpg.id=mp.merchant_plan_group_id
LEFT JOIN meta.merchant_boarding mb ON mb.merchant_id = m.id
left join meta.device_provision dp on m.id = dp.merchant_id
left join meta.sim_device_provision sdp on sdp.device_provision_id = dp.id
left join meta.sim s on s.id = sdp.sim_id 
left join meta.sim_usage su on s.iccid =su.sim_iccid
where r.uuid in ("WAB73808Z9WG8")
group by dp.serial_number
ORDER BY m.created_time desc;
