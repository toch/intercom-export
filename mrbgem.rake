require_relative 'mrblib/intercom-export/version'

MRuby::Gem::Specification.new('intercom-export') do |spec|
  spec.license = 'MIT'
  spec.author  = 'MRuby Developer'
  spec.summary = 'intercom-export'
  spec.bins    = ['intercom-export']
  spec.version = IntercomExport::Version::VERSION

  spec.add_dependency 'mruby-exit', :core => 'mruby-exit'
  spec.add_dependency 'mruby-print', :core => 'mruby-print'
  spec.add_dependency 'mruby-mtest', :mgem => 'mruby-mtest'
  spec.add_dependency 'mruby-getopts', :mgem => 'mruby-getopts'
  spec.add_dependency 'mruby-polarssl', :git => 'https://github.com/toch/mruby-polarssl.git'
  spec.add_dependency 'mruby-httprequest', :mgem => 'mruby-httprequest'
  spec.add_dependency 'mruby-base64', :mgem => 'mruby-base64'

end
