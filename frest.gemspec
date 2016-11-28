# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'frest/version'

Gem::Specification.new do |spec|
  spec.name          = "frest"
  spec.version       = Frest::VERSION
  spec.authors       = ["Guyren Howe"]
  spec.email         = ["guyren@relevantlogic.com"]

  spec.summary       = "User modifiable application framework."
  spec.homepage      = "http://github.com/gisborne/frest"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.bindir        = "bin"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency 'sqlite3'
  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'rbnacl'
  spec.add_runtime_dependency 'google-api-client'
  spec.add_runtime_dependency 'google-id-token'

  spec.executables << 'frest'
end
