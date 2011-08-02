# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gmaps4rails}
  s.version = "0.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Benjamin Roth}, %q{David Ruyer}]
  s.date = %q{2011-07-02}
  s.description = %q{Enables easy display of items (taken from a Rails 3 model) on a Google Maps (JS API V3). Geocoding + Directions included. Provides much options: markers customization, infowindows, auto-adjusted zoom, polylines, polygons, circles etc... See wiki on github for full description and examples.}
  s.email = [%q{apnea.diving.deep@gmail.com}, %q{david.ruyer@gmail.com}]
  s.extra_rdoc_files = [%q{LICENSE.txt}, %q{README.rdoc}]
  s.files = [%q{LICENSE.txt}, %q{README.rdoc}]
  s.homepage = %q{http://github.com/apneadiving/Google-Maps-for-Rails}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Enables easy display of items (taken from a Rails 3 model) on a Google Maps (JS API V3). Geocoding + Directions included.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<crack>, [">= 0"])
    else
      s.add_dependency(%q<crack>, [">= 0"])
    end
  else
    s.add_dependency(%q<crack>, [">= 0"])
  end
end
