create database contactbook;
use contactbook;
drop table customers;
create table customers (
    customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    phone_number varchar(10) not null,
    email varchar(100) not null,
    city varchar(50) not null
);


delimiter $$
-- 1------------------------------------------------------------------------------------------------------------------------------------
create procedure AddNewCustomers(
    in Cname varchar(100),
    in Cnumber varchar(10),
    in Cemail varchar(100),
    in Ccity varchar(50)
)
begin
    if Cname is null or Cname = ''
    or Cnumber is null or Cnumber = ''
    or Cemail is null or Cemail = ''
    or Ccity is null or Ccity = '' then
        select 'null or empty value is not allowed' as status;
    else
        insert into customers(customer_name, phone_number, email, city)
        values(Cname, Cnumber, Cemail, Ccity);

        select 'customer added successfully' as status;
    end if;
end $$
-- 2-----------------------------------------------------------------------------------------------------------------------------
create procedure SearchCustomer(in Cname varchar(100))
begin
	select * from customers where customer_name like concat('%', Cname, '%');
end $$

-- 3------------------------------------------------------------------------------------------------------------------------------

create procedure UpdatePhone(in Cid int, in Cphone varchar(10))
begin 
    if exists (
        select *
        from customers
        where customer_id = Cid
    ) then
        update customers
        set phone_number = Cphone
        where customer_id = Cid;
        select 'phone updated successfully' as status;
    else
        select 'customer not found' as status;
    end if;
end $$

-- 4------------------------------------------------------------------------------------------------------------------------------

create procedure DeleteContact(in Cid int)
begin
    if exists (
        select *
        from customers
        where customer_id = Cid
    ) then
        delete from customers
        where customer_id = Cid;
        select 'customer deleted successfully' as status;
    else
        select 'customer not found' as status;
    end if;
end $$
delimiter ;

-- calls ------------------------------------------------------------------------------------------------------------------------

drop procedure AddNewCustomers;
drop procedure SearchCustomer;
drop procedure UpdatePhone;
drop procedure DeleteContact;
call AddNewCustomers('gita Bahadur', '9810324863', 'ram@gmail.com', 'Kathmandu');
call SearchCustomer('ram');
call updatePhone (2, '9841245678');
call DeleteContact(2);

select * from customers;





    
