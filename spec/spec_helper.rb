$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require_relative('../lib/frest/setup.rb')
Frest::Setup::setup

require 'frest'
