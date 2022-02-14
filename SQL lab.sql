create database E_commerce;

 use E_commerce;
 
 create table `Supplier`
 (`Supp_ID` int primary key auto_increment,
  `Supp_Name` varchar(30),
  `Supp_City` varchar(40),
  `Supp_phone` varchar(10)
 );
 
 CREATE TABLE IF NOT EXISTS `CUSTOMER` (
  `CUS_ID` INT NOT NULL,
  `CUS_NAME` VARCHAR(20) NULL DEFAULT NULL,
  `CUS_PHONE` VARCHAR(10),
  `CUS_CITY` varchar(30) ,
  `CUS_GENDER` CHAR,
  PRIMARY KEY (`CUS_ID`));

CREATE TABLE IF NOT EXISTS `CATEGORY` (
  `CAT_ID` INT NOT NULL,
  `CAT_NAME` VARCHAR(20) NULL DEFAULT NULL,
   PRIMARY KEY (`CAT_ID`)
  );
  
  CREATE TABLE IF NOT EXISTS `PRODUCT` (
  `PRO_ID` INT NOT NULL,
  `PRO_NAME` VARCHAR(20) NULL DEFAULT NULL,
  `PRO_DESC` VARCHAR(60) NULL DEFAULT NULL,
  `CAT_ID` INT NOT NULL,
  PRIMARY KEY (`PRO_ID`),
  FOREIGN KEY (`CAT_ID`) REFERENCES CATEGORY (`CAT_ID`)
  );

CREATE TABLE IF NOT EXISTS `PRODUCT_DETAILS` (
  `PROD_ID` INT NOT NULL,
  `PRO_ID` INT NOT NULL,
  `SUPP_ID` INT NOT NULL,
  `PROD_PRICE` INT NOT NULL,
  PRIMARY KEY (`PROD_ID`),
  FOREIGN KEY (`PRO_ID`) REFERENCES PRODUCT (`PRO_ID`),
  FOREIGN KEY (`SUPP_ID`) REFERENCES SUPPLIER(`SUPP_ID`)
  );

CREATE TABLE IF NOT EXISTS `ORDER` (
  `ORD_ID` INT NOT NULL,
  `ORD_AMOUNT` INT NOT NULL,
  `ORD_DATE` DATE,
  `CUS_ID` INT NOT NULL,
  `PROD_ID` INT NOT NULL,
  PRIMARY KEY (`ORD_ID`),
  FOREIGN KEY (`CUS_ID`) REFERENCES CUSTOMER(`CUS_ID`),
  FOREIGN KEY (`PROD_ID`) REFERENCES PRODUCT_DETAILS(`PROD_ID`)
  );
  
  CREATE TABLE IF NOT EXISTS `RATING` (
  `RAT_ID` INT NOT NULL,
  `CUS_ID` INT NOT NULL,
  `SUPP_ID` INT NOT NULL,
  `RAT_RATSTARS` INT NOT NULL,
  PRIMARY KEY (`RAT_ID`),
  FOREIGN KEY (`SUPP_ID`) REFERENCES SUPPLIER (`SUPP_ID`),
  FOREIGN KEY (`CUS_ID`) REFERENCES CUSTOMER(`CUS_ID`)
  );
  
INSERT into `supplier` values(1,"Rajesh Retails","Delhi",'1234567890');
INSERT into `supplier` values(2,"Appario Ltd.","Mumbai",'2589631470');
INSERT into `supplier` values(3,"Knome products","Banglore",'9785462315');
INSERT into `supplier` values(4,"Bansal Retails","Kochi",'8975463285');
INSERT into `supplier` values(5,"Mittal Ltd.","Lucknow",'7898456532');

INSERT INTO `CUSTOMER` VALUES(1,"AAKASH",'9999999999',"DELHI",'M');
INSERT INTO `CUSTOMER` VALUES(2,"AMAN",'9785463215',"NOIDA",'M');
INSERT INTO `CUSTOMER` VALUES(3,"NEHA",'9999999999',"MUMBAI",'F');
INSERT INTO `CUSTOMER` VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F');
INSERT INTO `CUSTOMER` VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M');

INSERT INTO `CATEGORY` VALUES( 1,"BOOKS");
INSERT INTO `CATEGORY` VALUES(2,"GAMES");
INSERT INTO `CATEGORY` VALUES(3,"GROCERIES");
INSERT INTO `CATEGORY` VALUES (4,"ELECTRONICS");
INSERT INTO `CATEGORY` VALUES(5,"CLOTHES");

INSERT INTO `PRODUCT` VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
INSERT INTO `PRODUCT` VALUES(2,"TSHIRT","DFDFJDFJDKFD",5);
INSERT INTO `PRODUCT` VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4);
INSERT INTO `PRODUCT` VALUES(4,"OATS","REURENTBTOTH",3);
INSERT INTO `PRODUCT` VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1);

INSERT INTO `PRODUCT_DETAILS` VALUES(1,1,2,1500);
INSERT INTO `PRODUCT_DETAILS` VALUES(2,3,5,30000);
INSERT INTO `PRODUCT_DETAILS` VALUES(3,5,1,3000);
INSERT INTO `PRODUCT_DETAILS` VALUES(4,2,3,2500);
INSERT INTO `PRODUCT_DETAILS` VALUES(5,4,1,1000);

INSERT INTO `ORDER` VALUES (50,2000,"2021-10-06",2,1);
INSERT INTO `ORDER` VALUES(20,1500,"2021-10-12",3,5);
INSERT INTO `ORDER` VALUES(25,30500,"2021-09-16",5,2);
INSERT INTO `ORDER` VALUES(26,2000,"2021-10-05",1,1);
INSERT INTO `ORDER` VALUES(30,3500,"2021-08-16",4,3);

INSERT INTO `RATING` VALUES(1,2,2,4);
INSERT INTO `RATING` VALUES(2,3,4,3);
INSERT INTO `RATING` VALUES(3,5,1,5);
INSERT INTO `RATING` VALUES(4,1,3,2);
INSERT INTO `RATING` VALUES(5,4,5,4);

#query 3

Select customer.cus_gender,count(customer.cus_gender) as count from customer 
inner join `order` on customer.cus_id = `order`.cus_id
where `order`.ord_amount >= 3000 group by
customer.cus_gender; 

#query 4

select `order`.*,product.pro_name from `order`,product_details,product where `order`.cus_id = 2 and
`order`.prod_id = product_details.prod_id and product_details.prod_id = product.pro_id;

#query 5

select supplier.* from supplier,product_details where supplier.supp_id in
(select product_details.supp_id from product_details group by product_details.supp_id having 
count(product_details.supp_id) > 1) group by supplier.supp_id;

#query 6

select category.* from `order` inner join product_details on
`order`.prod_id = product_details.prod_id inner join product on 
product.pro_id = product_details.pro_id inner join category on
category.cat_id = product.cat_id
having min(`order`.ord_amount);

#query 7

select product.pro_id,product.pro_name from `order` inner join product_details on
product_details.prod_id = `order`.prod_id inner join product on 
product.pro_id = product_details.pro_id where `order`.ord_date > "2021-10-05";

#query 8

select customer.cus_name,customer.cus_gender from customer where customer.cus_name like 'A%' or customer.cus_name like '%A';

#query 9

select supplier.supp_id,supplier.supp_name,rating.rat_ratstars,
case
 when rating.rat_ratstars > 4 then 'genuine supplier'
 when rating.rat_ratstars > 2 then 'average supplier'
 else 'supplier should not be considered'
end 
as verdict from rating inner join supplier on supplier.supp_id = rating.supp_id;

delimiter $$ 
create procedure proc1()
begin 
select supplier.supp_id,supplier.supp_name,rating.rat_ratstars,
case
 when rating.rat_ratstars > 4 then 'genuine supplier'
 when rating.rat_ratstars > 2 then 'average supplier'
 else 'supplier should not be considered'
end 
as verdict from rating inner join supplier on supplier.supp_id = rating.supp_id;
end $$

call proc1;









  


 
