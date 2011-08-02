# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mysql2}
  s.version = "0.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Brian Lopez}]
  s.date = %q{2010-10-19}
  s.email = %q{seniorlopez@gmail.com}
  s.extensions = [%q{ext/mysql2/extconf.rb}]
  s.extra_rdoc_files = [%q{README.rdoc}]
  s.files = [%q{README.rdoc}, %q{ext/mysql2/extconf.rb}]
  s.homepage = %q{http://github.com/brianmario/mysql2}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}, %q{ext}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{A simple, fast Mysql library for Ruby, binding to libmysql}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
