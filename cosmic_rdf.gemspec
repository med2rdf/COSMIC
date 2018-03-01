# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cosmic_rdf/version'

Gem::Specification.new do |spec|
  spec.name          = 'cosmic_rdf'
  spec.version       = CosmicRdf::VERSION
  spec.authors       = ['Koichiro Yamada']
  spec.email         = ['koichiro.yamada@genomedia.jp']

  spec.summary       = 'COSMIC RDF Converter'
  spec.description   = 'COSMIC RDF Converter'

  spec.files         = Dir['README.md', 'lib/**/*']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'

  spec.add_dependency 'activesupport', '> 4.2.0'
  spec.add_dependency 'net-sftp'
end
