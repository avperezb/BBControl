# BBControl

In order to run this project you will need to have Cabify app and the PlayStore app for the Cab request functionality.

As for the users, there are three types: administrator, waiter and customer; which users are as follows

+ Customer: 
user: vale_9817@hotmail.com
password: 123test

+ Waiter:
user: andrea@bbc.com
password: 123andrea

+ Admin:
user: fduran@adminbbc.com
password: adminwaiter1

For creating waiters, the password is set as "123 + first name" automatically. For instance, if the first name entered corresponds to Maria Camila, then the password will be 123maria, and it will work when trying to log in.

When the app is started, a prompt asking for gps use will appear, it is necessary to select the always option for the app to work properly. This is necessary since the app is set up to disable the menu buttons (except for the reservations button) if the device's location is not within a radius of 900 mts (we forgot to change the number after testing it), which would be the configuration for letting the user interact with the app only while being near to one of the BBCs registered on the database.
