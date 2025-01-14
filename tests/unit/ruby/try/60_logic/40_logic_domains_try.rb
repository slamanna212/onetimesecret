# frozen_string_literal: true

# These tests cover the Domains logic classes which handle
# custom domain management functionality.
#
# We test:
# 1. Domain addition
# 2. Domain removal
# 3. Domain listing
# 4. Domain retrieval

require 'onetime'

# Load the app with test configuration
OT::Config.path = File.join(Onetime::HOME, 'tests', 'unit', 'ruby', 'config.test.yaml')
OT.boot! :test

# Setup common test variables
@now = DateTime.now
@email = 'test@onetimesecret.com'
@sess = OT::Session.new '255.255.255.255', 'anon'
@cust = OT::Customer.new @email
@cust.save
@domain_input = 'test.example.com'
@custom_domain = OT::CustomDomain.create @domain_input, @cust.custid
@cust.add_custom_domain @custom_domain


# ListDomains Tests

## Add a test domain to the customer
@cust.add_domain(@domain_input)

# Test domain listing
logic = OT::Logic::Domains::ListDomains.new @sess, @cust
logic.raise_concerns
logic.define_singleton_method(:create_vhost) {} # prevent calling 3rd party API for this test
logic.process
[
  logic.custom_domains.class,
  logic.custom_domains.empty?,
  logic.instance_variables.include?(:@cust)
]
#=> [Array, false, true]

# GetDomain Tests

## Test domain retrieval
logic = OT::Logic::Domains::GetDomain.new @sess, @cust, { domain: @domain_input }
[
  logic.instance_variables.include?(:@cust),
  logic.instance_variables.include?(:@params)
]
#=> [true, true]

# RemoveDomain Tests

## Test domain removal
@remove_params = { domain: @domain_input }
logic = OT::Logic::Domains::RemoveDomain.new @sess, @cust, @remove_params
logic.raise_concerns
logic.define_singleton_method(:create_vhost) {} # prevent calling 3rd party API for this test
logic.process
[
  logic.greenlighted,
  logic.domain_input,
  logic.display_domain
]
#=> [true, @domain_input, @domain_input]

# Cleanup test data
@cust.remove_custom_domain(@custom_domain)
@cust.redis.del
