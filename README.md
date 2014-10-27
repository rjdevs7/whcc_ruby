# Whitehouse [![Build Status](https://travis-ci.org/whcc/whcc_ruby.svg?branch=master)](https://travis-ci.org/whcc/whcc_ruby)

Ruby client for the WHCC API.

## Installation

Add this line to your application's Gemfile:

    gem 'whitehouse'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install whitehouse

## Usage

### Authentication
Configuration can be done at the module level:
```ruby
Whitehouse.configure do |c|
  c.consumer_key = 'FA2DBC52662850A7B53B'
  c.consumer_secret = 'rPTa7aIydCI='
end
```

at the client instance level:
```ruby
client = Whitehouse::Client.new(consumer_key: 'FA2DBC52662850A7B53B', consumer_secret: 'rPTa7aIydCI=')
```

or via environment variables:
```
WHCC_CONSUMER_KEY='FA2DBC52662850A7B53B'
WHCC_CONSUMER_SECRET='rPTa7aIydCI='
```

### Fetch the catalog
```ruby
Whitehouse.request_catalog
```

### Submitting an Order
```ruby
# Build the order object
order = Whitehouse::Order.new
order.entry_id = '123abc'
order.order_attributes = [95,97]

# Set the shipping address
shipping_address = Whitehouse::Order::Address.new("Bob","123 Fake St","","Somewhere","MN","55121")
order.to_address = shipping_address

# Add the line items
item = Whitehouse::Order::OrderItem.new(3,"http://lab.whcc.com/ApostleIslandMarina.jpg","60ee3ed946def317eae764516b727f50", [5,1])
order.add_item(item)

# Submit order
confirm = Whitehouse.submit_order(order)

# Confirm order
if (confirm)
  confirmed = Whitehouse.confirm_order(confirm)
end
```

### Creating Webhooks
```ruby
Whitehouse.create_webhook('http://example.com/webhook')

# WHCC will POST to the uri provided with a 'verifier' token.
Whitehouse.verify_webhook(verifier)
```

## Contributing

1. Fork it ( https://github.com/whcc/whcc_ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
