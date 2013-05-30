# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ninoxe/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ninoxe"
  s.version     = Ninoxe::VERSION
  s.authors     = ["Marc Florisson", "Michel Etienne", "Luc Donnet"]
  s.email       = ["mflorisson@cityway.fr", "metienne@cityway.fr", "ldonnet@cityway.fr"]
  s.homepage    = ""
  s.summary     = "Library dedicated to Chouette access."
  s.description = "This library provides a model to navigate through Chouette database."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('georuby-ext', '0.0.2' )
  s.add_dependency('activerecord', '>= 3.1.3' )
  s.add_dependency("acts_as_list", ">= 0.1.6")
  s.add_dependency("foreigner", "1.4.0")

  s.add_development_dependency('rake', '~> 0.9')
  s.add_development_dependency('jquery-rails')
  s.add_development_dependency('guard')
  s.add_development_dependency('guard-rspec')
  s.add_development_dependency('guard-bundler')
  s.add_development_dependency('rspec-rails')
  s.add_development_dependency('shoulda-matchers', '1.4.2')
  s.add_development_dependency('factory_girl_rails', '1.7.0')
  s.add_development_dependency('database_cleaner')
  s.add_development_dependency("rails", ">= 3.1.3")
end
