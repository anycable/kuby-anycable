# frozen_string_literal: true

require_relative "lib/kuby/anycable/version"

Gem::Specification.new do |s|
  s.name = "kuby-anycable"
  s.version = Kuby::Anycable::VERSION
  s.authors = ["Vladimir Dementyev"]
  s.email = ["dementiev.vm@gmail.com"]
  s.homepage = "http://github.com/anycable/kuby-anycable"
  s.summary = "Kuby plugin to deploy AnyCable applications"
  s.description = "Kuby plugin to deploy AnyCable applications"

  s.metadata = {
    "bug_tracker_uri" => "http://github.com/anycable/kuby-anycable/issues",
    "changelog_uri" => "https://github.com/anycable/kuby-anycable/blob/master/CHANGELOG.md",
    "documentation_uri" => "http://github.com/anycable/kuby-anycable",
    "homepage_uri" => "http://github.com/anycable/kuby-anycable",
    "source_code_uri" => "http://github.com/anycable/kuby-anycable"
  }

  s.license = "MIT"

  s.files = Dir.glob("lib/**/*") + Dir.glob("bin/**/*") + %w[README.md LICENSE.txt CHANGELOG.md]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 2.6"

  s.add_development_dependency "bundler", ">= 1.15"
  s.add_development_dependency "rake", ">= 13.0"
end
