prefs[:ban_spiders] = false
prefs[:continuous_testing] = 'none'
prefs[:dev_webserver] = 'puma'
prefs[:drop_database] = true
prefs[:github] = false
prefs[:jsruntime] = false
prefs[:prod_webserver] = 'same'
prefs[:rvmrc] = false
prefs[:templates] = 'erb'

prefs[:gems] = %w[ selenium-webdriver ]
prefs[:railsapps] = 'rails-stripe-membership-saas'
say_wizard "selected rails-stripe-membership-saas testing recipe"
__END__
name:                rails_stripe_membership_saas_testing_recipe
description:         rails-stripe-membership-saas testing recipe
author: RailsApps
category: testing
