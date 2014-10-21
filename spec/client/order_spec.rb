require 'spec_helper'

describe Whitehouse::Client::Order do
  before do
    Whitehouse.reset!
  end

  let(:client) { Whitehouse.client }

  describe "#submit_order", vcr: {cassette_name: 'order'} do
    it "submits order via api" do
      pending
      fail
    end
  end

  describe "#confirm_order", vcr: {cassette_name: 'order'} do
    it "confirms order via api" do
      pending
      fail
    end
  end

end
