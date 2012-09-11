# -*- encoding: utf-8 -*-
require File.expand_path('../lib/datetimepicker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Daniel Ott"]
  gem.email         = ["danott@marshill.com"]
  gem.description   = %q{Custom field for individual setting of date and time for Rails :datetime attributes.}
  gem.summary       = %q{Custom field for individual setting of date and time for Rails :datetime attributes.}
  gem.homepage      = "http://github.com/marshill/datetimepicker"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "datetimepicker"
  gem.require_paths = ["lib"]
  gem.version       = Datetimepicker::VERSION
end
