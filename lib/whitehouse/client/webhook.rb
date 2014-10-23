module Whitehouse
  class Client

    # Methods for the Request Catalog API
    #
    # @see https://developers.whcc.com/API/OrderSubmit/Webhooks.aspx
    module Webhook

      # Create a callback
      def create_webhook(uri)
        response = connection.post 'callback/create', {callbackUri: uri}
        response.body
      end

      # Verify callback
      def verify_webhook(verifier)
        response = connection.post 'callback/verify', {verifier: verifier}
        response.body
      end

    end
  end
end
