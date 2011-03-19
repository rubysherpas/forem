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

Once these gems are installed, run `rake forem:install` which will copy over any
assets and migrations that are contained within the engine. The final step that
is required is to mount this engine in the application's `config/routes.rb` file:

    mount Forem::Engine, :at => "forem"

## Refinery CMS Integration

Requires Refinery CMS >= 0.9.9.9

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
