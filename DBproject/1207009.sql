drop table order_request_list;
drop table user_info;
drop table product_info;


create table user_info(
	user_id number,
	user_name varchar(20),
	email varchar(20) not null,
        password varchar(15) not null,
	phone_no number(15) not null,
	address varchar(30) not null,
        primary key(user_id)
);

create table product_info(
	product_id number,
	product_name varchar(20) not null,
	price number not null,
        stock number,
        details varchar(100),
	primary key(product_id)
);

create table order_request_list(
	order_id number,
        user_id number,
	product_id number,	
	order_date date,
        quantity number not null,
        req_product varchar(20),
        req_amount number check(req_amount>0),
	primary key(order_id),
	foreign key(user_id) references user_info(user_id),
        foreign key(product_id) references product_info(product_id)
);

--lab2 alter command

ALTER TABLE user_info 
	ADD occupation	VARCHAR(10);
ALTER TABLE product_info 
	ADD  product_status varchar(20) default null;
alter table order_request_list
        modify order_date date default sysdate;
alter table order_request_list
	rename column req_product to req_product_name;

describe user_info;
describe product_info;
describe order_request_list;

--lab9 trigger
--check the product to buy is available in stock

create or replace trigger product_update before insert or update on order_request_list
for each row
declare
    product_id number;
    P1 number :=0;
begin
    select stock into P1 from product_info where product_id = :new.product_id;
    P1:=P1-:new.quantity;
    update product_info set stock = P1 where product_id =:new.product_id;
    if(P1<0) then
    raise_application_error(-20000,'Product are not available');
end if;
end;
/

create or replace trigger check_price before insert or update on product_info
for each row
declare
	c_min constant number(8,2):= 20000.0;
	c_max constant number(8,2):= 200000.0;
begin
	if:new.price>c_max or :new.price<c_min then
	raise_application_error(-20000,'New product is too expensive or cheap');
end if;
end;
/

CREATE TRIGGER TR_PRODUCT_STATUS
BEFORE UPDATE OR INSERT ON product_info 
FOR EACH ROW 
BEGIN
IF :new.stock=0 THEN
:NEW.product_status:='Unavailable';
ELSIF :new.stock>0 THEN
:NEW.product_status:='Avaiable';
END IF; 
END TR_PRODUCT_STATUS;
/

insert into user_info (user_id,user_name,email,password,phone_no,address,occupation) values(1207006,'karima','Kareema@yahoo.com','12345',0183958844,'khulna','student');

insert into user_info (user_id,user_name,email,password,phone_no,address,occupation) 
values(1207007,'sharmi','sharmiabc@yahoo.com','23456',01688358851,'khulna','student');

insert into user_info (user_id,user_name,email,password,phone_no,address,occupation) 
values(1207008,'muna','tanjim@yahoo.com','34567',01670313775,'kuet','student');

insert into user_info (user_id,user_name,email,password,phone_no,address,occupation)
values(1207009,'soma','Shahnaz@yahoo.com','45678',01689060063,'kuet','student');

insert into user_info (user_id,user_name,email,password,phone_no,address,occupation) 
values(1207010,'mousumi','mousumi@yahoo.com','56789',01521456320,'kuet','student'); 



insert into product_info (product_id,product_name,price,stock,details,product_status) values(001,'samsung tab',32000,10,'it has fm radio and video player','null');

insert into product_info (product_id,product_name,price,stock,details,product_status) values(002,'sony ericson',30000,20,'it has a voice recorder','null');

insert into product_info (product_id,product_name,price,stock,details,product_status) values(003,'nokia lumia',21000,25,'it has internet facilities','null');

insert into product_info (product_id,product_name,price,stock,details,product_status) values(004,'hp laptop',60000,15,'it has a 5 gb ram and core i5','null');

insert into product_info (product_id,product_name,price,stock,details,product_status) values(005,'dslr camera',60000,0,'it has high resolution camera','null');
 


insert into order_request_list (order_id,user_id,product_id,quantity,req_product_name, req_amount) values (11,1207006,004,5,'abc',1);

insert into order_request_list (order_id,user_id,product_id,quantity,req_product_name, req_amount) values(12,1207006,002,2,'def',2);

insert into order_request_list (order_id,user_id,product_id,quantity,req_product_name, req_amount) values(13,1207008,003,3,'efghjds',3);

insert into order_request_list (order_id,user_id,product_id,quantity,req_product_name, req_amount) values(14,1207008,002,3,'dfvsn',4);

insert into order_request_list (order_id,user_id,product_id,quantity,req_product_name, req_amount) values(15,1207009,001,3,'hij',5);

select * from user_info;
select * from product_info;
select * from order_request_list;

commit;