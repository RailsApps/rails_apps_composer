prefs[:ban_spiders] = false
prefs[:continuous_testing] = 'none'
prefs[:dev_webserver] = 'webrick'
prefs[:drop_database] = true
prefs[:github] = false
prefs[:jsruntime] = false
prefs[:prod_webserver] = 'same'
prefs[:rvmrc] = false
prefs[:templates] = 'erb'



prefs[:gems] = []
prefs[:railsapps] = 'rails3-bootstrap-devise-cancan'
say_wizard "selected rails3-bootstrap-devise-cancan testing recipe"
__END__
name:                rails3_bootstrap_devise_cancan_testing_recipe
description:         rails3-bootstrap-devise-cancan testing recipe
author: RailsApps
category: testing
