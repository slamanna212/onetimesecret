# frozen_string_literal: true

#
# These tryouts test the functionality of the Zxcvbn password strength
# checker. Zxcvbn is used in the Onetime application to assess the
# strength of user passwords.
#
# We're testing various aspects of Zxcvbn, including:
# 1. Basic password strength assessment for weak, medium, and strong
#    passwords
# 2. Analysis of different password components and patterns
# 3. Crack time estimations for various attack scenarios
# 4. Feedback and suggestions for different password strengths
# 5. Comparison of scores and guesses between password categories
# 6. Consistency of results across password strengths
# 7. Performance checks, including calculation times
#
# These tests aim to ensure that the password strength checking is
# configured and works correctly across a range of password types. We
# also want to make sure results are consistent over time (across code
# changes, ours and theirs). These tryouts give us an idea about the
# relative strength of different passwords and the performance of the
# Zxcvbn library when integrated into our application.
#
# By testing weak, medium, and strong passwords, we can verify that
# Zxcvbn accurately differentiates between password strengths and
# provides appropriate feedback for each category. This comprehensive
# approach helps ensure the security and usability of our password
# strength checking feature.
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
@weak_password = "password"
@medium_password = "Troub4dor3"
@moderate_password = "Tr0ub4dor&3"
@strong_password = "correct horse battery staple"
@weak_result = Zxcvbn.zxcvbn(@weak_password)
@medium_result = Zxcvbn.zxcvbn(@medium_password)
@moderate_result = Zxcvbn.zxcvbn(@moderate_password)
@strong_result = Zxcvbn.zxcvbn(@strong_password)

## Basic password strength check
@weak_result["password"]
#=> "password"

## Guesses for a weak password
@weak_result["guesses"]
#=> 3

## Logarithmic representation of guesses
@weak_result["guesses_log10"].round(2)
#=> 0.48

## Analyzing password components
@weak_result["sequence"].first["pattern"]
#=> "dictionary"

## Dictionary name for the matched word
@weak_result["sequence"].first["dictionary_name"]
#=> "passwords"

## Calculation time
@weak_result["calc_time"].class
#=> Integer

## Crack time estimation (online throttled)
@weak_result["crack_times_seconds"]["online_throttling_100_per_hour"].round
#=> 108

## Crack time estimation (offline fast)
@weak_result["crack_times_seconds"]["offline_fast_hashing_1e10_per_second"] < 1e-9
#=> true

## Human-readable crack time (online throttled)
@weak_result["crack_times_display"]["online_throttling_100_per_hour"]
#=> "2 minutes"

## Overall password score
@weak_result["score"]
#=> 0

## Feedback warning for weak password
@weak_result["feedback"]["warning"]
#=> "This is a top-10 common password"

## Feedback suggestions
@weak_result["feedback"]["suggestions"].first
#=> "Add another word or two. Uncommon words are better."

## Medium strength password score
Zxcvbn.zxcvbn(@medium_password)["score"]
#=> 3

## Strong password score
Zxcvbn.zxcvbn(@strong_password)["score"]
#=> 4

## Strong password guesses
Zxcvbn.zxcvbn(@strong_password)["guesses"] > 1_000_000
#=> true

## Strong password feedback
Zxcvbn.zxcvbn(@strong_password)["feedback"]["warning"].empty?
#=> true

## Medium strength password score
@medium_result["score"]
#=> 3

## Medium password guesses
@medium_result["guesses"] > 1000
#=> true

## Medium password pattern
@medium_result["sequence"].first["pattern"]
#=> "bruteforce"

## Medium password crack time (online no throttling)
@weak_result["crack_times_display"]["online_no_throttling_10_per_second"]
#=> "less than a second"

## Medium password crack time (online no throttling)
@medium_result["crack_times_display"]["online_no_throttling_10_per_second"]
#=> "7 years"

## Medium password crack time (online no throttling)
@moderate_result["crack_times_display"]["online_no_throttling_10_per_second"]
#=> "centuries"

## Medium password crack time (online no throttling)
@strong_result["crack_times_display"]["online_no_throttling_10_per_second"]
#=> "centuries"

## Medium password feedback
@medium_result["feedback"]["warning"].empty?
#=> true

## Medium password suggestions
@medium_result["feedback"]["suggestions"].empty?
#=> true

## Strong password score
@strong_result["score"]
#=> 4

## Strong password guesses
@strong_result["guesses"] > 1_000_000
#=> true

## Strong password sequence length
@strong_result["sequence"].length
#=> 5

## Strong password crack time (offline slow hashing)
@strong_result["crack_times_display"]["offline_slow_hashing_1e4_per_second"]
#=> "centuries"

## Strong password feedback warning
@strong_result["feedback"]["warning"].empty?
#=> true

## Strong password feedback suggestions
@strong_result["feedback"]["suggestions"].empty?
#=> true

## Compare scores
[@weak_result["score"], @medium_result["score"], @strong_result["score"]]
#=> [0, 3, 4]

## Compare guesses (logarithmic)
@weak_result["guesses_log10"] < @medium_result["guesses_log10"] && @medium_result["guesses_log10"] < @strong_result["guesses_log10"]
#=> true

## Check if calculation times are reasonable
[@weak_result["calc_time"], @medium_result["calc_time"], @strong_result["calc_time"]].all? { |time| time < 100 }
#=> true
