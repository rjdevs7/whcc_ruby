require "faraday"
require "faraday_middleware"

module Whitehouse
  class Client

    BASE_URI = 'https://apps.whcc.com/api/'
    SANDBOX_URI = 'https://sandbox.apps.whcc.com/api/'

    def initialize(options = {})
      @host = options[:host] || options[:sandbox] ? SANDBOX_URI : BASE_URI
      @consumer_key = options[:consumer_key] || ENV.fetch('WHCC_CONSUMER_KEY') { raise Whitehouse::Error::ConfigurationError, "Missing consumer_key" }
      @consumer_secret = options[:consumer_secret] || ENV.fetch('WHCC_CONSUMER_SECRET') { raise Whitehouse::Error::ConfigurationError, "Missing consumer_secret" }

      init_connection :oauth2
    end

    attr_reader :connection

    def request_catalog
      response = connection.get 'Catalog'
      response.body
    end

    def order_submit
      response = connection.put 'OrderImport'
    end

    def access_token
      @access_token ||= begin
        init_connection unless connection
        response = connection.post 'AccessToken', {grant_type: 'consumer_credentials',
                                                   consumer_key: @consumer_key,
                                                   consumer_secret: @consumer_secret}
        response.body.fetch("Token")
      end
    rescue
      raise Whitehouse::Error, "Failed to authenticate with WHCC. Check your credentials."
    end
    private :access_token

    def init_connection(oauth = false)
      @connection = Faraday.new(@host, headers: {'User-Agent' => user_agent, 'Accept' => 'application/json'}) do |faraday|
        faraday.request :url_encoded
        faraday.request :oauth2, access_token if oauth

        faraday.response :json, :content_type => /\bjson$/
        faraday.response :raise_error
        faraday.adapter Faraday.default_adapter
      end
    end
    private :init_connection

    def user_agent
      @user_agent ||= "Whitehouse Ruby Gem #{Whitehouse::VERSION}"
    end
    private :user_agent

  end
end
