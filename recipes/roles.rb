# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/roles.rb

# Helps to assign different kinds of roles to users. Like guest, moderator etc.

stage_two do
  say_wizard "recipe stage two"

  if (prefer :authorization, 'roles') || (prefer :authorization, 'pundit')
    if prefer :authentication, 'none'
      generate 'model User email:string'
      run 'bundle exec rake db:migrate'
    end
    generate 'migration AddRoleToUsers role:integer'
    role_boilerplate = "  enum role: [:user, :vip, :admin]\n  after_initialize :set_default_role, :if => :new_record?\n\n"
    role_boilerplate << "  def set_default_role\n    self.role ||= :user\n  end\n\n" if prefer :authentication, 'devise'
    if prefer :authentication, 'omniauth'
      role_boilerplate << <<-RUBY
  def set_default_role
    if User.count == 0
      self.role ||= :admin
    else
      self.role ||= :user
    end
  end
RUBY
    end
    inject_into_class 'app/models/user.rb', 'User', role_boilerplate
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: add roles to a User model"' if prefer :git, true
end

# Normally, ruby scripts are finished when you reach the end of a file; however, this is not always the case. You can end your script sooner by using the __END__ keyword in your script.
# Once added, everything you type after that will not be parsed by ruby.
__END__

name: roles
description: "Add roles to a User model"
author: RailsApps

requires: [setup, gems, devise, omniauth]
run_after: [setup, gems, devise, omniauth]
category: mvc
