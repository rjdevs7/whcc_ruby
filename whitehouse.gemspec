# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whitehouse/version'

Gem::Specification.new do |spec|
  spec.name          = "whitehouse"
  spec.version       = Whitehouse::VERSION
  spec.authors       = ["travisdahlke"]
  spec.email         = ["travis.dahlke@whcc.com"]
  spec.summary       = %q{White House Custom Colour API Client}
  spec.description   = %q{A client gem for submitting orders to the White House Custom Colour API}
  spec.homepage      = "http://github.com/travisdahlke/whitehouse"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "hashie"
end
