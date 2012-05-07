source "http://rubygems.org"

# Declare your gem's dependencies in ninoxe.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"
gem "acts_as_tree", :git => "git://github.com/dryade/acts_as_tree.git"
gem "acts_as_list", :git => "git://github.com/swanandp/acts_as_list.git"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'ruby-debug'

platforms :jruby do
  gem 'activerecord-jdbcpostgresql-adapter', :git => 'git://github.com/dryade/activerecord-jdbc-adapter.git'    
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'jruby-openssl'
end

platforms :ruby do
  gem 'pg', '~> 0.11.0' 
  gem 'sqlite3'
end

group :assets do
  gem 'uglifier'
  gem 'coffee-rails'
  gem 'sass-rails'
end

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'

  group :linux do
    gem 'rb-inotify'
    gem 'libnotify'
  end
end

group :test do
  gem 'rspec-rails', '2.8.1'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails', '1.7.0'
  gem 'database_cleaner'
end
