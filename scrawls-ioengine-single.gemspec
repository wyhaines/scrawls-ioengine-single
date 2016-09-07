# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scrawls/ioengine/single/version'

Gem::Specification.new do |spec|
  spec.name          = "scrawls-ioengine-single"
  spec.version       = Scrawls::Ioengine::Single::VERSION
  spec.authors       = ["Kirk Haines"]
  spec.email         = ["wyhaines@gmail.com"]

  spec.summary       = %q{A blocking single threaded IO Engine for Scrawls.}
  spec.description   = %q{This is a simple reference implementation of an IO Engine, using a basic single threaded blocking model.}
  spec.homepage      = "http://github.com/wyhaines/scrawls-ioengine-single"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
