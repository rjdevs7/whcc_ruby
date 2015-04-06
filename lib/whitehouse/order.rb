require 'json'

module Whitehouse
  class Order

    attr_accessor :entry_id, :drop_ship, :from_address_value, :sequence_number,
                  :from_address, :to_address, :order_attributes
    attr_reader :items

    def initialize
      defaults
      yield self if block_given?
    end

    OrderItem = Struct.new(:uid, :url, :md5, :attributes, :rotation) do
      def assets
        [{"AssetPath" => url,
          "PrintedFileName" => "",
          "ImageHash" => md5,
          "DP2NodeID" => 10000,
          "OffsetX" => 50,
          "OffsetY" => 50,
          "X" => 50,
          "Y" => 50,
          "ZoomX" => 100,
          "ZoomY" => 100,
          "ImageRotation" => 0,
          "isCoverAsset" => false,
          "isJacketAsset" => false,
          "ColorCorrect" => false}]
      end

      def item_attributes
        return [] unless attributes
        attributes.map{|attr| {"AttributeUID" => attr}}
      end
    end

    Address = Struct.new(:name, :addr1, :addr2, :city, :state, :zip, :country) do
      def to_hash
        {"Name" => name,
         "Addr1" => addr1,
         "Addr2" => addr2,
         "City" => city,
         "State" => state,
         "Zip" => zip,
         "Country" => country || 'US'
        }
      end
    end


    def add_item(item)
      @items << item
    end

    def to_json
      {"EntryID" => entry_id,
       "Orders" => [
         order_hash
        ]
      }.to_json
    end

    def order_hash
      {"DropShipFlag" => drop_ship,
       "FromAddressValue" => from_address_value,
       "OrderAttributes" => order_attributes,
       # "Reference" => reference,
       # "Instructions" => instructions,
       "SequenceNumber" => sequence_number,
       "ShipToAddress" => to_address,
       # "ShipFromAddress" => from_address,
       "OrderItems" => order_items
      }
    end

    private

    def defaults
      self.drop_ship = 1
      self.from_address_value = 1
      self.sequence_number = 1
      self.order_attributes = []
      @items = []
    end

    def order_attributes
      @order_attributes.map{|attr| {"AttributeUID" => attr}}
    end

    def order_items
      items.each_with_index.map do |item, i|
        {"ItemAssets" => item.assets,
         "ItemAttributes" => item.item_attributes,
         "ProductUID" => item.uid,
         "Quantity" => 1,
         "LineItemID" => i,
         "LayoutRotation" => item.rotation || 0}
      end
    end

    def to_address
      (@to_address || default_address).to_hash
    end

    def from_address
      (@from_address || default_address).to_hash
    end

    def default_address
      Address.new
    end

  end
end
