# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "logtastic/version"

Gem::Specification.new do |s|
  s.name        = "logtastic"
  s.version     = Logtastic::VERSION
  s.authors     = ["Vincent Boisard"]
  s.email       = ["boisard.v@gmail.com"]
  s.homepage    = "https://github.com/elhu/logtastic"
  s.summary     = %q{Logstasher wrapper}
  s.description = %q{Logstasher wrapper}
  s.licenses    = 'MIT'

  s.rubyforge_project = "logtastic"

  s.files         = `git ls-files`.split("\n") - [".gitignore"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "logstasher"
  s.add_runtime_dependency "request_store"

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency("bundler", [">= 1.0.0"])
  s.add_development_dependency("rails", [">= 3.0"])
end
