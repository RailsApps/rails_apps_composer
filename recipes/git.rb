# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/git.rb

## Git
say_wizard "initialize git"
prefs[:git] = true unless prefs.has_key? :git
if prefer :git, true
  copy_from 'https://raw.github.com/RailsApps/rails-composer/master/files/gitignore.txt', '.gitignore'
  git :init
  git :add => '-A'
  git :commit => '-qm "rails_apps_composer: initial commit"'
else
  stage_three do
    say_wizard "recipe stage three"
    say_wizard "removing .gitignore and .gitkeep files"
    git_files = Dir[File.join('**','.gitkeep')] + Dir[File.join('**','.gitignore')]
    File.unlink git_files
  end
end

__END__

name: git
description: "Initialize git for your application."
author: RailsApps

category: configuration
