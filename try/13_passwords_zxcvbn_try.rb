# frozen_string_literal: true

# These tryouts test the functionality of the Zxcvbn password strength checker.
# Zxcvbn is used in the Onetime application to assess the strength of user passwords.
#
# We're testing various aspects of Zxcvbn, including:
# 1. Basic password strength assessment
# 2. Score calculation for different types of passwords
# 3. Feedback and suggestions for weak passwords
# 4. Performance with longer passwords
#
# These tests aim to ensure that the password strength checking is configured
# and works correctly. We also want to make sure results are consistent over
# time (across code changes, ours and theirs). These tryouts give us an idea
# about the performance as well.
#

require_relative '../lib/onetime'
require 'zxcvbn'

# Use the default config file for tests
OT::Config.path = File.join(__dir__, '..', 'etc', 'config.test')
OT.boot!

# Setup
@weak_password = 'password123'
@medium_password = 'Troub4dor3'
@strong_password = 'correct horse battery staple'
@very_long_password = 'This is a very long password with numbers 12345 and symbols !@#$%'
@extreme_lengths = 'gf$dMQUE$rxGVM?Pax6hB7IpAPZDGIwdvGnQrwxNyG4I((9Icnp8*WkbKhxY5p!rZm7MjsdV5Vq(YhZyP8AS(zuQhr!AKZE7L9qAL$XCHayALKOcs9YZgqhg'

## Basic password strength check
result = Zxcvbn.test(@weak_password)
result.score
#=> 0

## Score for a medium strength password
Zxcvbn.test(@medium_password).score
#=> 3

## Score for a strong password
Zxcvbn.test(@strong_password).score
#=> 4

### Score for an extreme password
Zxcvbn.test(@extreme_lengths).score
#=> 4

## Feedback for a weak password
feedback = Zxcvbn.test(@weak_password).feedback
[feedback['warning'].empty?, feedback['suggestions'].empty?]
#=> [false, false]

## Guesses for a weak password
Zxcvbn.test(@weak_password).guesses < 1000
#=> true

## Guesses for a strong password
Zxcvbn.test(@strong_password).guesses > 1_000_000
#=> true

## Crack time for a weak password (offline fast hashing)
Zxcvbn.test(@weak_password).crack_times_seconds['offline_fast_hashing_1e10_per_second'] < 1
#=> true

## Crack time for a strong password (offline fast hashing)
Zxcvbn.test(@strong_password).crack_times_seconds['offline_fast_hashing_1e10_per_second'] > 1_000_000
#=> true

## Performance check for a very long password
start_time = Time.now
Zxcvbn.test(@very_long_password)
(Time.now - start_time) < 1  # Should complete in less than 1 second
#=> true

## Consistency of results
first_result = Zxcvbn.test(@medium_password)
second_result = Zxcvbn.test(@medium_password)
[first_result.score, first_result.guesses] == [second_result.score, second_result.guesses]
#=> true

# Teardown
# No specific teardown needed for these tests
