RSpec::Matchers.define :have_mutation_error do |field, error|
  match do |outcome|
    next false unless outcome.errors.present?
    the_error = outcome.errors[field] || outcome.errors[field.to_s]
    the_error.present? && the_error.symbolic == error
  end

  match_when_negated do |outcome|
    the_error = outcome.errors[field] || outcome.errors[field.to_s]
    the_error.nil?
  end

  failure_message do |outcome|
    next "expected there to be errors, but there were none..." if outcome.errors.blank?
    if outcome.errors[field]
      "expected that the error for field #{field.inspect} would be #{error.inspect} but was #{outcome.errors[field].symbolic.inspect}"
    else
      "expected that outcome would have an error for #{field.inspect}\n\t  got: #{outcome.errors}"
    end
  end
end