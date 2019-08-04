lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rspec/perftest/version"

Gem::Specification.new do |spec|
  spec.name          = "rspec-perftest"
  spec.version       = Rspec::Perftest::VERSION
  spec.authors       = ["yuemori"]
  spec.email         = ["yuemori@aiming-inc.com"]

  spec.summary       = "Benchmark and profile your apps with rspec."
  spec.description   = "Benchmark and profile your apps with rspec."
  spec.homepage      = "https://github.com/yuemori/rspec-perftest"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec", "~> 3.0"
  spec.add_dependency "terminal-table"
  spec.add_dependency "stackprof"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-performance"
end
