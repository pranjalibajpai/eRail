#  🚉 eRail - An online railway reservation system🎫 

## Demo
![demo](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/preview/final-demo.gif)

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
- check_email_registered
    - Checks whether an email has been already registered or not when a new user registers on the portal
- check_username_registered
    - Checks whether a username has been already taken or not when a new user registers on the portal
- check_admin_credentials
    - Checks for admin username & password during login
- check user_credentials
    - Checks for user’s username & password during login
- check_train_details
    - Checks whether the date selected by the user while booking is valid, i.e.
        - The date is not in the past
        - The date is at most 2 months from the current date 
    - Checks whether the selected train has been released in the system by the admin or not
- check_seats_availabilty
    - Checks whether sufficient seats are available in the coach (AC/Sleeper) selected by the user
- generate_pnr
    - Generates a unique PNR number
    - Inserts into the ticket table
- assign_berth
    - Assigns berth_no, coach_no and finds the corresponding berth_type
    - Insert into passenger table
- check_valid_pnr
    - Checks whether the PNR Number given as input by the user for viewing ticket(Details in Other Functionality heading) is valid or not
## Triggers
- before_train_release
    - Operation - BEFORE INSERT
    - Table - train  
    - Checks if the train is released at least one month before the journey date and also at most 4 months in advance
    - Checks whether the same train is already released for the same date in the system
    - Checks if the number of coaches is not zero, i.e., at least one coach must be  present (AC/Sleeper)
- check_ticket_update
    - Operation - BEFORE UPDATE
    - 	Table - ticket
    -  Prevents update of ticket details (pnr_no & coach)
- check_booked_seats
    - Operation - BEFORE UPDATE
    - 	Table - train_status
    - Checks booked seats are not more than available seats in both AC & Sleeper Coach
- before_berth_assign
    - Operation - BEFORE INSERT
    - Table - passenger
    - Checks, whether the berth number & coach number assigned, is already assigned to some other passenger for the same train number and date of journey and coach(AC/Sleeper) or not

## Ticket Booking Procedure
- Step 1
![step1](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/flowchart/Ticket%20Booking-1.png)
- Step 2
![step2](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/flowchart/Ticket-Booking-2.png)

## Train Release Procedure
![release](https://github.com/pranjalibajpai/railway-reservation-system/blob/master/flowchart/Release-Train.png)


## Assumptions Made
- Admins are added to the table manually.
    - There are 2 admins in the system - admin, admin1(password is same as username)
- Trains can be released at least 1 month before and at most 4 months before the journey date.
- Users can book tickets at most 2 months in advance.
- Number of passengers attribute is not added in the table - ticket as number of passengers associated with a particular ticket can be found by using the following query - 

```
SELECT ticket.pnr_no, COUNT(*) as num_passengers
FROM ticket, passenger
WHERE ticket.pnr_no = passenger.pnr_no
GROUP BY ticket.pnr_no;
```

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

## Other Functionalities
- View Ticket
    - Users can view the ticket by entering a valid PNR Number 
- View All Released Trains 
    - Both admins and users can see the details (train number, date of journey, number of AC & sleeper coaches) of all released trains.
- Check Train Status
    - Both admins and users can view the number of seats available for booking by entering a valid train number & date of journey.- 
- View All Users
    - Admins can see the details of all users registered in the system.
- View All Bookings
    - Admins can also view details of bookings made by all the users.
- View Previous Bookings
    - All users can view the details of the bookings made by them in the past.


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

## How to run locally 
- Install [XAMPP](https://www.apachefriends.org/index.html) on your system
- Clone the repository in ```C:/Program Files/XAMPP/htdocs``` 
- ``` git clone https://github.com/pranjalibajpai/railway-reservation-system.git```
- ``` cd railway-reservation-system ```
- Start Apache & Mysql Servers from XAMPP Control Panel 
- Visit http://localhost/phpmyadmin on your browser
- Create a new database ```rdb```  and then click Import 
- Select ```sql/rdb.sql``` & database will be loaded
- Open http://localhost/railway-reservation-system on your browser
- Now you are all set to start!

## Directory Structure

```
railway-reservation-system
├─ about.php
├─ admin-login.php
├─ admin-page.php
├─ book-ticket.php
├─ config
│  └─ connection.php
├─ contact.php
├─ css
│  └─ style.css
├─ get-ticket.php
├─ index.php
├─ logout.php
├─ not-available.php
├─ passenger-details.php
├─ Project Specification.pdf
├─ README.md
├─ register.php
├─ release-train.php
├─ sql
│  ├─ admin.sql
│  ├─ assign_berth.sql
|  ├─ generate_pnr.sql
│  ├─ passenger.sql
│  ├─ rdb.sql
│  ├─ stored_procedures.sql
│  ├─ ticket.sql
│  ├─ train.sql
│  ├─ train_status.sql
│  ├─ triggers.sql
│  └─ user.sql
├─ template
│  ├─ footer.php
│  ├─ header-name.php
│  ├─ header.php
│  └─ pagination.php
├─ user.php
├─ view-bookings.php
├─ view-pnr-details.php
├─ view-status.php
├─ view-ticket.php
├─ view-trains.php
├─ view-user-booking.php
└─ view-users.php

```
