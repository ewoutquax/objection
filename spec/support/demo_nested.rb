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
