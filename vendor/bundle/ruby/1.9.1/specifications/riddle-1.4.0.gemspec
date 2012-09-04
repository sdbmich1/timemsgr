# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{riddle}
  s.version = "1.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Allan"]
  s.date = %q{2011-08-01}
  s.description = %q{A Ruby API and configuration helper for the Sphinx search service.}
  s.email = %q{pat@freelancing-gods.com}
  s.files = ["spec/functional/connection_spec.rb", "spec/functional/excerpt_spec.rb", "spec/functional/keywords_spec.rb", "spec/functional/persistance_spec.rb", "spec/functional/search_spec.rb", "spec/functional/status_spec.rb", "spec/functional/update_spec.rb", "spec/riddle/auto_version_spec.rb", "spec/riddle/client_spec.rb", "spec/riddle/configuration_spec.rb", "spec/riddle/controller_spec.rb", "spec/riddle/query/delete_spec.rb", "spec/riddle/query/insert_spec.rb", "spec/riddle/query/select_spec.rb", "spec/riddle/query_spec.rb", "spec/riddle_spec.rb", "spec/spec_helper.rb", "spec/sphinx_helper.rb", "spec/unit/client_spec.rb", "spec/unit/configuration/distributed_index_spec.rb", "spec/unit/configuration/index_spec.rb", "spec/unit/configuration/indexer_spec.rb", "spec/unit/configuration/realtime_index_spec.rb", "spec/unit/configuration/searchd_spec.rb", "spec/unit/configuration/source_spec.rb", "spec/unit/configuration/sql_source_spec.rb", "spec/unit/configuration/xml_source_spec.rb", "spec/unit/configuration_spec.rb", "spec/unit/filter_spec.rb", "spec/unit/message_spec.rb", "spec/unit/response_spec.rb", "spec/unit/riddle_spec.rb"]
  s.homepage = %q{http://freelancing-god.github.com/riddle/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{An API for Sphinx, written in and for Ruby.}
  s.test_files = ["spec/functional/connection_spec.rb", "spec/functional/excerpt_spec.rb", "spec/functional/keywords_spec.rb", "spec/functional/persistance_spec.rb", "spec/functional/search_spec.rb", "spec/functional/status_spec.rb", "spec/functional/update_spec.rb", "spec/riddle/auto_version_spec.rb", "spec/riddle/client_spec.rb", "spec/riddle/configuration_spec.rb", "spec/riddle/controller_spec.rb", "spec/riddle/query/delete_spec.rb", "spec/riddle/query/insert_spec.rb", "spec/riddle/query/select_spec.rb", "spec/riddle/query_spec.rb", "spec/riddle_spec.rb", "spec/spec_helper.rb", "spec/sphinx_helper.rb", "spec/unit/client_spec.rb", "spec/unit/configuration/distributed_index_spec.rb", "spec/unit/configuration/index_spec.rb", "spec/unit/configuration/indexer_spec.rb", "spec/unit/configuration/realtime_index_spec.rb", "spec/unit/configuration/searchd_spec.rb", "spec/unit/configuration/source_spec.rb", "spec/unit/configuration/sql_source_spec.rb", "spec/unit/configuration/xml_source_spec.rb", "spec/unit/configuration_spec.rb", "spec/unit/filter_spec.rb", "spec/unit/message_spec.rb", "spec/unit/response_spec.rb", "spec/unit/riddle_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mysql2>, ["= 0.3.2"])
      s.add_development_dependency(%q<jeweler>, ["= 1.5.1"])
      s.add_development_dependency(%q<rspec>, [">= 2.5.0"])
      s.add_development_dependency(%q<yard>, [">= 0.6.8"])
    else
      s.add_dependency(%q<mysql2>, ["= 0.3.2"])
      s.add_dependency(%q<jeweler>, ["= 1.5.1"])
      s.add_dependency(%q<rspec>, [">= 2.5.0"])
      s.add_dependency(%q<yard>, [">= 0.6.8"])
    end
  else
    s.add_dependency(%q<mysql2>, ["= 0.3.2"])
    s.add_dependency(%q<jeweler>, ["= 1.5.1"])
    s.add_dependency(%q<rspec>, [">= 2.5.0"])
    s.add_dependency(%q<yard>, [">= 0.6.8"])
  end
end
