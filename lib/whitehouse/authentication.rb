module Whitehouse

  # Methods for the Request Client Access Token API
  #
  # @see https://developers.whcc.com/API/OrderSubmit/RequestToken.aspx
  module Authentication

    def access_token
      @access_token ||= begin
        init_connection unless @connection
        response = @connection.post 'AccessToken', {grant_type: 'consumer_credentials',
                                                   consumer_key: consumer_key,
                                                   consumer_secret: consumer_secret}
        response.body.fetch("Token")
      end
    rescue StandardError => ex
      raise Whitehouse::Error, "Failed to authenticate with WHCC. Check your credentials."
    end
    private :access_token

  end
end
