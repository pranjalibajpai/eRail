# railway-reservation-system

## Demo

![demo](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/demo1.gif)

## Things Done & Assumptions Made
- Admins are added in the table - admins manually

## Validations
- Password - minimun 8 characters
- Username - Must contain letters only
- Full Name, Address - must not be empty
- Email - should be valid and not empty
- For login (both admins & users) Username & Password should not be empty & must be valid
- If user/admin logouts then access the page through URL then Access is Denied

## ToDo
- [x] Change type="text" to type="password" in admin-login.php, index.php, register.php to Hide Password
- [ ] Add condition to all queries if query is not executed / throws an error
- [ ] Hash algo is needed to store password in database
- [x] After login if admin/users click login page it should redirect to index.php/admin-page.php 

## Schema

- ### admins - username, password
- ### users - username, full_name, email, address, password
- ### trains - train_number, train_date, num_ac_coach, num_sleeper_coach

## Stored Procedures

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
├── logout.php
├── README.md
│  
├── sql
│   ├── railwaydb.sql
│   ├── triggers.sql
|── preview


```
