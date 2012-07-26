# Readme application template recipe for the rails_apps_composer gem

after_bundler do

  remove_file 'README.rdoc'
  case config['readme_format']
    when 'default'
      get 'https://raw.github.com/akiva/rails-application-boilerplates/master/README.rdoc.example', 'README.rdoc'
      gsub_file 'README.rdoc', /App_Name/, "#{app_name.humanize.titleize}"
    when 'markdown'
      get 'https://raw.github.com/akiva/rails-application-boilerplates/master/README.md.example', 'README.md'
      gsub_file 'README.md', /App_Name/, "#{app_name.humanize.titleize}"
    when 'textile'
      get 'https://raw.github.com/akiva/rails-application-boilerplates/master/README.textile.example', 'README.textile'
      gsub_file 'README.textile', /App_Name/, "#{app_name.humanize.titleize}"
  end

end

__END__

name: README
description: "Prompts the user which format to use for the README file"
author: Akiva Levy

category: other
tags: [utilities]

config:
  - readme_format:
      type: multiple_choice
      prompt: "Which format would you prefer to use for the README file?"
      choices: [["Default (RDoc)", default], ["Markdown", markdown], ["Textile", textile]]
