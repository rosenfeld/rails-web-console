$:.push File.expand_path("../lib", __FILE__)

require "rails_web_console/version"

Gem::Specification.new do |s|
  s.name        = 'rails-web-console'
  s.version     = RailsWebConsole::VERSION
  s.authors     = ['Rodrigo Rosenfeld Rosas']
  s.email       = ['rr.rosas@gmail.com']
  s.homepage    = 'https://github.com/rosenfeld/rails-web-console'
  s.summary     = 'A web console for Rails'
  s.description = 'Run any Ruby script from the context of a web request.'
  s.license     = 'MIT'

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'railties', '>= 3.1.0'
  s.add_dependency 'terminal-table', '~> 1.4'
  #s.add_dependency 'actionview' # adding this would break support for older Rails versions
end
