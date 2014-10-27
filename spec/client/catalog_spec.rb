require 'spec_helper'

describe Whitehouse::Client::Catalog do
  before do
    Whitehouse.reset!
  end

  let(:client) { Whitehouse::Client.new(access_token: '101024773634') }

  describe "#request_catalog", vcr: {cassette_name: 'catalog', record: :new_episodes} do
    let(:catalog) { client.request_catalog }
    let(:categories) { catalog["Categories"] }
    it 'fetches the product catalog' do
      expect(categories.length).to eql(2)
      expect(WebMock).to have_requested(:get, /\/api\/Catalog/)
    end
  end

end
