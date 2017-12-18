require "bundler/setup"
require "cov_helper"
require "coveralls"; Coveralls.wear!
require "seb_elink"
require "pry"

Dir[SebElink.root.join('spec/support/**/*.rb')].each { |file| require file }

RSpec.configure do |config|
  config.include GeneralHelpers

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
