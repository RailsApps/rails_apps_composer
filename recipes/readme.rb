# Readme application template recipe for the rails_apps_composer gem

after_bundler do

  remove_file 'README.rdoc'
  case config['readme_format']
    when 'default'
      get 'https://raw.github.com/akiva/rails-application-boilerplates/master/README.rdoc.example', 'README.rdoc'
    when 'markdown'
      get 'https://raw.github.com/akiva/rails-application-boilerplates/master/README.md.example', 'README.md'
    when 'textile'
      get 'https://raw.github.com/akiva/rails-application-boilerplates/master/README.textile.example', 'README.textile'
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
