# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'binding_dumper/version'

Gem::Specification.new do |spec|
  spec.name          = "binding_dumper"
  spec.version       = BindingDumper::VERSION
  spec.authors       = ["Ilya Bylich"]
  spec.email         = ["ibylich@gmail.com"]

  spec.summary       = %q{A gem for dumping a whole binding.}
  spec.homepage      = "https://github.com/iliabylich/binding_dumper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec'
end
