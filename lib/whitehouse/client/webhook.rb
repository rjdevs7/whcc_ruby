module Whitehouse
  class Client

    # Methods for the Request Catalog API
    #
    # @see https://developers.whcc.com/API/OrderSubmit/Webhooks.aspx
    module Webhook

      # Create a callback
      # @param [String] Callback URI
      # @return [Boolean] Success
      def create_webhook(uri)
        response = post 'callback/create', {callbackUri: uri}
        response.body
        response.success? && !response.body.ErrorNumber
      end

      # Verify callback
      # @param [String] Verifier token provided by WHCC POSTing to the callback uri upon creation.
      # @return [Boolean] Success
      def verify_webhook(verifier)
        # This endpoint does not respond with json, so not using faraday connection
        # response = connection.post 'callback/create', {callbackUri: uri}
        # response.body
        # response.success? && !response.body.ErrorNumber

        url = connection.url_prefix + URI.parse("callback/verify")
        header = {"Accept" => "text/xml"}

        # Create the HTTP objects
        request = Net::HTTP::Post.new(url.path, header)
        request.set_form_data(access_token: access_token, verifier: verifier)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        res = http.request(request)
        return res.is_a?(Net::HTTPSuccess) && res.body.scan('Failed').empty?
      end

    end
  end
end
