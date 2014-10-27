module Whitehouse
  module Configurable
    # @!attribute access_token
    #   @return [String] Client access token
    # @!attribute api_endpoint
    #   @return [String] Base URL for API requests. default: https://apps.whcc.com/api
    # @!attribute connection_options
    #   @see https://github.com/lostisland/faraday
    #   @return [Hash] Configure connection options for Faraday
    # @!attribute consumer_key
    #   @return [String] Configure OAuth app key
    # @!attribute [w] consumer_secret
    #   @return [String] Configure OAuth app secret
    # @!attribute default_media_type
    #   @return [String] Configure preferred media type
    # @!attribute user_agent
    #   @return [String] Configure User-Agent header for requests.

    attr_accessor :access_token, :api_endpoint, :connection_options, :consumer_key,
                  :consumer_secret, :default_media_type, :user_agent

    class << self

      # List of configurable keys for {Whitehouse::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
          :access_token,
          :api_endpoint,
          :connection_options,
          :consumer_key,
          :consumer_secret,
          :default_media_type,
          :user_agent
        ]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    # Reset configuration options to default values
    def reset!
      Whitehouse::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Whitehouse::Default.options[key])
      end
      self
    end
    alias setup reset!

    def api_endpoint
      File.join(@api_endpoint, "")
    end

    private

    def options
      Hash[Whitehouse::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

  end

end
