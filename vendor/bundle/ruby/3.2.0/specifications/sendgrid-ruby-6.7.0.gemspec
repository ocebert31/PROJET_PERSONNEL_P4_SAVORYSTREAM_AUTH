# -*- encoding: utf-8 -*-
# stub: sendgrid-ruby 6.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sendgrid-ruby".freeze
  s.version = "6.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Elmer Thomas".freeze, "Robin Johnson".freeze, "Eddie Zaneski".freeze]
  s.date = "2023-12-01"
  s.description = "Official Twilio SendGrid Gem to Interact with Twilio SendGrids API in native Ruby".freeze
  s.email = "help@twilio.com".freeze
  s.homepage = "http://github.com/sendgrid/sendgrid-ruby".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Official Twilio SendGrid Gem".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<ruby_http_client>.freeze, ["~> 3.4"])
  s.add_development_dependency(%q<faker>.freeze, [">= 0"])
  s.add_development_dependency(%q<minitest>.freeze, ["~> 5.9"])
  s.add_development_dependency(%q<pry>.freeze, [">= 0"])
  s.add_development_dependency(%q<rack>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.18.5"])
  s.add_development_dependency(%q<sinatra>.freeze, [">= 1.4.7", "< 3"])
end
