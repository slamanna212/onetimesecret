# frozen_string_literal: true

# These tests cover the core functionality of the Onetime::Logic::Base class,
# which serves as the foundation for all logic classes in the application.
#
# We test:
# 1. Initialization and parameter processing
# 2. Email validation
# 3. Plan handling
# 4. Action limiting
# 5. Password normalization
# 6. StatHat integration

require 'onetime'

# Load the app with test configuration
OT::Config.path = File.join(Onetime::HOME, 'tests', 'unit', 'ruby', 'config.test.yaml')
OT.boot! :test

# Setup common test variables
@now = DateTime.now
@email = 'test@onetimesecret.com'
@sess = OT::Session.new '255.255.255.255', 'anon'
@cust = OT::Customer.new @email
@params = { test: 'value' }
@locale = 'en'

# Create a concrete test class since Base is abstract
class TestLogic < Onetime::Logic::Base
  def process_params
    @processed_params[:test] = params[:test]
  end

  def success_data
    { status: 'success' }
  end

  def form_fields
    { test: 'field' }
  end
end

@obj = TestLogic.new @sess, @cust, @params, @locale

## Base initialization sets expected attributes
[@obj.sess, @obj.cust, @obj.params, @obj.locale]
#=> [@sess, @cust, @params, @locale]

## process_params processes parameters correctly
@obj.processed_params
#=> { test: 'value' }

## Settings are processed during initialization
[@obj.site, @obj.authentication, @obj.domains_enabled].map(&:class)
#=> [Hash, Hash, FalseClass]

## Email validation works for invalid addresses
@obj.valid_email?('notanemail')
#=> false

## Email validation works for valid addresses
@obj.valid_email?('valid@example.com')
#=> true

## Password normalization handles various cases
[
  Onetime::Logic::Base.normalize_password('  password  '),
  Onetime::Logic::Base.normalize_password('a' * 200),
  Onetime::Logic::Base.normalize_password(nil)
]
#=> ['password', 'a' * 128, '']

## Plan defaults to anonymous for nil customer
@obj_no_cust = TestLogic.new(@sess, nil)
@obj_no_cust.send(:plan).planid
#=> 'anonymous'

## Action limiting works for non-paid plans
@sess.event_get(:test_action).to_i
#=> 0

## Action limiting works for non-paid plans
@obj.send(:limit_action, :test_action)
@sess.event_get(:test_action).to_i
#=> 1

## Form error includes form fields
begin
  @obj.send(:raise_form_error, 'test error')
rescue OT::FormError => e
  [e.message, e.form_fields]
end
#=> ['test error', { test: 'field' }]

## StatHat integration respects enabled setting
[
  Onetime::Logic.stathat_count('test', 1),
  Onetime::Logic.stathat_value('test', 100)
]
#=> [false, false]

# Cleanup
@sess.event_clear! :test_action
