# -*- encoding: utf-8 -*-
require File.expand_path('../lib/role_tree/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ruoran Wang"]
  gem.email         = ["dashuiwa@gmail.com"]
  gem.description   = %q{Write a gem description}
  gem.summary       = %q{Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "role_tree"
  gem.require_paths = ["lib"]
  gem.version       = RoleTree::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'

end
