# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'objection/version'

Gem::Specification.new do |spec|
  spec.name          = "objection"
  spec.version       = Objection::VERSION
  spec.authors       = ["Ewout Quax"]
  spec.email         = ["ewout.quax@quicknet.nl"]
  spec.summary       = %q{Declare a predefined contract for use with services}
  spec.description   = %q{A predefined contract, with required and optional fields, for use with services.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
end
