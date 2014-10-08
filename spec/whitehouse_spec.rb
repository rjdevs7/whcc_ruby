require 'spec_helper'
require 'whitehouse'

describe Whitehouse do
  let(:client) { Whitehouse::Client.new(sandbox: true) }
  it 'authenticates' do
    expect { client }.not_to raise_error
  end

  describe '#request_catalog' do
    it 'returns the catalog' do
      expect(client.request_catalog).to be
    end
  end
end
