Encoding.default_internal = Encoding.default_external = 'UTF-8'

require 'codeclimate-test-reporter'
require 'simplecov'
require 'active_support/core_ext/string'

CodeClimate::TestReporter.start
SimpleCov.start

require 'data_model/load'

require 'fixtures/validators'
require 'fixtures/models'
