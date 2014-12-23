# Objection

Build a contract to your interfaces, with predefined and required fields

## Installation

Add this line to your application's Gemfile:

    gem 'objection'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install objection

## Usage

Build your own class, and let it inherit from Objection::Base.
Set required fields with the requires-command, and optional fields with the optional-command

    class MyContract < ObjectionBase
      requires :required_1, :required_2
      optional :optional_1, :optional_2
    end

    contract = MyContract.new(required_1: 'value', required_2: 'other-value', optional_1: 'more info')
    contract.optional_2 = 'other info'

    contract.required_1 => 'value'
    contract.optional_2 => 'other info'

The gem will protect you from using unknown fields, and from suppling blank values for the required fields


## Contributing

1. Fork it ( https://github.com/[my-github-username]/objection/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
