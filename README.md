### Steps
 - Added A few Models so that I can add products and customers from the API (Customer, Product, LineItem, Order)
 - Ran this to get my models (Decision to add data to database is to remove reliance on Bigcommerce in case the connection fails)
  - rails g model Customer first_name:string last_name:string email:string date_created:datetime date_modified:datetime
  - rails g model Order customer_id:integer date_created:datetime date_modified:datetime date_shipped:datetime status:string subtotal_ex_tax:float subtotal_inc_tax:float subtotal_tax:float
  - rails g model LineItem product_id:integer order_id:integer quantity:integer
  - rails g model Product name:string sku:string price:float date_created:datetime date_modified:datetime

- Added Service classes (Used them to import data from Bigcommerce)
- Run `rake bc:load_data` to get the initial content from the API
- Start the server and you are good to go

### Assumptions, Notes and Future information
- Did not add validation in the models
- Did not Add User table as authentication was not required for this project
- Wrote specs for some error conditions (These would help to see if we get the correct errors as we expected)
- Add Webhook controller to listen for when customers/orders/products are added removed or updated after initial product addition
- I only used a few fields from the incoming information in order to complete the excercise

#### Notes
- Ruby version on the original document is incorrect it says 4.2.0 it is supposed to be 2.4.0 or whatever higher version works