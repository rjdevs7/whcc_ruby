require 'json'

module Whitehouse
  class OrderEntry

    attr_accessor :entry_id
    attr_reader :orders

    def initialize
      @orders = []
      yield self if block_given?
    end

    def to_json
      {"EntryID" => entry_id,
       "Orders" => orders.map(&:order_hash)
      }.to_json
    end

  end
end
