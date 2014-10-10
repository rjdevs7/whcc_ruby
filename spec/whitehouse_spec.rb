require 'spec_helper'

describe Whitehouse, vcr: {cassette_name: 'client', record: :new_episodes} do
  let(:client) { Whitehouse::Client.new(sandbox: true) }
  it 'authenticates' do
    expect { client }.not_to raise_error
  end

  describe '#request_catalog' do
    let(:catalog) { client.request_catalog }
    let(:categories) { catalog["Categories"] }
    it 'fetches the product catalog' do
      expect(categories.length).to eql(2)
    end
  end
end
