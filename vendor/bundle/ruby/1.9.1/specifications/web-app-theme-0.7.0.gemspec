# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{web-app-theme}
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrea Franz"]
  s.date = %q{2011-07-24}
  s.description = %q{Web app theme generator for rails projects}
  s.email = %q{andrea@gravityblast.com}
  s.files = ["test/spec_helper.rb", "test/themed_generator_spec.rb"]
  s.homepage = %q{http://github.com/pilu/web-app-theme}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Web app theme generator}
  s.test_files = ["test/spec_helper.rb", "test/themed_generator_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
