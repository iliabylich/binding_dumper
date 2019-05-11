if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/support'
  end
end

require 'pathname'
GEM_ROOT = Pathname.new File.expand_path('../..', __FILE__)
$: << GEM_ROOT.join('lib').to_s

require 'bundler'
require GEM_ROOT.join('spec/dummy/config/environment')
require 'rspec/rails'

require GEM_ROOT.join('spec/dummy/db/schema.rb')

Dir[GEM_ROOT.join('spec/fixtures/**/*.rb')].each { |f| require f }

Dir[GEM_ROOT.join('spec/support/**/*.rb')].each { |f| require f }

class ActionDispatch::Response
  def restored_from_binding
    @cv = new_cond
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before :each do
    BindingDumper::UniversalDumper.flush_memories!
  end

  config.before :each, type: :controller do
    User.delete_all
    StoredBinding.delete_all
  end
end
