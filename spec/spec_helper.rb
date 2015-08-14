GEM_ROOT = Pathname.new File.expand_path('../..', __FILE__)
$: << GEM_ROOT.join('lib')

require 'bundler'
Bundler.require
# require GEM_ROOT.join('spec/dummy/config/environment')

Dir[GEM_ROOT.join('spec/fixtures/**/*.rb')].each { |f| require f }

Dir[GEM_ROOT.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # config.before(:suite) { User.delete_all }
end
