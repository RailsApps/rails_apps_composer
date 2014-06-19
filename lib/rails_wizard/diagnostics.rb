module RailsWizard
  module Diagnostics

    ### collections of recipes that are known to work together
    @@recipes = []
    @@recipes << %w(example)
    @@recipes << %w(setup)
    @@recipes << %w(railsapps)
    @@recipes << %w(gems setup)
    @@recipes << %w(gems readme setup)
    @@recipes << %w(extras gems readme setup)
    @@recipes << %w(example git)
    @@recipes << %w(git setup)
    @@recipes << %w(git railsapps)
    @@recipes << %w(gems git setup)
    @@recipes << %w(gems git readme setup)
    @@recipes << %w(extras gems git readme setup)
    @@recipes << %w(controllers email extras frontend gems git init models railsapps readme routes setup testing views)
    @@recipes << %w(controllers core email extras frontend gems git init models railsapps readme routes setup testing views)
    @@recipes << %w(controllers core email extras frontend gems git init models prelaunch railsapps readme routes setup testing views)
    @@recipes << %w(controllers core email extras frontend gems git init models prelaunch railsapps readme routes saas setup testing views)
    @@recipes << %w(controllers email example extras frontend gems git init models railsapps readme routes setup testing views)
    @@recipes << %w(controllers email example extras frontend gems git init models prelaunch railsapps readme routes setup testing views)
    @@recipes << %w(controllers email example extras frontend gems git init models prelaunch railsapps readme routes saas setup testing views)
    @@recipes << %w(apps4 controllers core email extras frontend gems git init models prelaunch railsapps readme routes saas setup testing views)
    @@recipes << %w(apps4 controllers core email extras frontend gems git init models prelaunch railsapps readme routes saas setup testing tests4 views)
    @@recipes << %w(apps4 controllers core deployment email extras frontend gems git init models prelaunch railsapps readme routes saas setup testing views)
    @@recipes << %w(apps4 controllers core deployment email extras frontend gems git init models prelaunch railsapps readme routes saas setup testing tests4 views)

    ### collections of preferences that are known to work together

    # ignore these preferences (because they don't cause conflicts)
    # :ban_spiders
    # :better_errors
    # :dev_webserver
    # :git
    # :github
    # :jsruntime
    # :local_env_file
    # :main_branch
    # :prelaunch_branch
    # :prod_webserver
    # :quiet_assets
    # :rvmrc
    # :templates

    @@prefs = []
    @@prefs << {:railsapps=>"none", :database=>"sqlite", :unit_test=>"rspec", :integration=>"rspec-capybara", :fixtures=>"factory_girl", :frontend=>"bootstrap", :bootstrap=>"sass", :email=>"none", :authentication=>"omniauth", :omniauth_provider=>"twitter", :authorization=>"cancan", :form_builder=>"none", :starter_app=>"admin_app"}
    @@prefs << {:railsapps=>"none", :database=>"sqlite", :unit_test=>"rspec", :integration=>"cucumber", :fixtures=>"none", :frontend=>"bootstrap", :bootstrap=>"sass", :email=>"gmail", :authentication=>"devise", :devise_modules=>"invitable", :authorization=>"cancan", :form_builder=>"simple_form", :starter_app=>"admin_app"}
    @@prefs << {:railsapps=>"none", :database=>"sqlite", :unit_test=>"rspec", :integration=>"cucumber", :fixtures=>"factory_girl", :frontend=>"bootstrap", :bootstrap=>"sass", :email=>"gmail", :authentication=>"devise", :devise_modules=>"default", :authorization=>"cancan", :form_builder=>"none", :starter_app=>"admin_app"}
    @@prefs << {:railsapps=>"none", :database=>"sqlite", :unit_test=>"test_unit", :integration=>"none", :fixtures=>"none", :frontend=>"bootstrap", :bootstrap=>"less", :email=>"sendgrid", :authentication=>"devise", :devise_modules=>"confirmable", :authorization=>"cancan", :form_builder=>"none", :starter_app=>"admin_app"}

    def self.recipes
      @@recipes
    end

    def self.prefs
      @@prefs
    end
  end
end
