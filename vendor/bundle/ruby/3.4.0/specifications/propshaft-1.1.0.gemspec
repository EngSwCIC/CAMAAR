# -*- encoding: utf-8 -*-
# stub: propshaft 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "propshaft".freeze
  s.version = "1.1.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Heinemeier Hansson".freeze]
  s.date = "2024-09-30"
  s.email = "dhh@hey.com".freeze
  s.homepage = "https://github.com/rails/propshaft".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7.0".freeze)
  s.rubygems_version = "3.5.16".freeze
  s.summary = "Deliver assets for Rails.".freeze

  s.installed_by_version = "3.6.7".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<actionpack>.freeze, [">= 7.0.0".freeze])
  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 7.0.0".freeze])
  s.add_runtime_dependency(%q<railties>.freeze, [">= 7.0.0".freeze])
  s.add_runtime_dependency(%q<rack>.freeze, [">= 0".freeze])
end
