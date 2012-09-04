# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rails3-jquery-autocomplete}
  s.version = "0.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Padilla"]
  s.date = %q{2011-07-07}
  s.description = %q{Use jQuery's autocomplete plugin with Rails 3.}
  s.email = %q{david.padilla@crowdint.com}
  s.files = ["test/form_helper_test.rb", "test/generators/autocomplete/install_generator_test.rb", "test/generators/autocomplete/uncompressed_generator_test.rb", "test/lib/rails3-jquery-autocomplete/autocomplete_test.rb", "test/lib/rails3-jquery-autocomplete/orm/active_record_test.rb", "test/lib/rails3-jquery-autocomplete/orm/mongo_mapper_test.rb", "test/lib/rails3-jquery-autocomplete/orm/mongoid_test.rb", "test/lib/rails3-jquery-autocomplete_test.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/crowdint/rails3-jquery-autocomplete}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Use jQuery's autocomplete plugin with Rails 3.}
  s.test_files = ["test/form_helper_test.rb", "test/generators/autocomplete/install_generator_test.rb", "test/generators/autocomplete/uncompressed_generator_test.rb", "test/lib/rails3-jquery-autocomplete/autocomplete_test.rb", "test/lib/rails3-jquery-autocomplete/orm/active_record_test.rb", "test/lib/rails3-jquery-autocomplete/orm/mongo_mapper_test.rb", "test/lib/rails3-jquery-autocomplete/orm/mongoid_test.rb", "test/lib/rails3-jquery-autocomplete_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.0"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_development_dependency(%q<mongoid>, [">= 2.0.0"])
      s.add_development_dependency(%q<mongo_mapper>, [">= 0.9"])
      s.add_development_dependency(%q<bson_ext>, ["~> 1.3.0"])
      s.add_development_dependency(%q<shoulda>, ["~> 2.11.1"])
      s.add_development_dependency(%q<uglifier>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["~> 3.0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_dependency(%q<mongoid>, [">= 2.0.0"])
      s.add_dependency(%q<mongo_mapper>, [">= 0.9"])
      s.add_dependency(%q<bson_ext>, ["~> 1.3.0"])
      s.add_dependency(%q<shoulda>, ["~> 2.11.1"])
      s.add_dependency(%q<uglifier>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    s.add_dependency(%q<mongoid>, [">= 2.0.0"])
    s.add_dependency(%q<mongo_mapper>, [">= 0.9"])
    s.add_dependency(%q<bson_ext>, ["~> 1.3.0"])
    s.add_dependency(%q<shoulda>, ["~> 2.11.1"])
    s.add_dependency(%q<uglifier>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end
