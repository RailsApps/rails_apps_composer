# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/git.rb

after_everything do
  # Git should ignore some files
  remove_file '.gitignore'
  get "https://github.com/fortuity/rails3-gitignore/raw/master/gitignore.txt", ".gitignore"
  # Initialize new Git repo
  git :init
  git :add => '.'
  git :commit => "-aqm 'Initial commit of a new Rails app'"
  # Create a git branch
  git :checkout => ' -b working_branch'
  git :add => '.'
  git :commit => "-m 'Initial commit of working_branch'"
end

__END__

name: Git
description: "Set up Git and commit the initial repository."
author: fortuity

exclusive: scm
category: other
tags: [scm]
