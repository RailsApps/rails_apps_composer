# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/tests.rb

stage_two do
  say_wizard "recipe stage two"
  if prefer :tests, 'rspec'
    say_wizard "recipe installing RSpec"
    generate 'testing:configure rspec -f'
  end
  if prefer :continuous_testing, 'guard'
    say_wizard "recipe initializing Guard"
    run 'bundle exec guard init'
  end
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: testing framework"' if prefer :git, true
end

stage_three do
  say_wizard "recipe stage three"
  if prefer :tests, 'rspec'
    if prefer :authentication, 'devise'
      generate 'testing:configure devise -f'
      if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
        inject_into_file 'spec/factories/users.rb', "    confirmed_at Time.now\n", :after => "factory :user do\n"
        default_url = '  config.action_mailer.default_url_options = { :host => Rails.application.secrets.domain_name }'
        inject_into_file 'config/environments/test.rb', default_url, :after => "delivery_method = :test\n"
        gsub_file 'spec/features/users/user_edit_spec.rb', /successfully./, 'successfully,'
        gsub_file 'spec/features/visitors/sign_up_spec.rb', /Welcome! You have signed up successfully./, 'A message with a confirmation'
      end
    end
    if prefer :authentication, 'omniauth'
      generate 'testing:configure omniauth -f'
    end
    if (prefer :authorization, 'roles') || (prefer :authorization, 'pundit')
      generate 'testing:configure pundit -f'
      remove_file 'spec/policies/user_policy_spec.rb' unless %w(users about+users).include?(prefs[:pages])
      remove_file 'spec/policies/user_policy_spec.rb' if prefer :authorization, 'roles'
      remove_file 'spec/support/pundit.rb' if prefer :authorization, 'roles'
      if (prefer :authentication, 'devise') &&\
        ((prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable'))
        inject_into_file 'spec/factories/users.rb', "    confirmed_at Time.now\n", :after => "factory :user do\n"
      end
    end
    unless %w(users about+users).include?(prefs[:pages])
      remove_file 'spec/features/users/user_index_spec.rb'
      remove_file 'spec/features/users/user_show_spec.rb'
    end
  end
end

__END__

name: tests
description: "Add testing framework."
author: RailsApps

requires: [setup, gems]
run_after: [setup, gems]
category: testing
