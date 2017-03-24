# frozen_string_literal: true
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'artsy-eventservice/version'

Gem::Specification.new do |s|
  s.name = 'artsy-eventservice'
  s.version = Artsy::EventService::VERSION
  s.authors = ['Ashkan Nasseri']
  s.email = 'ashkan.nasseri@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = '>= 1.3.6'
  s.files = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.homepage = 'http://github.com/artsy/artsy-eventservice'
  s.licenses = ['MIT']
  s.summary = "Ruby Gem for producing events in Artsy's event stream"
  s.add_dependency 'bunny', '~> 2.6.2'
end
