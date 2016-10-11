# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mina/git-submodules/version'

Gem::Specification.new do |spec|
  spec.name          = "mina-git-submodules"
  spec.version       = Mina::GitSubmodules::VERSION
  spec.authors       = ["Cameron Taylor"]
  spec.email         = ["camerontaylor@gmail.com"]
  spec.description   = %q{Caching for git submodules when deploying with Mina}
  spec.summary       = %q{Caching for git submodules when deploying with Mina}
  spec.homepage      = "http://camerontaylor.github.io/mina-git-submodules/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'mina', .>= 0.2.1.
  spec.add_development_dependency 'bundler', '>= 1.3.5'
  spec.add_development_dependency 'rake'
end
