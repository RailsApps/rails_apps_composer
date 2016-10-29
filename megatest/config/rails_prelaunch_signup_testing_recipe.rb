prefs[:ban_spiders] = false
prefs[:continuous_testing] = 'none'
prefs[:dev_webserver] = 'puma'
prefs[:drop_database] = true
prefs[:github] = false
prefs[:jsruntime] = false
prefs[:prod_webserver] = 'same'
prefs[:rvmrc] = false
prefs[:templates] = 'erb'

prefs[:main_branch] = 'wip'
prefs[:prelaunch_branch] = 'master'
prefs[:gems] = %w[ selenium-webdriver ]
prefs[:railsapps] = 'rails-prelaunch-signup'
say_wizard "selected rails-prelaunch-signup testing recipe"
__END__
name:                rails_prelaunch_signup_testing_recipe
description:         rails-prelaunch-signup testing recipe
author: RailsApps
category: testing
