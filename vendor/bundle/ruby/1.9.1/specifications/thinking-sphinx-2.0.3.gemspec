# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{thinking-sphinx}
  s.version = "2.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Allan"]
  s.date = %q{2011-04-02}
  s.description = %q{A concise and easy-to-use Ruby library that connects ActiveRecord to the Sphinx search daemon, managing configuration, indexing and searching.}
  s.email = %q{pat@freelancing-gods.com}
  s.files = ["features/abstract_inheritance.feature", "features/alternate_primary_key.feature", "features/attribute_transformation.feature", "features/attribute_updates.feature", "features/deleting_instances.feature", "features/direct_attributes.feature", "features/excerpts.feature", "features/extensible_delta_indexing.feature", "features/facets.feature", "features/facets_across_model.feature", "features/field_sorting.feature", "features/handling_edits.feature", "features/retry_stale_indexes.feature", "features/searching_across_models.feature", "features/searching_by_index.feature", "features/searching_by_model.feature", "features/searching_with_find_arguments.feature", "features/sphinx_detection.feature", "features/sphinx_scopes.feature", "features/step_definitions/alpha_steps.rb", "features/step_definitions/beta_steps.rb", "features/step_definitions/common_steps.rb", "features/step_definitions/extensible_delta_indexing_steps.rb", "features/step_definitions/facet_steps.rb", "features/step_definitions/find_arguments_steps.rb", "features/step_definitions/gamma_steps.rb", "features/step_definitions/scope_steps.rb", "features/step_definitions/search_steps.rb", "features/step_definitions/sphinx_steps.rb", "features/sti_searching.feature", "features/support/env.rb", "features/support/lib/generic_delta_handler.rb", "features/thinking_sphinx/database.example.yml", "features/thinking_sphinx/db/fixtures/alphas.rb", "features/thinking_sphinx/db/fixtures/authors.rb", "features/thinking_sphinx/db/fixtures/betas.rb", "features/thinking_sphinx/db/fixtures/boxes.rb", "features/thinking_sphinx/db/fixtures/categories.rb", "features/thinking_sphinx/db/fixtures/cats.rb", "features/thinking_sphinx/db/fixtures/comments.rb", "features/thinking_sphinx/db/fixtures/developers.rb", "features/thinking_sphinx/db/fixtures/dogs.rb", "features/thinking_sphinx/db/fixtures/extensible_betas.rb", "features/thinking_sphinx/db/fixtures/foxes.rb", "features/thinking_sphinx/db/fixtures/gammas.rb", "features/thinking_sphinx/db/fixtures/music.rb", "features/thinking_sphinx/db/fixtures/people.rb", "features/thinking_sphinx/db/fixtures/posts.rb", "features/thinking_sphinx/db/fixtures/robots.rb", "features/thinking_sphinx/db/fixtures/tags.rb", "features/thinking_sphinx/db/migrations/create_alphas.rb", "features/thinking_sphinx/db/migrations/create_animals.rb", "features/thinking_sphinx/db/migrations/create_authors.rb", "features/thinking_sphinx/db/migrations/create_authors_posts.rb", "features/thinking_sphinx/db/migrations/create_betas.rb", "features/thinking_sphinx/db/migrations/create_boxes.rb", "features/thinking_sphinx/db/migrations/create_categories.rb", "features/thinking_sphinx/db/migrations/create_comments.rb", "features/thinking_sphinx/db/migrations/create_developers.rb", "features/thinking_sphinx/db/migrations/create_extensible_betas.rb", "features/thinking_sphinx/db/migrations/create_gammas.rb", "features/thinking_sphinx/db/migrations/create_genres.rb", "features/thinking_sphinx/db/migrations/create_music.rb", "features/thinking_sphinx/db/migrations/create_people.rb", "features/thinking_sphinx/db/migrations/create_posts.rb", "features/thinking_sphinx/db/migrations/create_robots.rb", "features/thinking_sphinx/db/migrations/create_taggings.rb", "features/thinking_sphinx/db/migrations/create_tags.rb", "features/thinking_sphinx/models/alpha.rb", "features/thinking_sphinx/models/andrew.rb", "features/thinking_sphinx/models/animal.rb", "features/thinking_sphinx/models/author.rb", "features/thinking_sphinx/models/beta.rb", "features/thinking_sphinx/models/box.rb", "features/thinking_sphinx/models/cat.rb", "features/thinking_sphinx/models/category.rb", "features/thinking_sphinx/models/comment.rb", "features/thinking_sphinx/models/developer.rb", "features/thinking_sphinx/models/dog.rb", "features/thinking_sphinx/models/extensible_beta.rb", "features/thinking_sphinx/models/fox.rb", "features/thinking_sphinx/models/gamma.rb", "features/thinking_sphinx/models/genre.rb", "features/thinking_sphinx/models/medium.rb", "features/thinking_sphinx/models/music.rb", "features/thinking_sphinx/models/person.rb", "features/thinking_sphinx/models/post.rb", "features/thinking_sphinx/models/robot.rb", "features/thinking_sphinx/models/tag.rb", "features/thinking_sphinx/models/tagging.rb", "spec/thinking_sphinx/active_record/delta_spec.rb", "spec/thinking_sphinx/active_record/has_many_association_spec.rb", "spec/thinking_sphinx/active_record/scopes_spec.rb", "spec/thinking_sphinx/active_record_spec.rb", "spec/thinking_sphinx/adapters/abstract_adapter_spec.rb", "spec/thinking_sphinx/association_spec.rb", "spec/thinking_sphinx/attribute_spec.rb", "spec/thinking_sphinx/auto_version_spec.rb", "spec/thinking_sphinx/configuration_spec.rb", "spec/thinking_sphinx/context_spec.rb", "spec/thinking_sphinx/core/array_spec.rb", "spec/thinking_sphinx/core/string_spec.rb", "spec/thinking_sphinx/excerpter_spec.rb", "spec/thinking_sphinx/facet_search_spec.rb", "spec/thinking_sphinx/facet_spec.rb", "spec/thinking_sphinx/field_spec.rb", "spec/thinking_sphinx/index/builder_spec.rb", "spec/thinking_sphinx/index/faux_column_spec.rb", "spec/thinking_sphinx/index_spec.rb", "spec/thinking_sphinx/search_methods_spec.rb", "spec/thinking_sphinx/search_spec.rb", "spec/thinking_sphinx/source_spec.rb", "spec/thinking_sphinx/test_spec.rb", "spec/thinking_sphinx_spec.rb"]
  s.homepage = %q{http://ts.freelancing-gods.com}
  s.post_install_message = %q{If you're upgrading, you should read this:
http://freelancing-god.github.com/ts/en/upgrading.html

}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{ActiveRecord/Rails Sphinx library}
  s.test_files = ["features/abstract_inheritance.feature", "features/alternate_primary_key.feature", "features/attribute_transformation.feature", "features/attribute_updates.feature", "features/deleting_instances.feature", "features/direct_attributes.feature", "features/excerpts.feature", "features/extensible_delta_indexing.feature", "features/facets.feature", "features/facets_across_model.feature", "features/field_sorting.feature", "features/handling_edits.feature", "features/retry_stale_indexes.feature", "features/searching_across_models.feature", "features/searching_by_index.feature", "features/searching_by_model.feature", "features/searching_with_find_arguments.feature", "features/sphinx_detection.feature", "features/sphinx_scopes.feature", "features/step_definitions/alpha_steps.rb", "features/step_definitions/beta_steps.rb", "features/step_definitions/common_steps.rb", "features/step_definitions/extensible_delta_indexing_steps.rb", "features/step_definitions/facet_steps.rb", "features/step_definitions/find_arguments_steps.rb", "features/step_definitions/gamma_steps.rb", "features/step_definitions/scope_steps.rb", "features/step_definitions/search_steps.rb", "features/step_definitions/sphinx_steps.rb", "features/sti_searching.feature", "features/support/env.rb", "features/support/lib/generic_delta_handler.rb", "features/thinking_sphinx/database.example.yml", "features/thinking_sphinx/db/fixtures/alphas.rb", "features/thinking_sphinx/db/fixtures/authors.rb", "features/thinking_sphinx/db/fixtures/betas.rb", "features/thinking_sphinx/db/fixtures/boxes.rb", "features/thinking_sphinx/db/fixtures/categories.rb", "features/thinking_sphinx/db/fixtures/cats.rb", "features/thinking_sphinx/db/fixtures/comments.rb", "features/thinking_sphinx/db/fixtures/developers.rb", "features/thinking_sphinx/db/fixtures/dogs.rb", "features/thinking_sphinx/db/fixtures/extensible_betas.rb", "features/thinking_sphinx/db/fixtures/foxes.rb", "features/thinking_sphinx/db/fixtures/gammas.rb", "features/thinking_sphinx/db/fixtures/music.rb", "features/thinking_sphinx/db/fixtures/people.rb", "features/thinking_sphinx/db/fixtures/posts.rb", "features/thinking_sphinx/db/fixtures/robots.rb", "features/thinking_sphinx/db/fixtures/tags.rb", "features/thinking_sphinx/db/migrations/create_alphas.rb", "features/thinking_sphinx/db/migrations/create_animals.rb", "features/thinking_sphinx/db/migrations/create_authors.rb", "features/thinking_sphinx/db/migrations/create_authors_posts.rb", "features/thinking_sphinx/db/migrations/create_betas.rb", "features/thinking_sphinx/db/migrations/create_boxes.rb", "features/thinking_sphinx/db/migrations/create_categories.rb", "features/thinking_sphinx/db/migrations/create_comments.rb", "features/thinking_sphinx/db/migrations/create_developers.rb", "features/thinking_sphinx/db/migrations/create_extensible_betas.rb", "features/thinking_sphinx/db/migrations/create_gammas.rb", "features/thinking_sphinx/db/migrations/create_genres.rb", "features/thinking_sphinx/db/migrations/create_music.rb", "features/thinking_sphinx/db/migrations/create_people.rb", "features/thinking_sphinx/db/migrations/create_posts.rb", "features/thinking_sphinx/db/migrations/create_robots.rb", "features/thinking_sphinx/db/migrations/create_taggings.rb", "features/thinking_sphinx/db/migrations/create_tags.rb", "features/thinking_sphinx/models/alpha.rb", "features/thinking_sphinx/models/andrew.rb", "features/thinking_sphinx/models/animal.rb", "features/thinking_sphinx/models/author.rb", "features/thinking_sphinx/models/beta.rb", "features/thinking_sphinx/models/box.rb", "features/thinking_sphinx/models/cat.rb", "features/thinking_sphinx/models/category.rb", "features/thinking_sphinx/models/comment.rb", "features/thinking_sphinx/models/developer.rb", "features/thinking_sphinx/models/dog.rb", "features/thinking_sphinx/models/extensible_beta.rb", "features/thinking_sphinx/models/fox.rb", "features/thinking_sphinx/models/gamma.rb", "features/thinking_sphinx/models/genre.rb", "features/thinking_sphinx/models/medium.rb", "features/thinking_sphinx/models/music.rb", "features/thinking_sphinx/models/person.rb", "features/thinking_sphinx/models/post.rb", "features/thinking_sphinx/models/robot.rb", "features/thinking_sphinx/models/tag.rb", "features/thinking_sphinx/models/tagging.rb", "spec/thinking_sphinx/active_record/delta_spec.rb", "spec/thinking_sphinx/active_record/has_many_association_spec.rb", "spec/thinking_sphinx/active_record/scopes_spec.rb", "spec/thinking_sphinx/active_record_spec.rb", "spec/thinking_sphinx/adapters/abstract_adapter_spec.rb", "spec/thinking_sphinx/association_spec.rb", "spec/thinking_sphinx/attribute_spec.rb", "spec/thinking_sphinx/auto_version_spec.rb", "spec/thinking_sphinx/configuration_spec.rb", "spec/thinking_sphinx/context_spec.rb", "spec/thinking_sphinx/core/array_spec.rb", "spec/thinking_sphinx/core/string_spec.rb", "spec/thinking_sphinx/excerpter_spec.rb", "spec/thinking_sphinx/facet_search_spec.rb", "spec/thinking_sphinx/facet_spec.rb", "spec/thinking_sphinx/field_spec.rb", "spec/thinking_sphinx/index/builder_spec.rb", "spec/thinking_sphinx/index/faux_column_spec.rb", "spec/thinking_sphinx/index_spec.rb", "spec/thinking_sphinx/search_methods_spec.rb", "spec/thinking_sphinx/search_spec.rb", "spec/thinking_sphinx/source_spec.rb", "spec/thinking_sphinx/test_spec.rb", "spec/thinking_sphinx_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0.3"])
      s.add_runtime_dependency(%q<riddle>, [">= 1.2.2"])
      s.add_development_dependency(%q<mysql>, ["= 2.8.1"])
      s.add_development_dependency(%q<pg>, ["= 0.9.0"])
      s.add_development_dependency(%q<actionpack>, [">= 3.0.3"])
      s.add_development_dependency(%q<jeweler>, ["= 1.5.1"])
      s.add_development_dependency(%q<yard>, ["= 0.6.1"])
      s.add_development_dependency(%q<rspec>, ["= 2.0.1"])
      s.add_development_dependency(%q<rspec-core>, ["= 2.0.1"])
      s.add_development_dependency(%q<rspec-expectations>, ["= 2.0.1"])
      s.add_development_dependency(%q<rspec-mocks>, ["= 2.0.1"])
      s.add_development_dependency(%q<rcov>, ["= 0.9.8"])
      s.add_development_dependency(%q<cucumber>, ["= 0.9.4"])
      s.add_development_dependency(%q<will_paginate>, ["= 3.0.pre"])
      s.add_development_dependency(%q<ginger>, ["= 1.2.0"])
      s.add_development_dependency(%q<faker>, ["= 0.3.1"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.0.3"])
      s.add_dependency(%q<riddle>, [">= 1.2.2"])
      s.add_dependency(%q<mysql>, ["= 2.8.1"])
      s.add_dependency(%q<pg>, ["= 0.9.0"])
      s.add_dependency(%q<actionpack>, [">= 3.0.3"])
      s.add_dependency(%q<jeweler>, ["= 1.5.1"])
      s.add_dependency(%q<yard>, ["= 0.6.1"])
      s.add_dependency(%q<rspec>, ["= 2.0.1"])
      s.add_dependency(%q<rspec-core>, ["= 2.0.1"])
      s.add_dependency(%q<rspec-expectations>, ["= 2.0.1"])
      s.add_dependency(%q<rspec-mocks>, ["= 2.0.1"])
      s.add_dependency(%q<rcov>, ["= 0.9.8"])
      s.add_dependency(%q<cucumber>, ["= 0.9.4"])
      s.add_dependency(%q<will_paginate>, ["= 3.0.pre"])
      s.add_dependency(%q<ginger>, ["= 1.2.0"])
      s.add_dependency(%q<faker>, ["= 0.3.1"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.0.3"])
    s.add_dependency(%q<riddle>, [">= 1.2.2"])
    s.add_dependency(%q<mysql>, ["= 2.8.1"])
    s.add_dependency(%q<pg>, ["= 0.9.0"])
    s.add_dependency(%q<actionpack>, [">= 3.0.3"])
    s.add_dependency(%q<jeweler>, ["= 1.5.1"])
    s.add_dependency(%q<yard>, ["= 0.6.1"])
    s.add_dependency(%q<rspec>, ["= 2.0.1"])
    s.add_dependency(%q<rspec-core>, ["= 2.0.1"])
    s.add_dependency(%q<rspec-expectations>, ["= 2.0.1"])
    s.add_dependency(%q<rspec-mocks>, ["= 2.0.1"])
    s.add_dependency(%q<rcov>, ["= 0.9.8"])
    s.add_dependency(%q<cucumber>, ["= 0.9.4"])
    s.add_dependency(%q<will_paginate>, ["= 3.0.pre"])
    s.add_dependency(%q<ginger>, ["= 1.2.0"])
    s.add_dependency(%q<faker>, ["= 0.3.1"])
  end
end
