module Whitehouse
  class Client

    # Methods for the Request Catalog API
    #
    # @see https://developers.whcc.com/API/OrderSubmit/RequestCatalog.aspx
    module Catalog

      # List entire catalog for account
      def request_catalog
        response = connection.get 'Catalog'
        response.body
      end

    end
  end
end
