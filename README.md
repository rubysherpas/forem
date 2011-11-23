![Forem - using the forem-theme-twist theme](https://github.com/radar/forem/raw/master/doc/twist-theme-post.png)

*Forem, using the forem-theme-twist theme*

*For other screenshots, please see the `doc` folder*

# Forem [![Build status](http://travis-ci.org/radar/forem.png)](http://travis-ci.org/radar/forem)
*"NO U!"*

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

Then you will need to add a `forem_admin` boolean field or `forem_admin?` method to your `User` model. This is then used to indicate to forem if the currently signed in user should be an admin for forem or not. Currently there is no migration generator in forem to do this, so you will have to do it manually.

Also you will need to tell Forem what the `User` model of the application is so that it knows how to associate posts and topics to the authors. This model does not have to be called `User`, it can be called anything. This model *must* have a `to_s` method defined on it which is the display field used by Forem.

You can create this `User` model using any method you wish, be it Devise, Authlogic or a
custom `User` model from scratch. It's your application; do with it what you want.

To tell Forem what this model is, create a new file in the application called `config/initializers/forem.rb` and put this line in it:

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
* Text Formatting
  * Posts are HTML escaped and pre tagged by default.
  * Pluggable formatters for other behaviour (Markdown, Textile)
* Theme support

### Customisation

If you want to customise Forem, you can copy over the views using the (Devise-inspired) `forem:views` generator:

    rails g forem:views

You will then be able to edit the forem views inside the `app/views/forem` of your application. These views will take precedence over those in the engine.

### Application route helpers ###

When using Rails route helpers in your application layout, or in customised forem views, you need to make it clear that they are main app links.

    link_to "Sign out", main_app.sign_out_path

Otherwise you will get errors resembling:
  
    ActionView::Template::Error (undefined local variable or method `sign_out_path' for #<#Class:0x7f4f21002090:0x7f4f20ffda40>)

Conversely to access forem paths you would use:

    link_to "Discussion", forem.root_path

### Post formatting

To change the post formatting behaviour, you may want to try these gems:

  * [Forem - Markdown (RDiscount) formatter](https://github.com/radar/forem-rdiscount)
  * [Forem - Markdown (Redcarpet) formatter](https://github.com/nruth/forem-markdown_formatter)
  * [Forem - Textile formatter](https://github.com/nruth/forem-textile_formatter)

It is preferrable that if you want to use your own formatter to set `Forem.formatter` to a class defined by you which contains a `format` method that will be used. If `Forem.formatter` is set
then it will reference this formatter and not use the default `simple_format` which is defined by Rails.

### User profiles

To change the username text on each post to be a link to the User's profile use the following configuration:

    Forem.enable_user_profile_links = true

Then you just need to make sure that you have routes configured for your user model to show the desired profile page. 

### Translations

We currently have support for the following languages:

* Chinese (zh-CN)
* English
* Italian
* Polish

Patches for new translations are very much welcome!

### Additional themes

Here are some other themes you can use:

Blue links, black headers:

    gem 'forem-theme-twist', :git => "git://github.com/radar/forem-theme-twist.git"

Brown links, orange headers and posts body:

    gem 'forem-theme-orange', :git => "git://github.com/radar/forem-theme-orange.git"

### Gravatar

By default Forem uses Gravatar for displaying avatar images for post authors. If the user object returned by `forem_user` responds to `email`, this is queried automatically. If a user does not have a Gravatar image associated with their email address they will get the default Gravatar image:

![default gravatar](http://www.gravatar.com/avatar/00000000000000000000000000000000)

The behavior of the default image can be configured with two configuration options.

#### Default theme

To set a default Gravatar theme, use the `.default_gravatar` method:

    Forem.default_gravatar = 'mm'

#### Default image

To set a default image, use the `.default_gravatar_image` method:

    Forem.default_gravatar_image = 'gravatar_default.png'

When a relative path is given, it will be expanded into the absolute URL required by Gravatar with information from the request that was made and Rails's configuration. For example, given the above method call, in development this would be expanded to something like:

    http://localhost:3000/images/gravatar_default.png

Passing an absolute URL to `.default_gravatar_image` or `.default_gravatar` is roughly equivalent.

#### More information

More information about Gravatar can be found on [this page about Gravatar image requests.](http://en.gravatar.com/site/implement/images/)

## Refinery CMS Integration

Requires Refinery CMS [master branch](https://github.com/resolve/refinerycms/tree/master)

Run:

    rails generate refinery:forem
    rake db:migrate

If you're using Forem with Refinery then you will need to specify the `user_class` option like this:

    Forem.user_class = Refinery::User

## OMG BUG! / OMG FEATURE REQUEST!

File an issue and we'll get around to it when we can.

## Running the spec suite

Forem is implemented as a Rails engine and its specs are run in the context of a dummy Rails app. The process for getting the specs to run is similar to setting up a regular rails app:

    bundle exec rake -f spec/dummy/Rakefile db:drop db:create db:migrate db:test:prepare

Once this setup has been done, Forem's specs can be run by executing this command:

    bundle exec rspec spec

More information can be found in [this issue](https://github.com/radar/forem/issues/24) in the bugtracker.

## Contributors

* Ryan Bigg
* Philip Arndt
* Josh Adams
* Adam McDonald
* Zak Strassburg
* [And more](https://github.com/radar/forem/contributors)

## Places using Forem

* [Bias Project](http://biasproject.org)
* [Alabama Intel](http://alabamaintel.com)
* [PixieEngine](http://pixieengine.com/community)
* [2012 Presidential Election](http://www.2012-presidential-election.info/network/)

If you want yours added here, just ask!
