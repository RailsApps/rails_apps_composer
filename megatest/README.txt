Here are the steps to run megatest:

bundle install
rmdir ../generated

# Run the megatest script with your service keys:
(
  export        rac_test_RECURLY_API_KEY=Change_this_to_your_key
  export rac_test_RECURLY_JS_PRIVATE_KEY=Change_this_to_your_key
  export         rac_test_STRIPE_API_KEY=Change_this_to_your_key
  export      rac_test_STRIPE_PUBLIC_KEY=Change_this_to_your_key

  bundle exec rake mega:test --trace
)
