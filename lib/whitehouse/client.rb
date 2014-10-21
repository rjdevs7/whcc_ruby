require "faraday"
require "faraday_middleware"
require "whitehouse/error"
require "whitehouse/configurable"
require "whitehouse/authentication"
require "whitehouse/client/catalog"
require "whitehouse/client/order"

module Whitehouse

  # Client for the WHCC API
  #
  # @see https://developers.whcc.com
  class Client

    include Whitehouse::Configurable
    include Whitehouse::Authentication
    include Whitehouse::Client::Catalog
    include Whitehouse::Client::Order

    def initialize(options = {})
      Whitehouse::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Whitehouse.instance_variable_get(:"@#{key}"))
      end
    end

    def connection
      @connection || init_connection(:oauth2)
    end

    # Compares client options to a Hash of requested options
    # 
    # @param opts [Hash] Options to compare with current client options
    # @return [Boolean]
    def same_options?(opts)
      opts.hash == options.hash
    end

    # Text representation of the client, masking tokens
    #
    # @return [String]
    def inspect
      inspected = super

      # Only show last 4 of token, secret
      if @access_token
        inspected = inspected.gsub! @access_token, "#{'*'*8}#{@access_token[8..-1]}"
      end
      if @consumer_secret
        inspected = inspected.gsub! @consumer_secret, "#{'*'*8}#{@consumer_secret[8..-1]}"
      end

      inspected
    end

    def init_connection(oauth = false)
      @connection = Faraday.new(api_endpoint, connection_options) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.request :oauth2, access_token if oauth

        # faraday.response :logger
        faraday.response :mashify
        faraday.response :json, :content_type => /\bjson$/
        # faraday.response :raise_error
        faraday.adapter Faraday.default_adapter
      end
    end
    private :init_connection

  end
end
