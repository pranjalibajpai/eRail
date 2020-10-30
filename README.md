# railway-reservation-system

## Demo

![demo](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/demo2.gif)

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

## Schema

- ### admins - username, password
- ### users - username, full_name, email, address, password
- ### trains - train_number, train_date, num_ac_coach, num_sleeper_coach

## Stored Procedures

- check_email_registered(email varchar(50))
- check_username_registered(username varchar(10))
- check_admin_credentials(n varchar(10), p varchar(50))
- check user_credentials(n varchar(10), p varchar(50))


## Triggers
- ### admins
    - 
- ### users
    - 
- ### trains
    - before_train_release [BEFORE INSERT TRIGGER]
        1. Checks if train is released atleast one month before and journey date and also atmost 4 months in advance.
        2. Checks whether same train is already released on the same date or not.
        3. Checks if number of coaches is not zero(atleast one coach is present - AC/Sleeper).
 
 
## How to run locally 
- Install [XAMPP](https://www.apachefriends.org/index.html) on your system
- Clone the repository in ```C:/Program Files/XAMPP/htdocs``` or Download the zip file & Copy in the ```htdocs``` folder
- Open XAMPP Control Panel & Click Start under Actions in Apache & MySQL
- Click on ```Admin``` in MySQL in XAMPP Control Panel
- Create a new database ```railwayDB```  and then click Import 
- Select ```sql/railwayDB.sql``` & database will be loaded
- Open ```http://localhost/railway-reservation-system``` on your browser
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
├── template
│   ├── footer.php
│   ├── header-name.php
│   ├── header.php
│   ├── pagination.php
│  
├── index.php
├── admin-login.php
├── admin-page.php
├── release-train.php
├── view-users.php
├── view-available-trains.php
├── view-bookings.php
├── register.php
├── user.php
├── book-ticket.php
├── view-user-booking.php
├── logout.php
├── README.md
│  
├── sql
│   ├── railwaydb.sql
│   ├── triggers.sql
│   ├── stored_procedures.sql
|── preview


```
