# -*- encoding: utf-8 -*-
# stub: cucumber-rails 3.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "cucumber-rails".freeze
  s.version = "3.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 3.2.3".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/cucumber/cucumber-rails/issues", "changelog_uri" => "https://github.com/cucumber/cucumber-rails/blob/v3.1.1/CHANGELOG.md", "documentation_uri" => "https://cucumber.io/docs", "mailing_list_uri" => "https://groups.google.com/forum/#!forum/cukes", "source_code_uri" => "https://github.com/cucumber/cucumber-rails/tree/v3.1.1" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aslak Helles\u00F8y".freeze, "Dennis Bl\u00F6te".freeze, "Rob Holland".freeze]
  s.date = "2025-01-30"
  s.description = "Cucumber Generator and Runtime for Rails".freeze
  s.email = "cukes@googlegroups.com".freeze
  s.homepage = "https://cucumber.io".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.3.5".freeze
  s.summary = "cucumber-rails-3.1.1".freeze

  s.installed_by_version = "3.3.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<capybara>.freeze, [">= 3.11", "< 4"])
    s.add_runtime_dependency(%q<cucumber>.freeze, [">= 5", "< 10"])
    s.add_runtime_dependency(%q<railties>.freeze, [">= 5.2", "< 9"])
    s.add_development_dependency(%q<ammeter>.freeze, [">= 1.1.5"])
    s.add_development_dependency(%q<appraisal>.freeze, [">= 2.4.1", "< 3"])
    s.add_development_dependency(%q<aruba>.freeze, [">= 1.1.2", "< 3"])
    s.add_development_dependency(%q<database_cleaner>.freeze, ["~> 2.0"])
    s.add_development_dependency(%q<rails>.freeze, [">= 5.2", "< 9"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.2"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.13"])
    s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.45.0"])
    s.add_development_dependency(%q<rubocop-packaging>.freeze, ["~> 0.5.2"])
    s.add_development_dependency(%q<rubocop-performance>.freeze, ["~> 1.17.1"])
    s.add_development_dependency(%q<rubocop-rails>.freeze, ["~> 2.18.0"])
    s.add_development_dependency(%q<rubocop-rake>.freeze, ["~> 0.6.0"])
    s.add_development_dependency(%q<rubocop-rspec>.freeze, ["~> 2.17.0"])
    s.add_development_dependency(%q<yard>.freeze, ["~> 0.9.10"])
  else
    s.add_dependency(%q<capybara>.freeze, [">= 3.11", "< 4"])
    s.add_dependency(%q<cucumber>.freeze, [">= 5", "< 10"])
    s.add_dependency(%q<railties>.freeze, [">= 5.2", "< 9"])
    s.add_dependency(%q<ammeter>.freeze, [">= 1.1.5"])
    s.add_dependency(%q<appraisal>.freeze, [">= 2.4.1", "< 3"])
    s.add_dependency(%q<aruba>.freeze, [">= 1.1.2", "< 3"])
    s.add_dependency(%q<database_cleaner>.freeze, ["~> 2.0"])
    s.add_dependency(%q<rails>.freeze, [">= 5.2", "< 9"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.2"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.13"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 1.45.0"])
    s.add_dependency(%q<rubocop-packaging>.freeze, ["~> 0.5.2"])
    s.add_dependency(%q<rubocop-performance>.freeze, ["~> 1.17.1"])
    s.add_dependency(%q<rubocop-rails>.freeze, ["~> 2.18.0"])
    s.add_dependency(%q<rubocop-rake>.freeze, ["~> 0.6.0"])
    s.add_dependency(%q<rubocop-rspec>.freeze, ["~> 2.17.0"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9.10"])
  end
end
