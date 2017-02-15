--lab3 

--distinct data find
select distinct(product_id) from order_request_list;

--using order by
select product_name,price from product_info order by price;

--calculating field
select (price-price*.05) as price_with_discount from product_info;

--applying condition
select product_name from product_info where price<50000;

--find product using string or pattern matching
select product_name,price from product_info where product_name like '%samsung tab';

--and or etc comparision
select product_name from product_info where price>20000 AND price<40000;

--between
select product_name from product_info where price BETWEEN 20000 AND 40000;

select product_name,product_id from product_info where price NOT BETWEEN 20000 AND 40000;

--in operation or set membership
select product_name,price from product_info where product_name in ('samsung tab','sony ericson');

--lab4 aggregate function


--max 
select price from product_info;
select max(price) from product_info;

--count(*),sum,avg
select count(*),sum(price),avg(price) from product_info;

--group by
select price,count(price) from product_info group by price;

--having
select price,count(price) from product_info group by price having price>30000;

--lab-5 subquery and set operations starts


select user_id,user_name from user_info
where user_name IN (select user_name from user_info where address='khulna');

select s.user_name,s.email,s.address from user_info s where s.user_id in(select o.user_id from order_request_list o where o.product_id=002);

select s.user_name from user_info s where address='kuet'
union
select s.user_name from user_info s where s.user_id in(select o.user_id from order_request_list o where o.product_id=004);

select s.user_name from user_info s where address='kuet'
intersect
select s.user_name from user_info s where s.user_id in(select o.user_id from order_request_list o where o.product_id=001);

select s.user_name from user_info s where s.user_id in(select o.user_id from order_request_list o where o.product_id=004)
minus
select s.user_name from user_info s where address='kuet';

--lab6 join operation


-- using clause
select p.product_name,p.price,o.order_id from product_info p join order_request_list o using (product_id); 

--normal join operation
select c.user_name , d.product_id from order_request_list d join user_info c on d.user_id=c.user_id;

--natural join
select c.user_name,c.email,d.product_id,d.order_date from order_request_list d natural join user_info c;

--outer joins

select c.user_name , d.product_id from order_request_list d left outer join user_info c on d.user_id=c.user_id;

select c.user_name , d.product_id from order_request_list d right outer join user_info c on d.user_id=c.user_id;

select c.user_name , d.product_id from order_request_list d full outer join user_info c on d.user_id=c.user_id;




--lab7 pl/sql


--no of user

SET SERVEROUTPUT ON
DECLARE
   count_user_id  user_info.user_id%type;
BEGIN
   SELECT count(user_id)  INTO count_user_id  
   FROM user_info;
   DBMS_OUTPUT.PUT_LINE('The number of  user id is : ' || count_user_id);
 END;
/


--no of product in stock

SET SERVEROUTPUT ON
DECLARE
   count_product  product_info.stock%type;
BEGIN
   SELECT sum(stock)  INTO count_product 
   FROM product_info;
   DBMS_OUTPUT.PUT_LINE('The number of  product in stock is : ' || count_product);
 END;
/


--maximum quantity sold at a time

SET SERVEROUTPUT ON
DECLARE
   max_quantity order_request_list.quantity%type;
BEGIN
   SELECT MAX(quantity)  INTO max_quantity 
   FROM order_request_list;
   DBMS_OUTPUT.PUT_LINE('The maximum number of products sold at a time is : ' || max_quantity);
 END;
/

--maximum quantity is requested not available in stock 

SET SERVEROUTPUT ON
DECLARE
   max_quantity order_request_list.req_amount%type;
BEGIN
   SELECT MAX(req_amount)  INTO max_quantity 
   FROM order_request_list;
   DBMS_OUTPUT.PUT_LINE('The maximum number of products requested is : ' || max_quantity);
 END;
/

--product order date 

SET  SERVEROUTPUT ON
DECLARE
  Date_ordered order_request_list.order_date%type;
  ProductName  product_info.product_name%type := 'samsung tab';
BEGIN
  SELECT order_date INTO Date_ordered
  FROM order_request_list, product_info
  WHERE product_info.product_id = order_request_list.product_id AND
  product_name = ProductName;  
  DBMS_OUTPUT.PUT_LINE('Product Name : ' || ProductName || ' ordered on '|| Date_ordered);
END;
/

--conditional discount

SET SERVEROUTPUT ON
DECLARE
    full_price      product_info.price%type;
    ProductName  VARCHAR2(100);
    discount_price product_info.price%type;
	
BEGIN
    ProductName := 'hp laptop';

    SELECT price  INTO full_price
    FROM product_info
    WHERE product_name like ProductName ;

    IF full_price < 25000  THEN
                discount_price := full_price;
    ELSIF full_price >= 250000 and full_price <40000   THEN
               discount_price :=  full_price - (full_price*0.25);
    ELSIF full_price >= 40000 and full_price <=50000 THEN
       discount_price :=  full_price - (full_price*0.4);
   ELSE
	discount_price :=  full_price - (full_price*0.5); 
    END IF;

DBMS_OUTPUT.PUT_LINE (ProductName || 'Full Price: '||full_price||' Disounted Pice: '|| ROUND(discount_price,2));
EXCEPTION
         WHEN others THEN
	      DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;
/


--lab8 

--while loop

set serveroutput on

declare 

counter number(7):=1207006;
Name user_info.user_name%type;
Email user_info.email%type;

begin

while counter<=1207010

loop 
	
	select user_name , email into Name, Email from user_info where user_id=counter;

	dbms_output.put_line('Record '||counter);
	dbms_output.put_line(Name ||' ' ||Email);
	dbms_output.put_line('-----------------------');

	counter :=counter+1;

	end loop;

	exception
	when others then dbms_output.put_line(sqlerrm);
end;
/

--for 

set serveroutput on

declare 
counter number(3);
ProductName product_info.product_name%type;
Price product_info.price%type;

begin

	for counter in 001..005
	loop
	select product_name,price into ProductName,Price from product_info where product_id in (select product_id from product_info where product_id=counter);
	dbms_output.put_line('Record : '||counter);
	dbms_output.put_line(ProductName||' '||Price);
	dbms_output.put_line('----------------------');
	end loop;
exception
when others then 
dbms_output.put_line(sqlerrm);
end;
/

--loop

set serveroutput on

declare
counter number(7):=1207005;
Name user_info.user_name%type;
Address user_info.address%type;
begin

loop
	
	counter:=counter+1;
	select user_name,address into Name,Address from user_info where user_id=counter;
	dbms_output.put_line(Name||' '||Address);
	exit when counter>1207010;

	end loop;
exception
when others then dbms_output.put_line(sqlerrm);
end;
/

--cursor

SET SERVEROUTPUT ON
DECLARE
     CURSOR product_cur IS
  SELECT product_name,price FROM product_info;
  product_record product_cur%ROWTYPE;

BEGIN
OPEN product_cur;
      LOOP
        FETCH product_cur INTO product_record;
        EXIT WHEN product_cur%ROWCOUNT > 4;
      DBMS_OUTPUT.PUT_LINE ('Product Name : ' || product_record.product_name || ' Price : ' || product_record.price);
      END LOOP;
      CLOSE product_cur;   
END;
/

--create procedure to update particular id

CREATE OR REPLACE PROCEDURE UPD_PRODUCTS (
productid product_info.product_id%TYPE,
product_price product_info.price%TYPE) IS
BEGIN
UPDATE product_info SET price = product_price WHERE product_id = productid;

IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20202, 'No product updated.');
      END IF;
COMMIT;
END UPD_PRODUCTS;
/
SHOW ERRORS

SET SERVEROUTPUT ON
BEGIN
    UPD_PRODUCTS (004,50000);    
END;
/


select price from product_info where product_id=004;


--create function and find amount user order to buy

CREATE OR REPLACE FUNCTION GET_ID (userid order_request_list.user_id%TYPE) RETURN number  IS
amount order_request_list.quantity%TYPE;

BEGIN
SELECT quantity INTO amount FROM order_request_list WHERE user_id = userid;
RETURN amount;
END;
/

SET SERVEROUTPUT ON
DECLARE
product_quantity number;
BEGIN
   product_quantity := GET_ID (1207009);
   dbms_output.put_line('Users ordered quantity : ' || product_quantity);
END;
/

create or replace function avg_price return number is
avg_price product_info.price%type;

begin
select avg(price) into avg_price from product_info;
return avg_price;
end;
/

set serveroutput on
begin
dbms_output.put_line('average price: '||avg_price);
end;
/

--lab9

--date

select sysdate from dual;

select current_date from dual;

select systimestamp from dual;

SELECT ADD_MONTHS (order_date,12) AS Warrenty
FROM order_request_list;

commit;














