# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/git.rb

## Git
prefs[:git] = true unless prefs.has_key? :git
if prefer :git, true
  if !File.directory?('.git')
    say_wizard "initialize git"
    git :init
  end
  if !File.file?('.gitignore')
    copy_from 'https://raw.github.com/RailsApps/rails-composer/master/files/gitignore.txt', '.gitignore'
  end
  git :add => '-A'
  git :commit => '-qm "rails_apps_composer: initial commit"'
end

__END__

name: git
description: "Initialize git for your application."
author: RailsApps

category: configuration
