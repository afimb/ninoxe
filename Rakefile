require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

# load public rake tasks
path = Pathname.new(__FILE__) + ".." + "lib" + "tasks" + "*.rake"
Dir[ path].each { |t| load t }
    
task :test => :spec
task :default => :spec

