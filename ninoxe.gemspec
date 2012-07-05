# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ninoxe/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ninoxe"
  s.version     = Ninoxe::VERSION
  s.authors     = ["Marc Florisson", "Alban Peignier", "Luc Donnet"]
  s.email       = ["marc.florisson@dryade.net", "alban.peignier@dryade.net", "luc.donnet@dryade.net"]
  s.homepage    = ""
  s.summary     = "Library dedicated to Chouette access."
  s.description = "This library provides a model to navigate through Chouette database."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('rake', '~> 0.9')

  s.add_runtime_dependency('activerecord', '> 3.1.3' )
  s.add_runtime_dependency('composite_primary_keys', '> 4.1.2')
  s.add_runtime_dependency('GeoRuby')
  s.add_runtime_dependency('geokit')
  s.add_runtime_dependency("rails", "> 3.1.3")
  s.add_runtime_dependency("acts_as_list", "0.1.6")
end
