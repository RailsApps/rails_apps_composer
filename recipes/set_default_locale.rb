unless prefs[:default_locale]
  prefs[:default_locale] = ask_wizard('Which default locale would you set (leave blank to skip)')
end

after_bundler do
  if prefs[:default_locale].present?
    gsub_file 'config/application.rb', /# config.i18n.default_locale.*$/, "config.i18n.default_locale = :#{prefs[:default_locale]}"
  end
end

__END__

name: set_default_locale
description: "Set default locale"
author: hedgesky

category: other
requires: [setup]
run_after: [setup, extras]
