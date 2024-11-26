require_relative 'lib/hash_ring/version'

Gem::Specification.new do |spec|
  spec.name          = "hash_ring"
  spec.version       = HashRing::VERSION
  spec.authors       = ["Your Name"]
  spec.email         = ["your.email@example.com"]

  spec.summary       = %q{A flexible consistent hashing implementation in Ruby}
  spec.description   = %q{A Ruby implementation of consistent hashing with support for custom hash functions and configurable virtual nodes. Features include customizable hash functions, configurable virtual node counts, and dynamic node management.}
  spec.homepage      = "https://github.com/yourusername/hash_ring"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files         = Dir.glob("{lib}/**/*") + %w[README.md LICENSE.txt CHANGELOG.md]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "yard", "~> 0.9"
end
