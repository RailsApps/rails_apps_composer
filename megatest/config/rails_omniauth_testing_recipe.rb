prefs[:ban_spiders] = false
prefs[:continuous_testing] = 'none'
prefs[:dev_webserver] = 'puma'
prefs[:drop_database] = true
prefs[:github] = false
prefs[:jsruntime] = false
prefs[:prod_webserver] = 'same'
prefs[:rvmrc] = false
prefs[:templates] = 'erb'

prefs[:database] = 'sqlite'
prefs[:form_builder] = 'none'
prefs[:frontend] = 'none'
prefs[:omniauth_provider] = 'twitter'

prefs[:gems] = []
prefs[:apps4] = 'railsapps'
prefs[:railsapps]             = 'rails-omniauth'
prefs[:rails_4_1_starter_app] = 'rails-omniauth'
prefs[:pry] = true
prefs[:deployment] = 'capistrano3'
say_wizard             "selected rails-omniauth testing recipe"
__END__
name:                            rails_omniauth_testing_recipe
description:                     rails-omniauth testing recipe
author: RailsApps
category: testing
