# Budgerigar

An API-driven YNAB clone, hopefully as charismatic as its namesake.

## Core User Stories

1. As a user, I want to allocate amounts by category.
2. As a user, I want to know if I am over budget in one or more categories
3. As a user, I want to manually manage (add, update, delete) debits to my
   account
4. As a user, I want to view a spending summary for a given time period.
5. As a user, I want to filter transactions by amount, category, date, and
   payee.

## Getting Started

Assuming you've got some flavor of Docker and Docker-Compose running, getting
started with the application should be as easy as:

```shell
$ docker-compose build
$ docker-compose run rails db:setup
$ docker-compose up
```

This will also seed the database with a user and an API key.

You can run tests like so:

```shell
$ docker-compose run budgie_test bin/rspec
```

You may need to initialize and migrate your test database first:

```shell
$ docker-compose run RAILS_ENV=test rails db:create
$ docker-compose run RAILS_ENV=test rails db:migrate
```

And you can run the linter like this:

```shell
$ docker-compose run budgie pronto run`
```

(Note: this compares whatever you've currently got committed against the latest
Master branch, so it won't work quite the way you want when you're on the master
branch or if you're wanting to inspect uncommitted or unstaged changes)

There's also a [Postman](https://getpostman.com) collection. This is the easiest
way to interact with the application.

## Deployment

TODO: Write this section
