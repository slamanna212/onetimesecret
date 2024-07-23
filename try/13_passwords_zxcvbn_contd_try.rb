# frozen_string_literal: true

# These tryouts test the functionality of the Zxcvbn password strength checker.
# Zxcvbn is used in the Onetime application to assess the strength of user passwords.
#
# We're testing various aspects of Zxcvbn, including:
# 1. Basic password strength assessment
# 2. Analysis of different password components
# 3. Crack time estimations
# 4. Feedback and suggestions for weak passwords

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
