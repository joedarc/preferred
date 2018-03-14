$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "preferred/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "preferred"
  s.version     = Preferred::VERSION
  s.authors     = ["Nicholas W. Watson"]
  s.email       = ["nicholas.w.watson@me.com"]
  s.homepage    = "https://github.com/nwwatson/preferred"
  s.summary     = "Preferences on your Rails models stored in a JSONB column in PostgreSQL"
  s.description = "Preferred allows you to define preferences on a model and stores them in a jsonb column in PostgreSQL"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "> 4.0"
  s.add_dependency 'pg', '> 0.18.1'

  s.add_development_dependency "sqlite3"
end
