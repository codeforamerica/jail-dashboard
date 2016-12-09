RSpec::Matchers.define :be_nil_or do |operator, number|
  match do |actual|
    actual.nil? || actual.send(operator, number)
  end

  failure_message do |actual|
    "expected that #{actual} would be nil or #{operator} #{number}"
  end
end
