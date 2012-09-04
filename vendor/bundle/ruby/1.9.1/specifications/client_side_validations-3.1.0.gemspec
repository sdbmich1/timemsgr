# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{client_side_validations}
  s.version = "3.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Cardarella"]
  s.date = %q{2011-06-20}
  s.description = %q{Client Side Validations}
  s.email = ["bcardarella@gmail.com"]
  s.files = ["test/action_view/cases/helper.rb", "test/action_view/cases/test_helpers.rb", "test/action_view/cases/test_legacy_helpers.rb", "test/action_view/models.rb", "test/action_view/models/comment.rb", "test/action_view/models/post.rb", "test/active_model/cases/helper.rb", "test/active_model/cases/test_acceptance_validator.rb", "test/active_model/cases/test_base.rb", "test/active_model/cases/test_confirmation_validator.rb", "test/active_model/cases/test_exclusion_validator.rb", "test/active_model/cases/test_format_validator.rb", "test/active_model/cases/test_inclusion_validator.rb", "test/active_model/cases/test_length_validator.rb", "test/active_model/cases/test_numericality_validator.rb", "test/active_model/cases/test_presence_validator.rb", "test/active_model/cases/test_validations.rb", "test/active_model/models/person.rb", "test/active_record/cases/helper.rb", "test/active_record/cases/test_base.rb", "test/active_record/cases/test_middleware.rb", "test/active_record/cases/test_uniqueness_validator.rb", "test/active_record/models/guid.rb", "test/active_record/models/user.rb", "test/base_helper.rb", "test/core_ext/cases/test_core_ext.rb", "test/formtastic/cases/helper.rb", "test/formtastic/cases/test_form_builder.rb", "test/formtastic/cases/test_form_helper.rb", "test/generators/cases/test_generators.rb", "test/javascript/config.ru", "test/javascript/public/test/callbacks/elementAfter.js", "test/javascript/public/test/callbacks/elementBefore.js", "test/javascript/public/test/callbacks/elementFail.js", "test/javascript/public/test/callbacks/elementPass.js", "test/javascript/public/test/callbacks/formAfter.js", "test/javascript/public/test/callbacks/formBefore.js", "test/javascript/public/test/callbacks/formFail.js", "test/javascript/public/test/callbacks/formPass.js", "test/javascript/public/test/form_builders/validateForm.js", "test/javascript/public/test/form_builders/validateFormtastic.js", "test/javascript/public/test/form_builders/validateNestedForm.js", "test/javascript/public/test/form_builders/validateSimpleForm.js", "test/javascript/public/test/settings.js", "test/javascript/public/test/validateElement.js", "test/javascript/public/test/validators/acceptance.js", "test/javascript/public/test/validators/confirmation.js", "test/javascript/public/test/validators/exclusion.js", "test/javascript/public/test/validators/format.js", "test/javascript/public/test/validators/inclusion.js", "test/javascript/public/test/validators/length.js", "test/javascript/public/test/validators/numericality.js", "test/javascript/public/test/validators/presence.js", "test/javascript/public/test/validators/uniqueness.js", "test/javascript/public/vendor/jquery.metadata.js", "test/javascript/public/vendor/qunit.css", "test/javascript/public/vendor/qunit.js", "test/javascript/server.rb", "test/javascript/views/index.erb", "test/javascript/views/layout.erb", "test/middleware/cases/helper.rb", "test/middleware/cases/test_middleware.rb", "test/mongo_mapper/cases/helper.rb", "test/mongo_mapper/cases/test_base.rb", "test/mongo_mapper/cases/test_middleware.rb", "test/mongo_mapper/cases/test_uniqueness_validator.rb", "test/mongo_mapper/models/magazine.rb", "test/mongoid/cases/helper.rb", "test/mongoid/cases/test_base.rb", "test/mongoid/cases/test_middleware.rb", "test/mongoid/cases/test_uniqueness_validator.rb", "test/mongoid/models/book.rb", "test/simple_form/cases/helper.rb", "test/simple_form/cases/test_form_builder.rb", "test/simple_form/cases/test_form_helper.rb", "test/test_loader.rb"]
  s.homepage = %q{https://github.com/bcardarella/client_side_validations}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Client Side Validations}
  s.test_files = ["test/action_view/cases/helper.rb", "test/action_view/cases/test_helpers.rb", "test/action_view/cases/test_legacy_helpers.rb", "test/action_view/models.rb", "test/action_view/models/comment.rb", "test/action_view/models/post.rb", "test/active_model/cases/helper.rb", "test/active_model/cases/test_acceptance_validator.rb", "test/active_model/cases/test_base.rb", "test/active_model/cases/test_confirmation_validator.rb", "test/active_model/cases/test_exclusion_validator.rb", "test/active_model/cases/test_format_validator.rb", "test/active_model/cases/test_inclusion_validator.rb", "test/active_model/cases/test_length_validator.rb", "test/active_model/cases/test_numericality_validator.rb", "test/active_model/cases/test_presence_validator.rb", "test/active_model/cases/test_validations.rb", "test/active_model/models/person.rb", "test/active_record/cases/helper.rb", "test/active_record/cases/test_base.rb", "test/active_record/cases/test_middleware.rb", "test/active_record/cases/test_uniqueness_validator.rb", "test/active_record/models/guid.rb", "test/active_record/models/user.rb", "test/base_helper.rb", "test/core_ext/cases/test_core_ext.rb", "test/formtastic/cases/helper.rb", "test/formtastic/cases/test_form_builder.rb", "test/formtastic/cases/test_form_helper.rb", "test/generators/cases/test_generators.rb", "test/javascript/config.ru", "test/javascript/public/test/callbacks/elementAfter.js", "test/javascript/public/test/callbacks/elementBefore.js", "test/javascript/public/test/callbacks/elementFail.js", "test/javascript/public/test/callbacks/elementPass.js", "test/javascript/public/test/callbacks/formAfter.js", "test/javascript/public/test/callbacks/formBefore.js", "test/javascript/public/test/callbacks/formFail.js", "test/javascript/public/test/callbacks/formPass.js", "test/javascript/public/test/form_builders/validateForm.js", "test/javascript/public/test/form_builders/validateFormtastic.js", "test/javascript/public/test/form_builders/validateNestedForm.js", "test/javascript/public/test/form_builders/validateSimpleForm.js", "test/javascript/public/test/settings.js", "test/javascript/public/test/validateElement.js", "test/javascript/public/test/validators/acceptance.js", "test/javascript/public/test/validators/confirmation.js", "test/javascript/public/test/validators/exclusion.js", "test/javascript/public/test/validators/format.js", "test/javascript/public/test/validators/inclusion.js", "test/javascript/public/test/validators/length.js", "test/javascript/public/test/validators/numericality.js", "test/javascript/public/test/validators/presence.js", "test/javascript/public/test/validators/uniqueness.js", "test/javascript/public/vendor/jquery.metadata.js", "test/javascript/public/vendor/qunit.css", "test/javascript/public/vendor/qunit.js", "test/javascript/server.rb", "test/javascript/views/index.erb", "test/javascript/views/layout.erb", "test/middleware/cases/helper.rb", "test/middleware/cases/test_middleware.rb", "test/mongo_mapper/cases/helper.rb", "test/mongo_mapper/cases/test_base.rb", "test/mongo_mapper/cases/test_middleware.rb", "test/mongo_mapper/cases/test_uniqueness_validator.rb", "test/mongo_mapper/models/magazine.rb", "test/mongoid/cases/helper.rb", "test/mongoid/cases/test_base.rb", "test/mongoid/cases/test_middleware.rb", "test/mongoid/cases/test_uniqueness_validator.rb", "test/mongoid/models/book.rb", "test/simple_form/cases/helper.rb", "test/simple_form/cases/test_form_builder.rb", "test/simple_form/cases/test_form_helper.rb", "test/test_loader.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rails>, ["= 3.1.0.rc4"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<bson_ext>, [">= 0"])
      s.add_development_dependency(%q<mongoid>, ["~> 2.0.0"])
      s.add_development_dependency(%q<mongo_mapper>, ["~> 0.9.0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<simple_form>, [">= 0"])
      s.add_development_dependency(%q<formtastic>, ["~> 2.0.0.rc3"])
      s.add_development_dependency(%q<sinatra>, ["~> 1.0"])
      s.add_development_dependency(%q<shotgun>, [">= 0"])
      s.add_development_dependency(%q<thin>, [">= 0"])
      s.add_development_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug19>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["= 3.1.0.rc4"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<bson_ext>, [">= 0"])
      s.add_dependency(%q<mongoid>, ["~> 2.0.0"])
      s.add_dependency(%q<mongo_mapper>, ["~> 0.9.0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<simple_form>, [">= 0"])
      s.add_dependency(%q<formtastic>, ["~> 2.0.0.rc3"])
      s.add_dependency(%q<sinatra>, ["~> 1.0"])
      s.add_dependency(%q<shotgun>, [">= 0"])
      s.add_dependency(%q<thin>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<ruby-debug19>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["= 3.1.0.rc4"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<bson_ext>, [">= 0"])
    s.add_dependency(%q<mongoid>, ["~> 2.0.0"])
    s.add_dependency(%q<mongo_mapper>, ["~> 0.9.0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<simple_form>, [">= 0"])
    s.add_dependency(%q<formtastic>, ["~> 2.0.0.rc3"])
    s.add_dependency(%q<sinatra>, ["~> 1.0"])
    s.add_dependency(%q<shotgun>, [">= 0"])
    s.add_dependency(%q<thin>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<ruby-debug19>, [">= 0"])
  end
end
