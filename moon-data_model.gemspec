require_relative 'lib/data_model/version'

Gem::Specification.new do |s|
  s.name        = 'moon-data_model'
  s.summary     = 'Moon DataModel package.'
  s.description = 'Moon DataModel package, extracted the moon-packages.'
  s.homepage    = 'https://github.com/polyfox/moon-data_model'
  s.email       = 'mistdragon100@gmail.com'
  s.version     = Moon::DataModel::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now.to_date.to_s
  s.license     = 'MIT'
  s.authors     = ['Blaž Hrastnik', 'Corey Powell']

  s.add_dependency             'activesupport',     '~> 4.2'
  s.add_dependency             'moon-maybe_copy',   ['>= 1.1.1', '~> 1.1']
  s.add_dependency             'moon-serializable', ['>= 1.0.1', '~> 1.0']
  s.add_dependency             'moon-prototype',    ['>= 1.1.1', '~> 1.1']
  s.add_development_dependency 'rake',              '>= 11.0'
  s.add_development_dependency 'yard',              '~> 0.8'
  s.add_development_dependency 'rspec',             '~> 3.2'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'simplecov'

  s.require_path = 'lib'
  s.files = []
  s.files += Dir.glob('lib/**/*.{rb,yml}')
  s.files += Dir.glob('spec/**/*')
end
