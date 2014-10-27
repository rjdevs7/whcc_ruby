require 'spec_helper'

describe Whitehouse::Client, vcr: {cassette_name: 'client', record: :new_episodes} do
  before do
    Whitehouse.reset!
  end

  let(:client) { Whitehouse::Client.new(access_token: '101024773634') }

  describe "authentication" do
    it "gets a new access token if expired" do
      client.get "Catalog"
      expect(WebMock).to have_requested(:get, /AccessToken/)
      expect(WebMock).to have_requested(:get, /Catalog/).twice
    end
  end
end
