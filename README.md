# RailsWebConsole

A Rails mountable engine for running Ruby scripts on the browser in the context of a
controller action.

## Dependencies

It doesn't assume anything about Sprockets being available and will embed any JS directly into
the views to avoid any dependencies on Sprockets.

ActionView is required though but it's not declared as a dependency in the gemspec as it's a
separate gem just as of Rails 4.1.x, so it would prevent this gem from working with older Rails
versions, but you should make sure your Rails application include support to ActionView.

## Browser support

All modern browsers and IE >= 8 should be supported.

## Minimal Ruby supported version

1.9 is the minimal required version due to usage of `require_relative` and the new hash syntax.

Patches for supporting older Ruby versions won't be accepted.

## Install

In your Gemfile, put the dependency like this:

```ruby
gem 'rails-web-console', group: :development
```

This will automatically mount it in /console. If you want to specify a different mount point,
use:

```ruby
gem 'rails-web-console', require: 'rails_web_console/engine', group: :development
```

And add this to your config/routes.rb:

```ruby
mount RailsWebConsole::Engine => '/inspect' if Rails.env.development?
```

If you intend to use this in production environment (strongly discouraged), be sure to protect console routes. Do it on your own risk!

## Usage

Just access "/console" (or whatever path you've chosen) in your browser.

## Support for older versions of Rails

I won't be supporting older versions of Rails to keep the source as simple as possible.

Take a look at older releases of this gem for supporting older Rails.


Copyright (c) 2014 [Rodrigo Rosenfeld Rosas], released under the MIT license

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/rosenfeld/rails-web-console/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
