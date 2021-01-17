# README

This repository houses code for managing calendar events.

Table of Contents
=================
* [Setting up development environment](#setting-up-development-environment)
  * [Prerequisites](#prerequisites)
* [Setting up the database](#setting-up-the-database)
* [Importing users and events](#importing-users-and-events)
* [Starting the rails server](#starting-the-rails-server)
* [UI for listing events](#ui-for-listing-events)
* [Checking for availablity of users](#checking-for-availablity-of-users)



## Setting up development environment

### Prerequisites

* This app is using `ruby 2.7.2` and `rails 5.2.4.4`
* Install **rbenv** from [here](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-14-04)
* Install **ruby 2.7.2**: `rbenv install 2.7.2`
* Set **ruby 2.7.2** as local version in the project directory: `rbenv local 2.7.2`
* Install **bundler**: `gem install bundler`
* Install **pg**: `brew install postgresql`
* Install **asdf** - `brew install asdf`
* Install **nodejs 12.6.3** - `asdf install nodejs 12.16.3`
* Set **nodejs 12.6.3** as local version in the project directory: `asdf local nodejs 12.16.3`
* Run `bundle install`

## Setting up the database

* Migrate the database using `bundle exec rake db:drop db:create db:migrate db:seed`

## Importing users and events

* Add `users.csv` and `events.csv` inside `db/csvs`
* Open the rails console by typing `bundle exec rails c`
* Run the following commands in the console
```
User.import_users
Event.import_events
```

## Starting the rails server

* `bundle exec rails s` - This will start a rails server in the port 3000.
* Open `http://localhost:3000`

## UI for listing events

* Once you open `http://localhost:3000/events`, you will see the list of events with a date filter.

## Checking for availablity of users

* For a given time range and for a given user_id, run the following inside rails console.
```
user = User.find(user_id)
user.overlapping_events(from_time, to_time).empty?
```

* If you do not mention to_time, then it will consider end_time as 2 hours from from_time.