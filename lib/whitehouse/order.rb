require 'json'

module Whitehouse
  class Order

    attr_accessor :entry_id, :drop_ship, :from_address_value, :instructions, :sequence_number,
                  :from_address, :to_address, :order_attributes, :reference
    attr_reader :items

    def initialize
      defaults
      yield self if block_given?
    end

    OrderItem = Struct.new(:uid, :url, :md5, :attributes) do
      def assets
        [{"AssetPath" => url,
          "DP2NodeID" => 10000,
          "ImageHash" => md5,
          "ImageRotation" => 0,
          "OffsetX" => 50,
          "OffsetY" => 50,
          "PrintedFileName" => "file.jpg",
          "X" => 50,
          "Y" => 50,
          "ZoomX" => 100,
          "ZoomY" => 100,
          "isCoverAsset" => false,
          "isJacketAsset" => false,
          "ColorCorrect" => true}]
      end

      def item_attributes
        return [] unless attributes
        attributes.map{|attr| {"AttributeUID" => attr}}
      end
    end

    Address = Struct.new(:attn, :name, :addr1, :addr2, :addr3, :city, :state, :zip, :country) do
      def to_hash
        {"Addr1" => addr1,
         "Addr2" => addr2,
         "Addr3" => addr3,
         "Attn" => attn,
         "City" => city,
         "Country" => country,
         "Name" => name,
         "State" => state,
         "Zip" => zip
        }
      end
    end


    def add_item(item)
      @items << item
    end

    def to_json
      {"EntryId" => entry_id,
       "Orders" => [
         {"DropShipFlag" => drop_ship,
           "FromAddressValue" => from_address_value,
           "OrderAttributes" => order_attributes,
           "Reference" => reference,
           "Instructions" => instructions,
           "SequenceNumber" => sequence_number,
           "ShipToAddress" => to_address,
           "ShipFromAddress" => from_address,
           "OrderItems" => order_items
        }
      ]
      }.to_json
    end

    private

    def defaults
      self.drop_ship = 1
      self.from_address_value = 2
      self.sequence_number = 1
      self.order_attributes = []
      @items = []
    end

    def order_attributes
      @order_attributes.map{|attr| {"AttributeUID" => attr}}
    end

    def order_items
      items.map do |item|
        {"ItemAssets" => item.assets,
         "ItemAttributes" => item.item_attributes,
         "ProductUID" => item.uid,
         "Quantity" => 1,
         "LayoutRotation" => 0}
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
