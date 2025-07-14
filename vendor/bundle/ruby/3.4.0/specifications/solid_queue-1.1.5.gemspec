# -*- encoding: utf-8 -*-
# stub: solid_queue 1.1.5 ruby lib

Gem::Specification.new do |s|
  s.name = "solid_queue".freeze
  s.version = "1.1.5".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://github.com/rails/solid_queue", "source_code_uri" => "https://github.com/rails/solid_queue" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Rosa Gutierrez".freeze]
  s.date = "2025-04-20"
  s.description = "Database-backed Active Job backend.".freeze
  s.email = ["rosa@37signals.com".freeze]
  s.homepage = "https://github.com/rails/solid_queue".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "Upgrading from Solid Queue < 1.0? Check details on breaking changes and upgrade instructions\n--> https://github.com/rails/solid_queue/blob/main/UPGRADING.md\n".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 3.1".freeze)
  s.rubygems_version = "3.5.16".freeze
  s.summary = "Database-backed Active Job backend.".freeze

  s.installed_by_version = "3.6.7".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<activerecord>.freeze, [">= 7.1".freeze])
  s.add_runtime_dependency(%q<activejob>.freeze, [">= 7.1".freeze])
  s.add_runtime_dependency(%q<railties>.freeze, [">= 7.1".freeze])
  s.add_runtime_dependency(%q<concurrent-ruby>.freeze, [">= 1.3.1".freeze])
  s.add_runtime_dependency(%q<fugit>.freeze, ["~> 1.11.0".freeze])
  s.add_runtime_dependency(%q<thor>.freeze, ["~> 1.3.1".freeze])
  s.add_development_dependency(%q<debug>.freeze, ["~> 1.9".freeze])
  s.add_development_dependency(%q<mocha>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<puma>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<mysql2>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<pg>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<sqlite3>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rubocop-rails-omakase>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rdoc>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<logger>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<zeitwerk>.freeze, ["= 2.6.0".freeze])
end
