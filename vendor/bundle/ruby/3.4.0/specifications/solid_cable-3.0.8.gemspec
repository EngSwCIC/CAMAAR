# -*- encoding: utf-8 -*-
# stub: solid_cable 3.0.8 ruby lib

Gem::Specification.new do |s|
  s.name = "solid_cable".freeze
  s.version = "3.0.8".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://github.com/rails/solid_cable", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/rails/solid_cable" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nick Pezza".freeze]
  s.date = "1980-01-02"
  s.description = "Database-backed Action Cable backend.".freeze
  s.email = ["pezza@hey.com".freeze]
  s.homepage = "https://github.com/rails/solid_cable".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1.0".freeze)
  s.rubygems_version = "3.6.8".freeze
  s.summary = "Database-backed Action Cable backend.".freeze

  s.installed_by_version = "3.6.7".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<activerecord>.freeze, [">= 7.2".freeze])
  s.add_runtime_dependency(%q<activejob>.freeze, [">= 7.2".freeze])
  s.add_runtime_dependency(%q<actioncable>.freeze, [">= 7.2".freeze])
  s.add_runtime_dependency(%q<railties>.freeze, [">= 7.2".freeze])
end
