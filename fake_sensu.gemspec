# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fake_sensu/version'

Gem::Specification.new do |spec|
  spec.name          = "fake_sensu"
  spec.version       = FakeSensu::VERSION
  spec.authors       = ["Alan Sebastian"]
  spec.email         = ["alan.sebastian@sonian.net"]
  spec.description   = %q{Mocking library for sensu}
  spec.summary       = %q{Mocking library/server for sensu}
  spec.homepage      = "http://www.github.com/asebastian/fake_sensu"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "lib/fake_sensu/responses"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
