# Monster Shop
An online, e-commerce application for an easier and more convenient shopping experience.

## Background and Description

"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will automatically set the order status to "shipped". Each user role will have access to some or all CRUD functionality for application models.


### Rails
* Create routes for namespaced routes
* Use Sessions to store information about a user and implement login/logout functionality
* Use filters (e.g. `before_action`) in a Rails controller
* Limit functionality to authorized users
* Use BCrypt to hash user passwords before storing in the database

### Databases
* Design and diagram a Database Schema

### Many-to-Many and One-to-Many Relationships
* This project utilizes both one-to-many and many-to-many relationships, connecting multiple tables in our database for an easier user experience.

![image](https://user-images.githubusercontent.com/52808022/75277723-cc8a2200-57c5-11ea-89be-5e897431213d.png)

## Access
Start shopping online, hassle-free, by visiting Website

## Work on this project yourself!
-To get started, please visit Website and clone this project to your local machine!

-Once you are on the site, look for the green 'Clone or Download' button on the right side of the web page.

![Screen Shot 2020-02-25 at 11 32 32 AM](https://user-images.githubusercontent.com/52808022/75276092-bf1f6880-57c2-11ea-977a-8f885322cd15.png)

Next, copy the SSH Key after you have pressed the green 'Clone or Download' button.

![Screen Shot 2020-02-25 at 11 42 13 AM](https://user-images.githubusercontent.com/52808022/75276756-02c6a200-57c4-11ea-9026-aa60d1ff1e62.png)

Then, go to the directory in your temrinal where you would like
this project to be. Type in 'git clone' and the paste the copied SSH key in to your terminal before pressing enter.

![Screen Shot 2020-02-25 at 11 48 02 AM](https://user-images.githubusercontent.com/52808022/75277652-a2386480-57c5-11ea-935e-af97b41d8bbb.png)

You can now move in to the project and open it from your text editor.

## Application Resources

- Uses Rails 5.1.x
- Uses PostgreSQL
- Uses 'bcrypt' for authentication
- Controller and model code was be tested via feature tests and model tests, respectively
- Created using good GitHub branching, team code reviews via GitHub comments, and use of the project planning tool, github projects

## Permitted

- To use FactoryBot to speed up your test development
- To use "rails generators" to speed up your app development

## Permission

- If there is a specific gem you'd like to use in the project, please get permission from the creators first

## User Roles for Monster Shop

1. Visitor - this type of user is anonymously browsing our site and is not logged in. you will be able to visit parts of the site and view both merchants and their products to see if there is anything that interests you. However, before you are able to checkout with any merchandise, you will need to register as a new user.

![Screen Shot 2020-02-25 at 12 15 31 PM](https://user-images.githubusercontent.com/52808022/75279470-e711ca80-57c8-11ea-9847-84aa1add641c.png)

When registering, fill in all the fields with your information and remember, your email address must be unique!

![Screen Shot 2020-02-25 at 12 20 09 PM](https://user-images.githubusercontent.com/52808022/75279721-538cc980-57c9-11ea-94b1-6030d19ec058.png)

2. Regular User - Great! Now you are a registered user! This user is registered and logged in to the application while performing their work; can place items in a cart and create an order!

![image](https://user-images.githubusercontent.com/52808022/75280096-0c530880-57ca-11ea-89ef-332af1dedbe1.png)

3. Merchant Employee - this user works for a merchant. They can fulfill orders on behalf of their merchant. They also have the same permissions as a regular user (adding items to a cart and checking out)


4. Admin User - a registered user who has "superuser" access to all areas of the application; user is logged in to perform their work!
