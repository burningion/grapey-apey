# Example Sign Up API

This is a stub of an API for new user signups. It uses Grape and ActiveRecord, and Swagger to show the API docs.

# Getting it up and running locally

If you're using a Mac, please install RVM. This project uses Ruby 2.2.0. One you've installed rvm do the following in the cloned repo directory:

```bash
rvm install ruby-2.2.0
rvm use ruby-2.2.0
bundle install
rake db:create
rake db:migrate
rspec 
rackup
```

This installs the Ruby if necessary, then associated libraries, creates the database, the database structure, runs tests, and then starts the server locally.

Once it's up and running, you can start playing with the API interactively through Swagger-UI at http://localhost:9292/swagger

# Sending data and getting it working

In order to use it we'll send the following JSON body:

``` json
{
    "name": "John Doe",
    "email": "john@doe.com",
    "password": "s3kr3t",
    "password_confirmation": "s3kr3t"
}
```

If you don't want to do this with Swagger in the web browser, you can do it from the command line by using curl:

```bash
curl -H 'Content-Type: application/json'  -X POST http://localhost:9292/v1/users/signup -d '{"name": "John Doe", "email": "john@doe.com", "password": "s3kr3t", "password_confirmation": "s3kr3t"}'
```
* And hopefully get back this response:

``` json
{
    "id": 1,
    "name": "JohnDoe",
    "email": "john@doe.com",
    "authentication_token": "s3kr3t-value"
}
```

Of course, authentication token will be something different.

The requirements are:

  * All attributes specified in the request JSON are required
  * The email address should be well-formed, at the very lead be something@something (this means localhost email addresses will work for testing
  * The email address should be unique, should not already have an existing user in the database.

# TODO

* ~~Test Suite~~
* ~~Docs~~ (This and the swagger docs)
* Push to Github