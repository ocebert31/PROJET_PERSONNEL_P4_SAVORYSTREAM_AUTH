# -*- encoding: utf-8 -*-
# stub: turbo-rails 2.0.11 ruby lib

Gem::Specification.new do |s|
  s.name = "turbo-rails".freeze
  s.version = "2.0.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/hotwired/turbo-rails/releases" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sam Stephenson".freeze, "Javan Mahkmali".freeze, "David Heinemeier Hansson".freeze]
  s.date = "2024-10-15"
  s.email = "david@loudthinking.com".freeze
  s.homepage = "https://github.com/hotwired/turbo-rails".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "The speed of a single-page web application without having to write any JavaScript.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<actionpack>.freeze, [">= 6.0.0"])
  s.add_runtime_dependency(%q<railties>.freeze, [">= 6.0.0"])
end
