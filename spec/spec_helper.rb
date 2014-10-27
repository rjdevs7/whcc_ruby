require 'coveralls'
Coveralls.wear!
require 'pry'
require 'dotenv'
Dotenv.load '.env.test'
require 'whitehouse'
require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

