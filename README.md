![Forem - using the forem-theme-twist theme](https://github.com/radar/forem/raw/master/doc/twist-theme-post.png)

*Forem, using the forem-theme-twist theme*

*For other screenshots, please see the `doc` folder*

# Forem [![Build status](http://travis-ci.org/radar/forem.png)](http://travis-ci.org/radar/forem)
*"NO U!"*

Forem is an engine for Rails that aims to be the best little forum system ever.
The end goal is to have an engine that can be dropped into an application that
provides the basic functionality of forums, topics and posts.

# Demo

A demo application can be found at [http://forem.heroku.com](http://forem.heroku.com), and the source for this application can be found on the [forem.heroku.com
repository](http://github.com/radar/forem.heroku.com)

# Installation

Installing Forem is easy.

## Specify Gem dependencies

    gem 'forem', :git => "git://github.com/radar/forem.git"

## Run the installer

**Ensure that you first of all have a `User` model and some sort of authentication system set up**. We would recommend going with [Devise](http://github.com/plataformatec/devise), but it's up to
you. All Forem needs is a model to link topics and posts to.

Run `rails g forem:install` and answer any questions that pop up. There's sensible defaults there if you don't want to answer them.

And you're done! Yaaay!

For more information on installing, please [see the "Installation" wiki
page](https://github.com/radar/forem/wiki/Installation)

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

## Customisation

If you want to customise Forem, you can copy over the views using the (Devise-inspired) `forem:views` generator:

    rails g forem:views

You will then be able to edit the forem views inside the `app/views/forem` of your application. These views will take precedence over those in the engine.

## Translations

We currently have support for the following languages:

* Brazillian (pt-BR)
* Chinese (zh-CN)
* English
* German
* Italian
* Russian
* Polish

Patches for new translations are very much welcome!

## OMG BUG! / OMG FEATURE REQUEST!

File an issue and we'll get around to it when we can.

## Developing on forem

Forem is implemented as a Rails engine and its specs are run in the context of a dummy Rails app. The process for getting the specs to run is similar to setting up a regular rails app:

    bundle exec rake -f spec/dummy/Rakefile db:drop db:create db:migrate db:test:prepare

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

If you want yours added here, just ask!
