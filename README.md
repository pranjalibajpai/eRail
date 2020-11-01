# railway-reservation-system

## Demo

![demo](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/demo2.gif)

![demo2](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/demo3.gif)

## Things Done & Assumptions Made
- Admins are added in the table - admins manually
- If user/admin logs out & then access the page through URL then Access is Denied

## Validations
- Login (Admin & User)
    - USername - Not Empty & Valid
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

## ToDo
- [x] Change type="text" to type="password" in admin-login.php, index.php, register.php to Hide Password
- [ ] Add condition to all queries if query is not executed / throws an error
- [ ] Hash algo is needed to store password in database
- [x] After login if admin/users click login page it should redirect to index.php/admin-page.php 
- [ ] Add number of available seats in view trains 
- [ ] Make stored procedures for validation(not empty)

## Schema

- ### admins - username, password
- ### users - username, full_name, email, address, password
- ### trains - train_number, train_date, num_ac_coach, num_sleeper_coach

## Stored Procedures

- check_email_registered(email varchar(50))
- check_username_registered(username varchar(10))
- check_admin_credentials(n varchar(10), p varchar(50))
- check user_credentials(n varchar(10), p varchar(50))
- check_valid_train(num INT(11), date Date)
    - Checks date selected by the user is not in the past
    - Checks Train Number & date has been released by admin


## Triggers
- ### trains
    - before_train_release [BEFORE INSERT TRIGGER]
        1. Checks if train is released atleast one month before and journey date and also atmost 4 months in advance.
        2. Checks whether same train is already released on the same date or not.
        3. Checks if number of coaches is not zero(atleast one coach is present - AC/Sleeper).
 
 
## How to run locally 
- Install [XAMPP](https://www.apachefriends.org/index.html) on your system
- Clone the repository in ```C:/Program Files/XAMPP/htdocs``` or Download the zip file & Copy in the ```htdocs``` folder
- Start Apache & Mysql Servers from XAMPP Control Panel 
- Visit http://localhost/phpmyadmin on your browser
- Create a new database ```railwayDB```  and then click Import 
- Select ```sql/railwayDB.sql``` & database will be loaded
- Open http://localhost/railway-reservation-system on your browser
- Now you are all set to start!

## Directory Structure

```
railway-reservation-system
├── config
│   ├── connection.php
|
├── css
│   ├── style.css
|
├── sql
│   ├── railwaydb.sql
│   ├── triggers.sql
│   ├── stored_procedures.sql
|
├── template
│   ├── footer.php
│   ├── header-name.php
│   ├── header.php
│   ├── pagination.php
│  
├── admin-login.php
├── admin-page.php
├── book-ticket.php
├── get-ticket.php
├── index.php
├── logout.php
├── not-available.php
├── passenger-details.php
├── register.php
├── release-train.php
├── user.php
├── view-bookings.php
├── view-released-trains.php
├── view-user-bookings.php
├── view-users.php
|
├── README.md
├── Project Specification.pdf
│  
|── images
|── preview

```
