![Forem - using the forem-theme-twist theme](https://github.com/radar/forem/raw/master/doc/twist-theme-post.png)

*Forem, using the forem-theme-twist theme*

*For other screenshots, please see the `doc` folder*

# Forem [![Build status](http://travis-ci.org/radar/forem.png)](http://travis-ci.org/radar/forem)
*"NO U!"*

Forem is an engine for Rails that aims to be the best little forum system ever.
The end goal is to have an engine that can be dropped into an application that
provides the basic functionality of forums, topics and posts.

**We are currently undergoing large changes.** If you want to use this project, please
keep this in mind. You can view a list of the intended changes on our [Version 1.0
Roadmap](https://github.com/radar/forem/wiki/1.0-Roadmap)

# Demo

A demo application can be found at [http://forem.heroku.com](http://forem.heroku.com), and the source for this application can be found on the [forem.heroku.com
repository](http://github.com/radar/forem.heroku.com)

# Installation

Installing Forem is easy.

## Specify Gem dependencies

    gem 'forem', :git => "git://github.com/radar/forem.git"

And then one of `kaminari` or `will_paginate`

    gem 'kaminari', '0.13.0'
    # OR
    gem 'will_paginate', '3.0.3'

## Run the installer

**Ensure that you first of all have a `User` model and some sort of authentication system set up**. We would recommend going with [Devise](http://github.com/plataformatec/devise), but it's up to
you. All Forem needs is a model to link topics and posts to.

Run `rails g forem:install` and answer any questions that pop up. There's sensible defaults there if you don't want to answer them.

And you're done! Yaaay!

For more information on installing, please [see the "Installation" wiki
page](https://github.com/radar/forem/wiki/Installing---Upgrading)

## Features

Here's a comprehensive list of the features currently in Forem:

* Forums
  * CRUD operations (provided by an admin backend)
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
  * Editing posts
* Text Formatting
  * Posts are HTML escaped and pre tagged by default.
  * [Pluggable formatters for other behaviour (Markdown, Textile)](https://github.com/radar/forem/wiki/Formatters)
* [Theme support](https://github.com/radar/forem/wiki/Theming)
* [A flexible permissions system](https://github.com/radar/forem/wiki/Authorization-System)
* [Translations](https://github.com/radar/forem/wiki/Translations)
* [Flexible configuration](https://github.com/radar/forem/wiki/Configuration)
* [Integration with
  RefineryCMS](https://github.com/radar/forem/wiki/Integration-with-RefineryCMS)

If there's a feature you think would be great to add to Forem, let us know on [the Issues
page](https://github.com/radar/forem/issues)

## Auto Discovery Links
If you would like to add auto discovery links for the built in forum Atom feeds, then add the following method inside your &lt;head&gt; tag:

    <%= forem_atom_auto_discovery_link_tag %>

## View Customisation

If you want to customise Forem, you can copy over the views using the (Devise-inspired) `forem:views` generator:

    rails g forem:views

You will then be able to edit the forem views inside the `app/views/forem` of your application. These views will take precedence over those in the engine.

## Extending Classes

All of Forem’s business logic (models, controllers, helpers, etc) can easily be extended / overridden to meet your exact requirements using standard Ruby idioms.

Standard practice for including such changes in your application or extension is to create a file within the relevant app/models or app/controllers directory with the original class name with _decorator appended.

### Adding a custom method to the Post model:
    # app/decorators/models/forem/post_decorator.rb

    Forem::Post.class_eval do
      def some_method
        ...
      end
    end

### Adding a custom method to the PostsController:
    # app/decorators/controllers/forem/posts_controller_decorator.rb

    Forem::PostsController.class_eval do
      def some_action
        ...
      end
    end

The exact same format can be used to redefine an existing method.

## Translations

We currently have support for the following languages:

* Brazillian (pt-BR)
* Bulgarian
* Chinese (zh-CN)
* Dutch
* English
* Farsi (Persian)
* German
* Italian
* Polish
* Portuguese (pt-PT)
* Russian
* Spanish

Patches for new translations are very much welcome!

## OMG BUG! / OMG FEATURE REQUEST!

File an issue and we'll get around to it when we can.

## Developing on forem

Forem is implemented as a Rails engine and its specs are run in the context of a dummy Rails app. The process for getting the specs to run is similar to setting up a regular rails app:

    bundle exec rake forem:dummy_app

Once this setup has been done, Forem's specs can be run by executing this command:

    bundle exec rspec spec

More information can be found in [this issue](https://github.com/radar/forem/issues/24) in the bugtracker.

If all the tests are passing (they usually are), then you're good to go! Develop a new feature for Forem and be lavished with praise!

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
* [Huntington's Disease Youth Organization](http://hdyo.org/)
* [Miniand Tech](https://www.miniand.com/forums)

If you want yours added here, just ask!
