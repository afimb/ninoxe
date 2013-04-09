source "http://rubygems.org"

# Declare your gem's dependencies in ninoxe.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem "acts_as_tree-1.8", '1.1.0', :require => "acts_as_tree"  

platforms :jruby do
  gem 'activerecord-jdbcpostgresql-adapter', "1.2.9"
  gem 'activerecord-jdbcsqlite3-adapter', "1.2.9"
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
  group :linux do
    gem 'rb-inotify', :require => RUBY_PLATFORM.include?('linux') && 'rb-inotify'
    gem 'rb-fsevent', :require => RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'        
  end
end
