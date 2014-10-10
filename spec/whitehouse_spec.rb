require 'spec_helper'

describe Whitehouse, vcr: {cassette_name: 'client', record: :new_episodes} do
  before do
    Whitehouse.reset!
  end

  after do
    Whitehouse.reset!
  end

  it "sets defaults" do
    Whitehouse::Configurable.keys.each do |key|
      expect(Whitehouse.instance_variable_get(:"@#{key}")).to eq(Whitehouse::Default.send(key))
    end
  end

  describe ".client" do
    it "creates a Whitehouse::Client" do
      expect(Whitehouse.client).to be_kind_of Whitehouse::Client
    end
    it "caches the client when the same options are passed" do
      expect(Whitehouse.client).to eq(Whitehouse.client)
    end
    it "returns a fresh client when options are not the same" do
      client = Whitehouse.client
      Whitehouse.user_agent = "A different ruby gem"
      client_two = Whitehouse.client
      client_three = Whitehouse.client
      expect(client).not_to eq(client_two)
      expect(client_three).to eq(client_two)
    end
  end

  describe ".configure" do
    Whitehouse::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_',' ')}" do
        Whitehouse.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Whitehouse.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end
  end

end
