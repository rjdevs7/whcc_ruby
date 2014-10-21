require 'tempfile'

module Whitehouse
  class Client

    # Methods for the Order Submit API
    #
    # @see https://developers.whcc.com/API/OrderSubmit/OrderSubmit.aspx
    module Order

      def submit_order(order)
        file = Tempfile.new('entry.json')
        file.write(order.to_json)
        file.close
        response = connection.post 'OrderImport', {entry: Faraday::UploadIO.new(file.path, "application/json")}
        file.unlink
        response
      end

      def confirm_order(confirmation_id)
        connection.post "OrderImport/Submit/#{confirmation_id}"
      end

    end
  end
end
