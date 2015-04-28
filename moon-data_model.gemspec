require_relative 'lib/data_model/version'

Gem::Specification.new do |s|
  s.name        = 'moon-data_model'
  s.summary     = 'Moon DataModel package.'
  s.description = 'Moon DataModel package, extracted the moon-packages.'
  s.homepage    = 'https://github.com/IceDragon200/moon-data_model'
  s.email       = 'mistdragon100@gmail.com'
  s.version     = Moon::DataModel::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now.to_date.to_s
  s.license     = 'MIT'
  s.authors     = ['Blaž Hrastnik', 'Corey Powell']

  s.add_dependency             'rake',          '~> 10.3'
  s.add_dependency             'activesupport', '~> 4.2'
  s.add_dependency             'moon-packages', '~> 0.0'
  s.add_development_dependency 'guard',         '~> 2.12'
  s.add_development_dependency 'guard-rspec',   '~> 4.5'
  s.add_development_dependency 'yard',          '~> 0.8'
  s.add_development_dependency 'rspec',         '~> 3.2'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'simplecov'

  s.require_path = 'lib'
  s.files = []
  s.files += Dir.glob('lib/**/*.{rb,yml}')
  s.files += Dir.glob('spec/**/*')
end
