# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nokogiri}
  s.version = "1.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Aaron Patterson}, %q{Mike Dalessio}]
  s.cert_chain = [%q{-----BEGIN CERTIFICATE-----
MIIDNjCCAh6gAwIBAgIBADANBgkqhkiG9w0BAQUFADBBMQ8wDQYDVQQDDAZhYXJv
bnAxGTAXBgoJkiaJk/IsZAEZFglydWJ5Zm9yZ2UxEzARBgoJkiaJk/IsZAEZFgNv
cmcwHhcNMDkxMTA1MDAwNDQ4WhcNMTAxMTA1MDAwNDQ4WjBBMQ8wDQYDVQQDDAZh
YXJvbnAxGTAXBgoJkiaJk/IsZAEZFglydWJ5Zm9yZ2UxEzARBgoJkiaJk/IsZAEZ
FgNvcmcwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDNSD14Gb2mCX/5
fE85uW/jT7fcYI8XolrzdpzfvxD3y+Pt/yA5eciBiE+hNAWU2PM1ZMOq4MOV9EqR
hYzupp/zFoC7ZZ3PF8nJBFKgfKNf0sp9o3XCUviaZjoSYNIvGQocrakQo+h3x3Od
NqZWtVsLz9P/G1foUBpc95gGGBodbj/CZVc32F+xVvmejqe3RaMLGI70ZOuTcsRi
t8V4T7okmUbLi6VmPYlH/9mKvU7ObRHXMYNhkkife5phh8vjsiCd8Q397+jFaL0f
Cd23idNV7lbvdjIuYLV+9u5cPkDjANLAnGRaRS1x2SEfH/8g0Te6/jeKfzBH83D0
5v5HTx+HAgMBAAGjOTA3MAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdDgQW
BBTs3LnPhoi2m7BTf9tHvNQYsOG7aTANBgkqhkiG9w0BAQUFAAOCAQEAVH7G+nSf
WMPz7Iwcnd+WrWWq/mr5ke0qQoiz4tk0h7bsa3fEnUDBiMfmQhv/uBzA4Gkw9zxB
IfKljsZq0yE+du/1u2Mph7dMIg2oiwMurpduPpx9sfaqsqSBBOzggxiUEmHDNrPT
uTzaid0gdOx/TacZ4RwrEnx6XNkhxC2YaTH2Y68hoJzSzRGtdU2Kk6mT4YraCP+u
ETP5hCJAiB5l4jC8U6wwvKQDHTMoaUu3eu/txe1PDjoe3GICzs/e6bzYBWYmKu7J
5YM3l5J4rDvIPAGH4VRr5nSs+qbZh+kCdE1khvTxH51xkR3qAfEEogAd2VlnjELM
f9Gw8x3RwgLvkA==
-----END CERTIFICATE-----
}]
  s.date = %q{2009-12-10}
  s.description = %q{Nokogiri (鋸) is an HTML, XML, SAX, and Reader parser.  Among Nokogiri's
many features is the ability to search documents via XPath or CSS3 selectors.

XML is like violence - if it doesn’t solve your problems, you are not using
enough of it.}
  s.email = [%q{aaronp@rubyforge.org}, %q{mike.dalessio@gmail.com}]
  s.executables = [%q{nokogiri}]
  s.extensions = [%q{ext/nokogiri/extconf.rb}]
  s.extra_rdoc_files = [%q{Manifest.txt}, %q{CHANGELOG.ja.rdoc}, %q{CHANGELOG.rdoc}, %q{README.ja.rdoc}, %q{README.rdoc}]
  s.files = [%q{bin/nokogiri}, %q{Manifest.txt}, %q{CHANGELOG.ja.rdoc}, %q{CHANGELOG.rdoc}, %q{README.ja.rdoc}, %q{README.rdoc}, %q{ext/nokogiri/extconf.rb}]
  s.homepage = %q{http://nokogiri.org}
  s.rdoc_options = [%q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}, %q{ext}]
  s.rubyforge_project = %q{nokogiri}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Nokogiri (鋸) is an HTML, XML, SAX, and Reader parser}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<racc>, [">= 0"])
      s.add_development_dependency(%q<rexical>, [">= 0"])
      s.add_development_dependency(%q<rake-compiler>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<racc>, [">= 0"])
      s.add_dependency(%q<rexical>, [">= 0"])
      s.add_dependency(%q<rake-compiler>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<racc>, [">= 0"])
    s.add_dependency(%q<rexical>, [">= 0"])
    s.add_dependency(%q<rake-compiler>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
