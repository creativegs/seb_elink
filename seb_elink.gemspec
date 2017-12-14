
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "seb_elink/version"

Gem::Specification.new do |gem|
  gem.name          = "seb_elink"
  gem.required_ruby_version = '>= 2'
  gem.date          = "2017-12-14"
  gem.version       = SebElink::VERSION
  gem.authors       = ["Epigene"]
  gem.email         = ["cto@creative.gs", "augusts.bautra@gmail.com"]

  gem.summary       = "Ruby wrapper for communicating with SEB.lv i-bank payment API."
  gem.homepage      = "https://github.com/CreativeGS/seb_elink"
  gem.license       = "BSD-3-Clause"

  gem.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.16"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 3.7"
  gem.add_development_dependency "pry", "~> 0.11.3"
end
