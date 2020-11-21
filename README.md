#  🚉 eRail - An online railway reservation system🎫 

## ToDo
- Triggers
    - Update
        - train_status: When seats booked = available seats then remove the corresponding tuple from it Now, while booking if a train is released but is booked fully it will not be in train_status table  & also seats booked not greater than avialble 
        - ticket: PNR cannot be updated
    - Insert
        - passenger: check same pnr, coach no & berth no shouldn't be in the table 
### Checks
- redirection through url

## Functionality
- ### General
    - Check Ticket
    - View All Released Trains ``update pending``
    - Check Train Status ``todo``
- ### Admin
    - Release New Train
    - View All Released Trains ``update pending``
    - Check Train Status ``todo``
    - View All Users
    - View All Bookings
- ### User
    - Book A Ticket
    - View Released Trains ``update pending``
    - Check Train Status ``todo``
    - View Previous Bookings

## Schema
Tables | Attributes
------------ | -------------
admin | username(PK), password
user | username(PK), name, email, address, password
train | t_number(PK), t_date(PK), num_ac, num_sleeper, released_by(FK - admin)
train_status | t_number(FK - train, PK), t_date(FK - train, PK), seats_b_ac, seats_b_sleeper
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
- **check_valid_pnr**(IN  VARCHAR(12))

## Triggers
- ### trains
    - **before_train_release** [BEFORE INSERT TRIGGER]
        1. Checks if train is released atleast one month before and journey date and also atmost 4 months in advance.
        2. Checks whether same train is already released on the same date or not.
        3. Checks if number of coaches is not zero(atleast one coach is present - AC/Sleeper).
    - **check_booked_seats** [BEFORE UPDATE TRIGGER]
        1. Checks booked seats are not more than available seats in both AC & Sleeper Coach

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

## Assumptions Made
- Admins are added in the table manually.
- There are 2 admins
    - username: admin, admin1
    - password: same as username
- Train can be released at least 1 month before and at most 4 months before the journey date
- Ticket can be booked atmost 2 months in advance

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
## Tech Stack 
- ### Frontend
    - HTML
    - CSS
    - Bootstrap
- ### Backend
    - PHP
- ### Database
    - MySQL
- ### Server
    - Apache

