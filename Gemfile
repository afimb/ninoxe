source "http://rubygems.org"

# Specify your gem's dependencies in chouette-ninoxe.gemspec
gemspec

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'
  if RUBY_PLATFORM =~ /linux/
    gem 'rb-inotify' 
    gem 'libnotify' 
  end
end
