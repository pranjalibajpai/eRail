#  🚉 eRail - An online railway reservation system🎫 

## ToDo
- [ ] Finalize schema & update ERD & corresponding changes in code
- [ ] Add triggers wherever necessary

## Schema
Tables | Attributes
------------ | -------------
admin | username(PK), password
user | username(PK), name, email, address, password
train | t_number(PK), t_date(PK), num_ac, num_sleeper, seats_b_ac, seats_b_sleeper, released_by(FK - admin)
ticket | pnr_no(PK), coach, booked_by(FK - user), booked_at, t_number(FK - train), t_date(FK - train) 
passenger | name, age, gender, pnr_no(PK, FK - ticket), berth_no(PK), berth_type, coach_no(PK)

## Stored Procedures

- **check_email_registered**(email varchar(50))
- **check_username_registered**(username varchar(10))
- **check_admin_credentials**(n varchar(10), p varchar(50))
- **check user_credentials**(n varchar(10), p varchar(50))
- **check_valid_train**(num INT(11), date Date)
    - Checks date selected by the user is not in the past
    - Checks Train Number & date has been released by admin
- **check_seats_availabilty**(IN INT, IN DATE, IN VARCHAR(50), IN INT)
- **generate_pnr**(IN VARCHAR(50), OUT VARCHAR(12), IN VARCHAR(50), IN INT, IN DATE)
    - generates an unique PNR number
    - inserts into the ticket table
- **assign_berth**(IN INT, IN  DATE, IN VARCHAR(50), IN VARCHAR(50), IN  INT, IN VARCHAR(50), IN  VARCHAR(12))
- **check_valid_pnr**(IN  VARCHAR(12)

## Triggers
- ### trains
    - **before_train_release** [BEFORE INSERT TRIGGER]
        1. Checks if train is released atleast one month before and journey date and also atmost 4 months in advance.
        2. Checks whether same train is already released on the same date or not.
        3. Checks if number of coaches is not zero(atleast one coach is present - AC/Sleeper).
    - **check_booked_seats** [BEFORE UPDATE TRIGGER]
        1. Checks booked seats are not more than available seats in both AC & Sleeper Coach
 
## Preview
- Check PNR
    - If invalid
     ![check-pnr](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/view-pnr-1.png)
    - If Valid
    ![check-pnr](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/view-pnr-2.png)

- # Admin Page
    - View All Bookings
    ![view-booking](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/admin-view-booking.png)

- # User Page
    - View User Bookings
    ![view-booking](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/user-view-booking.png)
- ### View Trains
    ![view-train](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/view-trains.png)
- ### About
    ![about](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/about.png)
- ### Contact
    ![contact](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/contact.png)
    
## ER Diagram


## Final Demo
![demo](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/demo.gif)

![demo](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/demo2.gif)

![demo2](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/demo3.gif)

## How to run locally 
- Install [XAMPP](https://www.apachefriends.org/index.html) on your system
- Clone the repository in ```C:/Program Files/XAMPP/htdocs``` 
- ``` git clone https://github.com/pranjalibajpai/railway-reservation-system.git```
- ``` cd railway-reservation-system ```
- Start Apache & Mysql Servers from XAMPP Control Panel 
- Visit http://localhost/phpmyadmin on your browser
- Create a new database ```rDB```  and then click Import 
- Select ```sql/rdb.sql``` & database will be loaded
- Open http://localhost/railway-reservation-system on your browser
- Now you are all set to start!

## Things Done & Assumptions Made
- Admins are added in the table - admins manually
- If user/admin logs out & then access the page through URL then Access is Denied

## Validations
- Login (Admin & User)
    - Username - Not Empty & Valid
    - Password - Not Empty & Valid
- Register
    - Password - minimun 8 characters
    - Username - Contain letters only, Shouldn't Already Taken
    - Full Name, Address - Not Empty
    - Email - Valid, Not Empty, Shouldn't Already Registered
- Release Train
    - Train Number - Not Empty & Number
    - Date - Not Empty & Between CURRENT_DATE + 1 Month & CURRENT_DATE + 4 Month
    - Number of Coaches - Positive & Total should be >= 1


