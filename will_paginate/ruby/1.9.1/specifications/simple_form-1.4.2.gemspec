# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simple_form}
  s.version = "1.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{José Valim}, %q{Carlos Antônio}]
  s.date = %q{2011-06-27}
  s.description = %q{Forms made easy!}
  s.email = %q{contact@plataformatec.com.br}
  s.homepage = %q{http://github.com/plataformatec/simple_form}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{simple_form}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Forms made easy!}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activemodel>, ["~> 3.0"])
      s.add_runtime_dependency(%q<actionpack>, ["~> 3.0"])
    else
      s.add_dependency(%q<activemodel>, ["~> 3.0"])
      s.add_dependency(%q<actionpack>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<activemodel>, ["~> 3.0"])
    s.add_dependency(%q<actionpack>, ["~> 3.0"])
  end
end
