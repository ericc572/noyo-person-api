# Noyo Person API - Take home challenge submission (Eric Chen)

## Introduction
This is my implementation of the Person API take home challenge, written in Rails. This is an JSON API service to perform CRUD actions on a person object, with object versioning.

## Requirements
- Ruby 2.6.6
- Rails 6.0
- sqlite3

## The following endpoints are supported: 

`POST /persons` 

Creates a person. 

**Required Parameters**: (JSON BODY): first_name (string), last_name (string), email (string), age (integer)

   
   Curl Example


    curl --request 'POST' --header 'Content-Type: application/json' --data '{"age":"121","email":"eric@gmail.com","first_name":"First","last_name":"Last","middle_name":"Hi"}' 'localhost:3000/persons'


   Returns 422 if the necessary parameters are not specified.

`GET /person/{:id}`

Retrieve details about the latest version of a person, given their ID.

Curl Example
```
curl 'localhost:3000/persons/1/'
```

This will return 404 if ActiveRecord cannot find a corresponding record.

`GET /person/:id/version/:version_id`

Retrieve details about a specific version of a person, given their id and a specified version id.

Curl Example
```
curl 'localhost:3000/persons/1/version/1'
```

This query will find details on a person with id 1 and at version 1. Returns 404 if not found.

`GET /person/:id/history`

Retrieve all versions about a person, given their id. Helpful for the previous query above.

Curl Example
```
curl 'localhost:3000/persons/1/history'
```

`PUT /person/:id {}`

Updates a person's attributes given their id. 

Curl Example
```
curl --request 'PUT' --header 'Content-Type: application/json' --data '{"first_name":"second_Version"}' 'localhost:3000/persons/1'
```

`DELETE /person/:id`

Deletes a person given an id.

Curl Example
```
curl --request 'DELETE' --header 'Content-Type: application/json' 'localhost:3000/persons/1'
```

## Local Development
To run the server, first clone the repo then do 
```sh
bundle install 
```
Note: If you don't have bundler, you can get it via `gem install bundler`.

Create databse and run migrations via
```sh
rails db:setup
```

Start the rails server
```sh
rails s
```

## Running tests
To run the tests, ensure that you have rspec installed. Do this via:
```sh
gem install rspec
```

Then you can simply do:
```
bundle exec rspec 
```

## Notes/Learnings

This was a fun and engaging project to flex my new green-field API development muscle. Thanks for the opportunity to do this!

- **Why did I use ails?**
    > I used Rails primarily because it's my favorite web framework. :P Just kidding. I think it's the right choice here because it allows me to move quickly to build a RESTFul CRUD API, by following convention over wrestling with configuration. It has a lot of shortcuts and elegant ways of bringing in gems, which made it easy to add object versioning.

- **Why did I use sqlite**
    > For the purposes of this assignment, I chose sqlite for the database since it's lightweight, fast, and quick to set up. Also since we're going to be a non-production development server, it made sense right away to use local storage. If I scale to a high volume of requests + writes, we probably need to move to a client/server RDBMS like PostgreSQL.

- **How does object versioning work?**
    > I used the gem `paper-trail` to do object versioning on each person record. This gem creates a migration file to create a `versions` table, which is going to track changes I make to my models. It is also extremely robust out-of-the-box and also supports restoring, reverting, and authoring. The requirements were almost all satisfied by just bringing in the gem and running the migration, which was a neat feature. However, if I were to scale this to introduce multiple models, I would want to write wrapper classes and separate tables for each Version, like a `PersonVersions` for better extensibility.


- **Testing**: I used Rspec in favor of Minitest because it's explicit about the failures and gives very verbose output. spec/requests/person_request_spec.rb is the acceptance, or request test which is going to check that the endpoints function as expected with proper JSON responses, and fail accordingly when expected. I also have a model test in spec/models/person_spec.rb which checks that my validation rules are holding properly.