# frozen_string_literal: true

require_relative '../lib/onetime'
require 'pry-byebug';

# Use the default config file for tests
OT::Config.path = File.join(__dir__, '..', 'etc', 'config.test')
OT.boot!

@ipaddress = '10.0.0.254' # A private IP address
@useragent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_2_5) AppleWebKit/237.36 (KHTML, like Gecko) Chrome/10.0.95 Safari/237.36'
@custid = 'tryouts'

# NOTE: create and initialize have transposed arguments 😩
@sess = OT::Session.create @ipaddress, @custid, @useragent

## Sessions have a session ID when created
sessid = @sess.sessid
[sessid.class, sessid.length > 50]
#=> [String, true]

## Sessions have an identifier
identifier = @sess.identifier
[identifier.class, identifier.length > 50]
#=> [String, true]

## Sessions have a short identifier
short_identifier = @sess.short_identifier
[short_identifier.class, short_identifier.length]
#=> [String, 12]

## Sessions have an IP address
ipaddress = @sess.ipaddress
[ipaddress.class, ipaddress]
#=> [String, @ipaddress]

## Sessions don't get unique IDs when instantiated
s1 = OT::Session.new
s2 = OT::Session.new
s1.sessid.eql?(s2.sessid)
#=> true

## Can set form fields
ret = @sess.set_form_fields custid: 'tryouts', planid: :testing
ret.class
#=> String

## Can get form fields, with indifferent access via symbol or string
ret = @sess.get_form_fields!
[ret.class, ret[:custid], ret['custid']]
#=> [Hash, 'tryouts', 'tryouts']

## By default sessions do not have auth disabled
sess = OT::Session.create @ipaddress, @custid, @useragent
sess.disable_auth
#=> false

## Can set and get disable_auth
sess = OT::Session.create @ipaddress, @custid, @useragent
sess.disable_auth = true
sess.disable_auth
#=> true

## By default sessions are not authenticated
sess = OT::Session.create @ipaddress, @custid, @useragent
sess.authenticated?
#=> false

## Can set and check authenticated status
sess = OT::Session.create @ipaddress, @custid, @useragent
sess.authenticated = true
sess.authenticated?
#=> true

## Can force a session to be unauthenticated
@sess_disabled_auth = OT::Session.create @ipaddress, @custid, @useragent
@sess_disabled_auth.authenticated = true
@sess_disabled_auth.disable_auth = true
@sess_disabled_auth.authenticated?
#=> false

## Load a new instance of the session and check authenticated status
sess = OT::Session.load @sess_disabled_auth.sessid
[sess.authenticated?, sess.disable_auth]
#=> [true, false]

## Reload the same instance of the session and check authenticated status
@sess_disabled_auth.reload!
[@sess_disabled_auth.authenticated?, @sess_disabled_auth.disable_auth]
#=> [false, true]


## Replacing the session ID will update the session
@replaced_session = OT::Session.create @ipaddress, @custid, @useragent
initial_sessid = @replaced_session.sessid.to_s
@replaced_session.authenticated = true
@replaced_session.replace!


@replaced_session.sessid.eql?(initial_sessid)
#=> false

## Replaced session is not authenticated


## Can check if a session exists
OT::Session.exists? @sess.sessid
#=> true

## Can load a session
sess = OT::Session.load @sess.sessid
sess.sessid.eql?(@sess.sessid)
#=> true

## Can generate a session ID
sid = OT::Session.generate_id
[sid.class, sid.length > 50]
#=> [String, true]

## Can update fields
@sess_with_changes = OT::Session.create @ipaddress, @custid, @useragent
@sess_with_changes.update_fields custid: 'tryouts', planid: :testing
#=> "OK"

## Can update fields (verify changes)
[@sess_with_changes.custid, @sess_with_changes.planid]
#=> ["tryouts", "testing"]
