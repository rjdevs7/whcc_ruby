require 'spec_helper'

describe Whitehouse::Client::Order, vcr: {cassette_name: 'order', record: :new_episodes} do
  before do
    Whitehouse.reset!
  end

  let(:client) { Whitehouse::Client.new(access_token: '101024773634') }
  let(:address) { Whitehouse::Order::Address.new("Bill Adama","2840 Lone Oak Parkway",nil,"Eagan","MN",55121) }
  let(:order_item) { Whitehouse::Order::OrderItem.new(3,"http://lab.whcc.com/ApostleIslandMarina.jpg", "60ee3ed946def317eae764516b727f50", [5,1]) }
  let(:order) {
    Whitehouse::Order.new do |order|
      order.entry_id = "123abc"
      order.order_attributes = [95,97]
      order.to_address = address
      order.add_item(order_item)
    end
  }

  describe "#submit_order" do
    it "returns a confirmation code via api" do
      res = client.submit_order(order)
      expect(res.length).to eq(36)
      expect(WebMock).to have_requested(:post, /\/api\/OrderImport/)
    end
  end

  describe "#confirm_order" do
    let(:confirmation_code) { "ecb9d9e6-42e0-4a69-ad7e-9996dfec343d" }
    it "confirms order via api" do
      res = client.confirm_order(confirmation_code)
      expect(res).to be_truthy
      expect(WebMock).to have_requested(:post, /\/api\/OrderImport\/Submit\/#{confirmation_code}/)
    end
  end

end
