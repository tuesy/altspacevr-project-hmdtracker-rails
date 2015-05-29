# Altspace Programming Project - Rails HMD Tracker

## Instructions

Update an existing Rails project to audit changes to a state table, and then include additional enhancements of your own.

## Goals

We use this test to get a sense of your coding style, your Ruby skills, and to how you creatively solve both a concrete problem and an abstract one. When we receive your project, here is what we will be asking ourselves:

- Does the basic functionality of the app work as intended?

- Is the auditing extension (described in Part 1 below) implemented properly?

- Do the enhancements (from Part 2) work well?

- Are the enhancements creative, challenging to implement, and just plain cool?

- Is the code well structured, easy to read and understand, and organized well?

This project should take approximately 5-15 hours to complete, and should be completed within a week of forking this repo. To work on the project:

- Fork and clone the repo.

- Inside of the `hmdtrack` folder you'll find a simple rails app you'll be modifying that lets you see a list of upcoming VR HMDs, and edit the state they are in. You'll need to run both `db:migrate` and `db:seed` to populate the initial db.  

# Part 1 - Audited State Transitions (3-5 hours)

At AltspaceVR, we implement a number of patterns in our Rails stack which are designed to improve auditing and reduce the amount of mutable state in our system. As a general rule, we always perform `INSERTs` and never `UPDATEs` or `DELETEs` in our database. We've added facilities to Rails to let programmers use ActiveRecord models as always, but under the hood tables are appended to not overwritten. You'll be implementing a variant of one of these patterns here.

In this small Rails app, we have a simple `hmds` table which includes all of the information about a small set of VR HMDs. Currently, the table looks like this:

```
+---------------------------------------------------
 id           | integer                     | not null default 
 name         | character varying(512)      | not null
 company      | character varying(512)      | not null
 state        | character varying(64)       | not null
 image_url    | character varying(512)      | not null
 announced_at | timestamp without time zone | not null
 created_at   | timestamp without time zone | not null
 updated_at   | timestamp without time zone | not null

```
(This is from PostgreSQL, you can use MySQL with this project as well.)

If you hit the app, you'll be presented with a list of HMDs and the state they are in. You can click the `Edit` link to update the state. Here's how this is done in the `hmds_controller.rb`:

```
  def update
    @hmd = Hmd.find(params[:id])
    @hmd.state = params[:hmd][:state]
    @hmd.save!

    redirect_to hmds_path
  end
```

As you can see, the state is updated directly on the table via an `UPDATE` statement to the database.

For this project, we would like you to change the way this state is stored. Instead of storing it on the table directly where it is continually overwritten, it will be stored in a secondary table that will continually have new rows appended whenever the state changes. This ensures that we can have a record of how the state changes over time. This second, initially empty table in the database is called `hmd_states`:

```
+---------------------------------------------------------
 id         | integer                     | not null default 
 hmd_id     | integer                     | not null
 state      | character varying(64)       | not null
 created_at | timestamp without time zone | not null
 updated_at | timestamp without time zone | not null

```

What we're looking for is a small bit of reusable Rails code which will result in the `state` attribute on the model to reflect the value of the `state` column of the latest row inserted into this table for that record. Setting the `state` attribute should also result in an insert into this table.

We would like this to be factored in a way to be re-usable. Your final implementations of the two models, `Hmd` and `HmdState` should look like this:

`hmd.rb`:
```
class Hmd < ActiveRecord::Base
  include AuditedState
  
  has_audited_state_through :hmd_states, [:announced, :devkit, :released]
end
```

`hmd_state.rb`
```
class HmdState < ActiveRecord::Base
  include AuditedState
  
  is_audited_state_for :hmd
end
```

This shows how you should be able to wire these two classes together. The `Hmd` class specifies which model to track the `state` attribute through via `has_audited_state_through`, and also specifies what are valid values for the state.

You can implement `AuditedState` as a Rails [Concern](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html) and should use Ruby metaprogramming to extend the class's functionality. Here are the requirements for this concern:

- `model.state` should initially equal the first valid value (in this example, `:announced`), even if there are no rows in the state table for that model yet.

- `model.state = :new_state` should insert a row into the state table with the value `new_state` in the database, and subsequent calls to `model.state` should return `:new_state`.

- You can set `model.state` to a string or a symbol, and it should work. Reading `model.state` should return a symbol.

- Trying to update `model.state` to an invalid value should raise a validation exception.

You should **not** need to change the controller code if you've implemented this correctly. By simply making these changes to the two model classes to include and use `AuditedState` you should be seeing rows get inserted into the `hmd_states` table instead of updating the `state` column on the `hmds` table.

For this part of the project, there are a few things you should submit:

- Your implementation of `audited_state.rb`
- A small set of unit tests + test fixtures.
- A migration script to migrate the existing legacy `state` column value into the new `hmd_states` table, and removal of the legacy column.

For this part of the project, please **do not** include additional 3rd party code. You can reference 3rd party code of course, but any code you write for the concern should be your own. (We'll be asking you how it works!)

# Part 2 - HMD Tracker Enhancements (5-10 hours)

The included app is pretty basic. This second part of the project is more open ended: we'd like you to spend time improving the functionality of the app in a way that showcases your skills and creativity.

Some ideas:

- Improve the state auditing library with better efficiency or more features.
- Update the app to use AJAX for saving the new state values.
- Add a basic authentication system and a way for users to favorite their favorite HMDs.
- Implement an email notification system for when the state of an HMD changes.
- Anything you want!

Feel free to use 3rd party code (gems, libraries) as needed, keeping in mind our assessment criteria (noted at the top of the README.)

## Deliverable

In your repo, you should clobber this README file with your own describing your project. Any instructions or known issues should be documented in the README as well.

E-mail us a link to your Github repo to `projects@altvr.com`. Please include your contact information, and if you haven't submitted it to us already, your resume and cover letter. 

We hope you have fun working on the project, and we can't wait to see what you come up with!
    
[The Altspace Team](http://altvr.com/team/)


