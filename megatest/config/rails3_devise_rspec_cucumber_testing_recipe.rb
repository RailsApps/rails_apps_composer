prefs[:ban_spiders] = false
prefs[:continuous_testing] = 'none'
prefs[:dev_webserver] = 'puma'
prefs[:drop_database] = true
prefs[:github] = false
prefs[:jsruntime] = false
prefs[:prod_webserver] = 'same'
prefs[:rvmrc] = false
prefs[:templates] = 'erb'

prefs[:gems] = []
prefs[:railsapps] = 'rails3-devise-rspec-cucumber'
say_wizard "selected rails3-devise-rspec-cucumber testing recipe"
__END__
name:                rails3_devise_rspec_cucumber_testing_recipe
description:         rails3-devise-rspec-cucumber testing recipe
author: RailsApps
category: testing
