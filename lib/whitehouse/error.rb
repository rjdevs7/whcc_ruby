module Whitehouse
  class Error < StandardError
    ConfigurationError = Class.new(::ArgumentError)
  end
end
