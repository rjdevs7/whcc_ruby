require 'spec_helper'

describe Whitehouse::Client::Webhook, vcr: {cassette_name: 'webhook', record: :new_episodes} do
  before do
    Whitehouse.reset!
  end

  let(:client) { Whitehouse::Client.new(access_token: '101024773634') }

  describe "#create_webhook" do
    let(:uri) { "http://example.com/webhook" }
    it "returns a confirmation code via api" do
      res = client.create_webhook(uri)
      expect(res).to be_truthy
      expect(WebMock).to have_requested(:post, /\/api\/callback\/create/)
    end
  end

  describe "#verify_webhook" do
    let(:verifier) { "3f8afc02-cd26-423d-a2d0-d6b9d6c1f1bf" }
    it "verifies webhook" do
      res = client.verify_webhook(verifier)
      expect(res).to be_truthy
      expect(WebMock).to have_requested(:post, /\/api\/callback\/verify/)
    end
  end

end
