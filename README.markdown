Console
=======

A Rails 3.1 engine for running Ruby scripts on the browser in the context of a controller action.

You can install it as a gem or putting it in your vendor/plugins/console directory.

Installing as a Gem (preferred method)
-------------------------------------

In your Gemfile, put the dependency like this:

<pre>
gem 'rails-web-console', :require => 'console', :group => :development
</pre>

If you intend to use this in production environment (strongly discouraged), be sure to protect console routes. Do it on your own risk!

Installing with a clone
-----------------------

Just put it in your vendor/plugins/console. For instance:

<pre>
git submodule add git://github.com/rosenfeld/rails-web-console.git vendor/plugins/console
</pre>

Usage
-----

Just access "/console" in your browser.

Support for older versions of Rails
-----------------------------------

I won't be supporting older versions of Rails to keep the source as simple as possible.

Take a look at older releases of this gem for supporting older Rails.


Copyright (c) 2010 [Rodrigo Rosenfeld Rosas], released under the MIT license
