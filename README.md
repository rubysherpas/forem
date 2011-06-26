# Forem [![Build status](http://travis-ci.org/radar/forem.png)](http://travis-ci.org/radar/forem)

This is an experimental engine for Rails that aims to be the best little forum system ever.
The end goal is to have an engine that can be dropped into an application that 
provides the basic functionality of forums, topics and posts.

## Installation

**Currently, this engine requires that you use edge Rails which is known to be
broken at different points in time. Therefore, it isn't recommended that you use
it in any kind of production environment just yet.** However, as edge Rails approaches its 3.1 release status things will get much more stable.

### Specify Gem dependencies
To install this engine, you will need to install edge versions of `rails`, `rack`
`arel` and `sprockets` in your application's `Gemfile` using these lines:

    gem 'rails', :git => "git://github.com/rails/rails.git"
    gem 'arel', :git => "git://github.com/rails/arel.git"
    gem 'rack', :git => "git://github.com/rack/rack.git"
    gem 'sprockets', :git => "git://github.com/sstephenson/sprockets"

Then you'll need to of course specify the engine itself:

    gem 'forem', :git => "git://github.com/radar/forem.git"

Run `bundle install` to install these gems.

### Run the migrations & setup the models

Once these gems are installed, run `rake forem:install:migrations` which will copy over the migrations that are contained within the engine into your application, which will then need to be run using `rake db:migrate`.

Then you will need to add a `forem_admin` boolean field to your `User` model. This is then used to indicate to forem if the currently signed in user should be an admin for forem or not. Currently there is no migration generator in forem to do this, so you will have to do it manually.

Also you will need to tell Forem what the `User` model of the application is so that it knows how to associate posts and topics to the authors. To do this, create a new file in the application called `config/initializers/forem.rb` and put this line in it:

    Forem.user_class = User

### Mount the engine

The final step that is required is to mount this engine in the application's `config/routes.rb` file:

    mount Forem::Engine, :at => "forem"

This engine will then be accessible at `http://yoursite.com/forem`.

You will also need to define a route that defines a `sign_in_path` / `sign_in_url` helper, as forem will go looking for it when it requires users to be signed in.

## Features

Here's a comprehensive list of the features currently in Forem:

* An admin backend
  * Forums
      * CRUD operations
* Topics
  * Viewing all topics for a forum
  * Creating of new topics
  * Editing topics
  * Deleting own topics
  * Locking topics
  * Hiding topics
  * Pinning topics
* Posts
  * Replying to topics
  * Deleting own topics
  * Blocking replies to locked topics
* Markdown formatting for posts
* Theme support


## Refinery CMS Integration

Requires Refinery CMS [rails-3-1 branch](https://github.com/resolve/refinerycms/tree/rails-3-1)

Run:

    rails generate refinerycms_forem
    rake db:migrate

## OMG BUG! / OMG FEATURE REQUEST!

File an issue and we'll get around to it when we can.

## Contributors

* Ryan Bigg
* Philip Arndt
* Josh Adams
* Adam McDonald
* Zak Strassburg
