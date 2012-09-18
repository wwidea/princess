require File.expand_path('../lib/princess/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "princess"
  s.version = Princess::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Jonathan S. Garvin", 'Aaron Baldwin', 'WWIDEA, Inc']
  s.email = ["developers@wwidea.org"]
  s.homepage = "https://github.com/wwidea/princess"
  s.summary = %q{PrinceXML wrapper for Rails}
  s.description = %q{Princess is a Ruby on Rails plugin that wraps Prince [ http://princexml.com ]for easily generating beautiful pdfs using familiar HTML and CSS.}
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]
end