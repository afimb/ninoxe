# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chouette-ninoxe/version"

Gem::Specification.new do |s|

  s.add_development_dependency('rspec')
  s.add_development_dependency('pg')
  s.add_development_dependency('database_cleaner')

  s.add_runtime_dependency('activerecord')
  s.add_runtime_dependency('composite_primary_keys')

  s.name        = "chouette-ninoxe"
  s.version     = Chouette::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marc Florisson", "Alban Peignier"]
  s.email       = ["marc.florisson@dryade.net", "alban.peignier@dryade.net"]
  s.homepage    = ""
  s.summary     = %q{library dedicated to Chouette access}
  s.description = %q{this library provides a model to navigate through Chouette database}

  s.rubyforge_project = s.name

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
