# Altspace Programming Project - Rails HMD Tracker

## Introduction

This is my implementation of Part 1 of the [Altspace Programming Project](https://github.com/tuesy/altspacevr-project-hmdtracker-rails/blob/master/INSTRUCTIONS.md). I wrote the first version in about 2 total hours including deployment to Heroku with additional time for writing this document. I purposely kept the first version simple and short to demonstrate efficiency. This document describes my thought processes during development (I was asked to skip Part 2 at this time). The goal is to give a sense of how I approach web development.

## Live Demo

The app is deployed [here](http://avr-mankindforward.herokuapp.com/).

## Process

I started by consolidating the requirements. I read the full instructions and make my own list of paraphrased requirements. Next, I wrote my tests. These were based on the requirements but expanded to cover additional cases. Finally, I wrote my code while running the test suite periodically.

## Design

### The Migration

Migrations should be repeatable when possible so I like to migrate up and then immediately do a `rake db:migrate:redo` to make sure it's repeatable. Beyond that, it's also nice to be able to do `rake db:setup` so you can reliably and repeatably reset the entire database until you get it right. In this case, the wrinkle was that during development you have to reset to right before the new migration and then run the migration to test your code. I just dumped the database to a .sql file and reloaded it using psql to speed up the development process here.

The migration itself was pretty straightforward but there are a couple of assumptions. It wipes any existing data in the existent "hmd_states" table. It also assumes that we want to be "noisy" and raise an exception if record-creation doesn't work. For a Production application, I would recommend not including this data manipulation as part of the migration. The data manipulation could be a one-off rake task that is run one after the migration is complete. This would really simplify the migration code and you would just test the rake task on QA data and perhaps even Production data and make appropriate backups where appropriate.

### Tests

I used Rspec and FactoryGirl with their Rails extensions to do unit testing. The setup took longer than usual because the migration needed to be in place and the basic struction of the Concern had to be in place before the specs would run properly. The specs are focused on the getter and setter methods for the "state field" because at the end of the day, we're providing an abstraction of a normal attribute. The FactoryGirl factories are detailed because the existing schema requires (almost) all the fields to be present.

For convenience, I'm testing the Hmd class explicitly. Ideally, you would create a generic class just to test the concern because you want to make sure your code works for any class you're mixing into and not just this one specific case. I usually write integration tests with Cucumber, the type where you setup the data and use capybara to simulate user behavior on the page, interacting with the elements. Given more time, I'd write those to cover the basic use case of choosing a new state from the dropdown for an hmd and clicking the "update" button. I also like to use "guard" with "autotest" to do continuous testing of both your cukes and specs, which speeds up the TDD process.

### Rails Concern: AuditedState

The key class method is "has_audited_state_through". It creates the getter and setter methods for the Hmd class as well as a custom validation and object life-cycle hook. Because this concern is added to both Hmd and HmdState, I'm explicit about what's setup for each class. It's also lazy loaded so you don't pollute the classes unnecessarily.

I try to keep the same naming convention throughout (e.g. "audited_state...") to avoid potential naming conflicts. Also, because we're doing lots of metaprogramming here, I added comments to give examples of what the code would look like in a typical model (e.g. has_many :hmd_states). The goal of a Concern is to reuse or reorganize code but you don't want to make it too much harder to read and debug.

I use a virtual attribute "audited_state" so we can have a clear separation between setting the state, validating the state, and the later persisting the state. The virtual attribute avoids the requirement to have a database column and allows you to customize the name of the field for the state if you wanted.

There's a custom validation for the value of state that raises an exception. I'm raising a RuntimeError but you could make it more readable with a custom error class. It may also be better to simply create a validation error so it's friendlier for things like form integrations and makes the abstraction easier to work with because it's just like a normal field except it's persisted in a separate database table rather than in a single column.

The after_save hook will work for both creates and updates, which is what we want. It will also raise an exception if the creation failed because we don't want this to fail quietly. This may not be a great experience for the user or for via an API because you'd block state updates just because the auditing system isn't working.

If we were to expand on AuditedState, I'd namespace more. For example, Altspace::AuditedState would be nice and if it got complex enough, we could turn it into a gem for reuse in other apps. I'd also provide more options so that things can be customized more. What if you wanted to name you "state" field something else? We'd also want to watch out for conflicts with existing gems like state_machine that we may use down the line.

### Scaling

You'd want to add an index to the "hmd_states" table because everytime you get "state", you're doing a database query over more and more rows. The index should probably be on hmd_id and created_at. This should be confirmed with a database explain plan showing the index being used. One downside of only have the state in the "hmd_states" table is that querying for Hmd's by state will be slower because you'll have to go through two tables. It's probably easier to keep the state field on the "hmd" table and just track the changes in addition--you're not losing too much by keeping that field.

### Misc

I added some best practice things like upgrading Rails to the latest patch version because security is important (see Mr. Robot). Added a .gitignore and explicitly set .ruby-version so we have consistency across environments. I'm using Puma as the web server both locally and on Heroku because it's fast.
