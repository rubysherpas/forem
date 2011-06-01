# Forem

This is a experimental engine for Rails that aims to be the best little forum system ever.
The end goal is to have an engine that can be dropped into an application that
provides the basic functionality of forums, topics and posts.

## Installation

**Currently, this engine requires that you use edge Rails which is known to be
broken at different points in time. Therefore, it isn't recommended that you use
it in any kind of production environment just yet.**

To install this engine, you will need to install edge versions of `rails`, `rack`
and `arel` in your application's `Gemfile` using these lines:

    gem 'rails', :git => "git://github.com/rails/rails.git"
    gem 'arel', :git => "git://github.com/rails/arel.git"
    gem 'rack', :git => "git://github.com/rack/rack.git"

Then you'll need to of course specify the engine itself:

    gem 'forem', :git => "git://github.com/radar/forem.git"

Run `bundle install` to install these gems.

Once these gems are installed, run `rake forem:install:migrations` which will copy over the migrations that are contained within the engine into your application, which will then need to be run using `rake db:migrate`.

The final step that is required is to mount this engine in the application's `config/routes.rb` file:

    mount Forem::Engine, :at => "forem"

This engine will then be accessible at `http://yoursite.com/forem`.

## Features

Here's a comprehensive list of the features currently in Forem:

*WIP means 'Work in Progress'*

* An admin backend
** Forums
*** CRUD operations
* Topics
** Viewing all topics for a forum
** Creating of new topics
** Deleting own topics
** Locking topics (WIP)
* Posts
** Replying to topics
** Deleting own topics
** Blocking replies to locked topics

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
* Adam McDonald
* Zak Strassburg
