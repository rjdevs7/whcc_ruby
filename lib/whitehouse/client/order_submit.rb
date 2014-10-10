module Whitehouse
  class Client
    module OrderSubmit

      def order_submit
        response = connection.put 'OrderImport'
      end

    end
  end
end
