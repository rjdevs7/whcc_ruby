require 'spec_helper'

describe Whitehouse::Client::Catalog do
  before do
    Whitehouse.reset!
  end

  let(:client) { Whitehouse.client }

  describe "#request_catalog", vcr: {cassette_name: 'catalog'} do
    let(:catalog) { client.request_catalog }
    let(:categories) { catalog["Categories"] }
    it 'fetches the product catalog' do
      expect(categories.length).to eql(2)
    end
  end

end
