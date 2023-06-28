BEGIN TRANSACTION

create table dim_customer (
customer_id varchar(50) primary key, 
customer_unique_id varchar(50),
customer_zip_code_prefix varchar(6),
customer_city varchar(30),
customer_state char(2)
);

create table dim_geolocation (
geolocation_code_prefix varchar(10),
geolocation_lat decimal(9,6),
geolocation_lng decimal(9,6),
geolocation_city varchar(30),
geolocation_state char(2) 
);

create table fact_selling (
order_id varchar(50) primary key,
customer_id varchar(50),
order_status varchar(10), 
order_purchase_timestamp timestamp,
order_approved_at timestamp,
order_delivered_carrier_date timestamp,
order_delivered_customer_date timestamp,
order_estimated_delivery_date timestamp,
constraint fk_customer foreign key (customer_id) references dim_customer(customer_id),
constraint fk_order foreign key (order_id) references dim_order(order_id),
constraint fk_reviews foreign key (review_id) references dim_review(review_id)
);

create table dim_order (
order_id varchar(50),
order_item_id int,
product_id varchar(50),
seller_id varchar(50),
shipping_limit_date timestamp,
price decimal(10,2),
freight_value decimal(4,2),
constraint fk_seller foreign key (seller_id) references dim_seller(seller_id)
);


create table dim_payments (
order_id varchar(50) primary key,
payment_sequential char(1),
payment_type varchar(25),
payment_installments char(1),
payment_value decimal(10,2)
);

create table dim_review (
review_id varchar(50) primary key,
order_id varchar(50),
review_score int,
review_comment_title varchar(60), 
review_comment_message varchar(180),
review_creation_date timestamp,
review_answer_timestamp timestamp
);


create table dim_product (
product_id varchar(50) primary key,
product_category_name varchar(40)
);

create table dim_seller (
seller_id varchar(50) primary key,
seller_zip_code_prefix varchar(6),
seller_city varchar(30),
seller_state char(2)
);