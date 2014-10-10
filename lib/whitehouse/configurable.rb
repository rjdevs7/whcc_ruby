module Whitehouse
  module Configurable
    attr_accessor :api_endpoint, :connection_options, :consumer_key,
                  :consumer_secret, :default_media_type, :user_agent

    class << self

      # List of configurable keys for {Whitehouse::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
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
