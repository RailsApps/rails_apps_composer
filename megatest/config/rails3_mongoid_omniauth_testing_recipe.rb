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
prefs[:railsapps] = 'rails3-mongoid-omniauth'
say_wizard "selected rails3-mongoid-omniauth testing recipe"
__END__
name:                rails3_mongoid_omniauth_testing_recipe
description:         rails3-mongoid-omniauth testing recipe
author: RailsApps
category: testing
