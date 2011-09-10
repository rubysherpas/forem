![Forem - using the forem-theme-orange theme](https://github.com/radar/forem/raw/master/doc/screenshot.png)

*Forem, using the forem-theme-orange theme*

# Forem [![Build status](http://travis-ci.org/radar/forem.png)](http://travis-ci.org/radar/forem)

Forem is an engine for Rails that aims to be the best little forum system ever.
The end goal is to have an engine that can be dropped into an application that
provides the basic functionality of forums, topics and posts.

## Installation

Installing Forem is easy.

### Specify Gem dependencies

    gem 'forem', :git => "git://github.com/radar/forem.git"

You may also want to include the basic theme (which you can then fork and alter as you see fit)

    gem 'forem-theme-base', :git => "git://github.com/radar/forem-theme-base.git"

Run `bundle install` to install these gems.

If you're choosing to use a theme then you will have to put this line inside your `application.css` file's directives:

    *= require "forem/{theme}/style"

Alternatively, require the stylesheet using `stylesheet_link_tag`:

    <%= stylesheet_link_tag "forem/{theme}/style" %>

This will require you to have the Asset Pipeline feature *enabled* within your application, which is the default for Rails 3.1 applications.


### Run the migrations & setup the models and controllers

Once these gems are installed, run `rake forem:install:migrations` which will copy over the migrations that are contained within the engine into your application, which will then need to be run using `rake db:migrate`.

Then you will need to add a `forem_admin` boolean field to your `User` model. This is then used to indicate to forem if the currently signed in user should be an admin for forem or not. Currently there is no migration generator in forem to do this, so you will have to do it manually.

Also you will need to tell Forem what the `User` model of the application is so that it knows how to associate posts and topics to the authors. To do this, create a new file in the application called `config/initializers/forem.rb` and put this line in it:

    Forem.user_class = User

Finally, the controllers need to know what the current logged in user is for Forem's purposes.  You can put something like this in ApplicationController:

      def forem_user
        current_user
      end

      helper_method :forem_user

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

### Translations

We currently have support for the following languages:

* Chinese (zh-CN)
* English
* Italian
* Polish

Patches for new translations are very much welcome!

## Refinery CMS Integration

Requires Refinery CMS [master branch](https://github.com/resolve/refinerycms/tree/master)

Run:

    rails generate refinery:forem
    rake db:migrate

If you're using Forem with Refinery then you will need to specify the `user_class` option like this:

    Forem.user_class = Refinery::User

## OMG BUG! / OMG FEATURE REQUEST!

File an issue and we'll get around to it when we can.

## Contributors

* Ryan Bigg
* Philip Arndt
* Josh Adams
* Adam McDonald
* Zak Strassburg
