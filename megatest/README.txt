For anyone changing gem rails_apps_composer, this mega-test gives it 
a new and fuller testing capability (than previously available). To 
accomplish this, it generates all Rails Example Apps and runs their 
tests.

The mega-test should work on Linux, Mac OS X, and NetBSD. (For the 
last, please see the separate README.)

How to run the mega-test:

# Be in the right directory:
cd rails_apps_composer

# Each time you change the gem, do this:
(
  bundle install
  gem uninstall rails_apps_composer -x
  bundle exec rake reinstall
)

# To run the mega-test script, some Rails Example Apps require your 
# service keys. So, do make a private copy of this file (not under 
# version control), then edit it, putting in your own keys.

# Run the mega-test:
(
# First, supply your service keys:
  export        rac_test_RECURLY_API_KEY=Change_this_to_your_key
  export rac_test_RECURLY_JS_PRIVATE_KEY=Change_this_to_your_key
  export         rac_test_STRIPE_API_KEY=Change_this_to_your_key
  export      rac_test_STRIPE_PUBLIC_KEY=Change_this_to_your_key

# Then run the mega-test's Rake task:
  rm -rf ../generated
  bundle exec rake mega:test --trace
)
