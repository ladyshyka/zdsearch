# A custom matcher for matching on the expected size of an array
RSpec::Matchers.define :array_of_size do |x|
  match { |obj| obj.is_a?(Array) && obj.count == x }
end