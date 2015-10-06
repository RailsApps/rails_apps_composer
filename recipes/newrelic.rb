add_gem 'newrelic_rpm'

stage_two do
  say_wizard "recipe stage two"
  new_relic_license_key = ask_wizard("Enter New Relic license key:")
  application_name = ask_wizard("Enter application name:")
  run "bundle exec newrelic install --license_key=#{new_relic_license_key} #{application_name}"
  inject_into_file '.env', "NEW_RELIC_LICENSE_KEY=#{new_relic_license_key}\n", :before => /^\n/
  gsub_file 'config/newrelic.yml', '^(license_key:\s?)(.*$)', "\0ENV['NEW_RELIC_LICENSE_KEY']"
end

__END__

name: newrelic
description: "Add New Relic for collecting operational data"
author: eduduc

requires: [setup, gems, dotenv]
run_after: [setup, gems, dotenv]
category: customInk
