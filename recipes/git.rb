# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/git.rb

## Git
say_wizard "initialize git"
prefs[:git] = true unless prefs.has_key? :git
if prefer :git, true
  begin
    remove_file '.gitignore'
    get 'https://raw.github.com/RailsApps/rails-composer/master/files/gitignore.txt', '.gitignore'
  rescue OpenURI::HTTPError
    say_wizard "Unable to obtain gitignore file from the repo"
  end
  git :init
  git :add => '.'
  git :commit => "-aqm 'rails_apps_composer: initial commit'"
end

__END__

name: git
description: "Initialize git for your application."
author: RailsApps

category: configuration