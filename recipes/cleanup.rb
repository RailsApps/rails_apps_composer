# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/cleanup.rb

after_bundler do

  say_wizard "Cleanup recipe running 'after bundler'"

  # remove unnecessary files
  %w{
    README
    doc/README_FOR_APP
    public/index.html
    public/images/rails.png
  }.each { |file| remove_file file }

  # add placeholder READMEs
  get "https://github.com/fortuity/rails-template-recipes/raw/master/sample_readme.txt", "README"
  get "https://github.com/fortuity/rails-template-recipes/raw/master/sample_readme.textile", "README.textile"
  gsub_file "README", /App_Name/, "#{app_name.humanize.titleize}"
  gsub_file "README.textile", /App_Name/, "#{app_name.humanize.titleize}"

  # remove commented lines from Gemfile
  # thanks to https://github.com/perfectline/template-bucket/blob/master/cleanup.rb
  gsub_file "Gemfile", /#.*\n/, "\n"
  gsub_file "Gemfile", /\n+/, "\n"

end

__END__

name: Cleanup
description: "Remove unnecessary files left over from generating a new Rails app."
author: fortuity

category: other
tags: [utilities, configuration]
