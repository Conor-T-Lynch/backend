#Sets up the rails environment variable to test
ENV["RAILS_ENV"] ||= "test"
#Load the rails application environment for the test environment
require_relative "../config/environment"
#Include the rails test helpers for testing
require "rails/test_help"
#Module that extends ActiveSupport's TestCase to customize testing behavior
module ActiveSupport
  class TestCase
    #Configur tests to run in parallel, using one worker per processor and threads
    parallelize(workers: :number_of_processors, with: :threads)
    #Load all fixture files
    fixtures :all
  end
end
