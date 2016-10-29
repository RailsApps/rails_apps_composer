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
prefs[:railsapps] = 'rails-recurly-subscription-saas'
say_wizard "selected rails-recurly-subscription-saas testing recipe"
__END__
name:                rails_recurly_subscription_saas_testing_recipe
description:         rails-recurly-subscription-saas testing recipe
author: RailsApps
category: testing
