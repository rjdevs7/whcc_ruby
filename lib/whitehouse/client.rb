require "faraday"
require "faraday_middleware"
require "whitehouse/error"
require "whitehouse/configurable"
require "whitehouse/authentication"
require "whitehouse/client/catalog"
require "whitehouse/client/order"
require "whitehouse/client/webhook"

module Whitehouse

  # Client for the WHCC API
  #
  # @see https://developers.whcc.com
  class Client

    include Whitehouse::Configurable
    include Whitehouse::Authentication
    include Whitehouse::Client::Catalog
    include Whitehouse::Client::Order
    include Whitehouse::Client::Webhook

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

    def get(*args)
      request :get, *args
    end

    def post(*args)
      request :post, *args
    end

    private

    def reset_connection
      @connection = nil
      @access_token = nil
    end

    def request(method, *args)
      tries ||= 2
      response = connection.public_send(method, *args)
      check_errors(response)
      response
    rescue Error::AuthorizationExpired => ex
      reset_connection
      if (tries -= 1) > 0
        retry
      else
        raise ex
      end
    end

    def check_errors(response)
      raise Error, response.status unless response.success?
      raise Error::CODES.fetch(response.body.ErrorNumber, Error), response.body.Message if response.body.ErrorNumber
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

  end
end
