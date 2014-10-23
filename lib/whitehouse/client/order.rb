require 'tempfile'

module Whitehouse
  class Client

    # Methods for the Order Submit API
    #
    # @see https://developers.whcc.com/API/OrderSubmit/OrderSubmit.aspx
    module Order

      BOUNDARY = "-----------RubyMultipartPost"

      # Submit order
      # @param order [Whitehouse::Order]
      # @return [Integer, false] Confirmation ID of order if successful, otherwise false
      def submit_order(order)
        file = Tempfile.new('entry.json')
        file.write(order.to_json)
        file.close
        response = connection.post 'OrderImport', {entry: Faraday::UploadIO.new(file.path, "application/json")}
        file.unlink
        if response.success?
          response.body.ConfirmationID
        else
          false
        end
      end

      # Confirm order
      # @param [String] The confirmation id received when the order was submitted
      # @return [Boolean] Success
      def confirm_order(confirmation_id)
        # Couldn't get faraday to build this request correctly
        # connection.post "OrderImport/Submit/#{confirmation_id}"
        url = connection.url_prefix + URI.parse("OrderImport/Submit/#{confirmation_id}")

        header = {"Accept" => "application/json", "Content-Type"=> "multipart/form-data; boundary=#{BOUNDARY}"}

        post_body = []
        post_body << "--#{BOUNDARY}\r\n"
        post_body << "Content-Disposition: form-data; name=\"access_token\"\r\n\r\n"
        post_body << access_token
        post_body << "\r\n--#{BOUNDARY}--\r\n"

        # Create the HTTP objects
        request = Net::HTTP::Post.new(url.path, header)
        request.body = post_body.join
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        res = http.request(request)
        body = JSON.parse(res.body)
        return res.is_a?(Net::HTTPSuccess) && !body["ErrorNumber"]
      end

    end
  end
end
