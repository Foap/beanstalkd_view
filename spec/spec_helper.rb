require 'rubygems'
require 'bundler/setup'

require 'capybara/rspec'

require 'beanstalkd_view'

require "rails_helper"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.dirname(__FILE__)+"/support/**/*.rb"].each  do |f|
  require f
end

#Capybara.default_driver = :selenium
  
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run_excluding :requires_beanstalkd, :requires_two_beanstalkd

  config.before(:each) do      
      requires_two_beanstalkd = example.options[:requires_two_beanstalkd]
      if requires_two_beanstalkd
        ENV['BEANSTALK_URL'] = 'beanstalk://localhost:11300,beanstalk://localhost:11400'
      else
        ENV['BEANSTALK_URL'] = 'beanstalk://localhost:11300'
      end
    end
end



