# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/locale.rb

unless prefs[:locale]
  prefs[:locale] = ask_wizard('Set a locale? Enter nothing for English, or es, de, etc:')
  prefs[:locale] = 'none' unless prefs[:locale].present?
end

unless prefer :locale, 'none'
  add_gem 'devise-i18n' if prefer :authentication, 'devise'
end

stage_two do
  unless prefer :locale, 'none'
    locale_for_app = prefs[:locale].include?('-') ? "'#{prefs[:locale]}'" : prefs[:locale]
    gsub_file 'config/application.rb', /# config.i18n.default_locale.*$/, "config.i18n.default_locale = :#{locale_for_app}"
    locale_filename = "config/locales/#{prefs[:locale]}.yml"
    create_file locale_filename
    append_to_file locale_filename, "#{prefs[:locale]}:"
  end
end

__END__

name: locale
description: "Set default locale"
author: hedgesky

category: other
requires: [setup]
run_after: [setup]
