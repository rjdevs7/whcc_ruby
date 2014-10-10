require 'whitehouse/version'

module Whitehouse
  class Default

    # Default API Endpoint
    API_ENDPOINT = 'https://apps.whcc.com/api/'.freeze

    # Default User Agent
    USER_AGENT = "Whitehouse Ruby Gem #{Whitehouse::VERSION}".freeze

    # Default Media Type
    MEDIA_TYPE = "application/json"

    class << self
      # Configuration options
      # @return [Hash]
      def options
        Hash[Whitehouse::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # Default API endpoint from ENV or {API_ENDPOINT}
      # @return [String]
      def api_endpoint
        ENV['WHCC_API_ENDPOINT'] || API_ENDPOINT
      end

      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      def user_agent
        ENV['WHCC_USER_AGENT'] || USER_AGENT
      end

      # Default media type from ENV or {MEDIA_TYPE}
      # @return [String]
      def default_media_type
        ENV['WHCC_DEFAULT_MEDIA_TYPE'] || MEDIA_TYPE
      end

      # Default access token from ENV
      # @return [String]
      def access_token
        ENV['WHCC_ACCESS_TOKEN']
      end

      # Default OAuth app key from ENV
      # @return [String]
      def consumer_key
        ENV['WHCC_CONSUMER_KEY']
      end

      # Default OAuth app secret from ENV
      # @return [String]
      def consumer_secret
        ENV['WHCC_CONSUMER_SECRET']
      end

      # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          :headers => {
            :accept => default_media_type,
            :user_agent => user_agent
          }
        }
      end
    end

  end
end
