unless prefs[:locale]
  prefs[:locale] = ask_wizard('Set a locale? Enter nothing for English, or es, de, etc:')
end

if prefs[:locale].present?
  add_gem 'devise-i18n' if prefer :authentication, 'devise'
end

stage_two do
  if prefs[:locale].present?
    gsub_file 'config/application.rb', /# config.i18n.default_locale.*$/, "config.i18n.default_locale = :#{prefs[:locale]}"
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
run_after: [setup, extras]
