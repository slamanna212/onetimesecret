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
# These tests aim to ensure that the password strength checking works correctly,
# which is crucial for maintaining security in the Onetime application.
#
#
# Usage:
#
#  require 'zxcvbn'
#
#  Zxcvbn.zxcvbn("password")
#  {
#    "password" => "password",
#    "guesses" => 3,
#    "guesses_log10" => 0.47712125471966244,
#    "sequence" => [
#      {
#        "pattern" => "dictionary",
#        "i" => 0,
#        "j" => 7,
#        "token" => "password",
#        "matched_word" => "password",
#        "rank" => 2,
#        "dictionary_name" => "passwords",
#        "reversed" => false,
#        "l33t" => false,
#        "base_guesses" => 2,
#        "uppercase_variations" => 1,
#        "l33t_variations" => 1,
#        "guesses" => 2,
#        "guesses_log10" => 0.3010299956639812
#      }
#    ],
#    "calc_time" => 1,
#    "crack_times_seconds" => {
#      "online_throttling_100_per_hour" => 108.0,
#      "online_no_throttling_10_per_second" => 0.3,
#      "offline_slow_hashing_1e4_per_second" => 0.0003,
#      "offline_fast_hashing_1e10_per_second" => 3.0e-10},
#    "crack_times_display" => {
#      "online_throttling_100_per_hour" => "2 minutes",
#      "online_no_throttling_10_per_second" => "less than a second",
#      "offline_slow_hashing_1e4_per_second" => "less than a second",
#      "offline_fast_hashing_1e10_per_second" => "less than a second"
#    },
#    "score" => 0,
#    "feedback" => {
#      "warning" => "This is a top-10 common password",
#      "suggestions" => [
#        "Add another word or two. Uncommon words are better."
#      ]
#    }
#  }
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
