# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ttvdb/version'

Gem::Specification.new do |spec|
  spec.name          = "ttvdb"
  spec.version       = TTVDB::VERSION
  spec.authors       = ["Konrad Lother"]
  spec.email         = ["konrad@corpex.de"]
  spec.summary       = %q{The TVDB API Library}
  spec.description   = %q{The TVDB API Library - Another the tvdb api library}
  spec.homepage      = "https://lotherk.github.io/ttvdb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_dependency "xml-simple"
  spec.add_dependency "rest-client"
  spec.add_dependency "similar_text"
end
