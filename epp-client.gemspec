# -*- encoding: utf-8 -*-
require File.expand_path('../lib/epp-client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Geoff Garside"]
  gem.email         = ["geoff@geoffgarside.co.uk"]
  gem.description   = %q{Client for communicating with EPP services}
  gem.summary       = %q{EPP (Extensible Provisioning Protocol) Client}
  gem.homepage      = "https://github.com/m247/epp-client"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "epp-client"
  gem.require_paths = ["lib"]
  gem.version       = EPP::VERSION

  gem.extra_rdoc_files = %w(LICENSE README.md)

  gem.add_dependency 'libxml-ruby'
end
