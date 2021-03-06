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
```ruby
class MyContract < Objection::Base
  requires :required_1, :required_2
  optionals :optional_1, :optional_2
end

contract = MyContract.new(required_1: 'value', required_2: 'other-value', optional_1: 'more info')
contract.optional_2 = 'other info'

contract.required_1 => 'value'
contract.optional_2 => 'other info'
```

The gem will protect you from using unknown fields, and from suppling blank values for the required fields

## Fields with type

Declare via:

```ruby
class MyContract < Objection::Base
  requires :required_1, :required_2
  optionals :optional_1, :optional_2

  input_types(
    required_1: Fixnum,
    required_2: String,
    optional_1: Float
  )

end
```

## Nested structures

Consider the following classes:

```ruby
class DemoNestedCar < Objection::Base
  requires  :car_model
  optionals :licence_plate
  input_types(
    car_model: String
  )
end

class DemoNestedBooking < Objection::Base
  requires :booking_id, :booking_date
  optionals :car
  input_types(
    booking_date: Date,
    car:          DemoNestedCar,
  )
end
```

When initializing the class DemoNestedBooking, and suppliing a hash for field 'car', the gem will cast the type.
The class 'DemoNestedCar' will be instantiated, with the hash of 'car' as input.
After instantiating, the following will be true:

```ruby
obj.car.is_a?(DemoNestedCar)
obj.car.car_model == "<value given via ['car']['car_model']>"
```

This also works for arrays. When an array is given where an object is suspected, then each item within the array will be converted into the declared object.

## Leasurely mode
When Objection is instantiated with unknown fields in the parameters (a field not declared as optional or required), then an error will be thrown, because the contract is broken.
But sometimes that is just how the world works, and the contract has to be breakable.
Introduce the Leasure-mode, which can be set per contract by inheriting from the Leasurely-module:

```ruby
class DemoLeasurely < Objection::Leasurely::Base
  requires :required_1
end

obj = DemoLeasurely.new(required_1: 'dummy', unknown_1: 'dummy')
```
The instantiation above will not raise an error. 
**Beware**: the field 'unknown_1' will not be referencable via a getter-function.

## To hash

For better connection with other services, objection can convert its values to an hash, with the `to_hash` function.
This operation works recursivly with nested objects and arrays of objects.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/objection/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
