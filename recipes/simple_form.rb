# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/gmgp/rails_apps_composer/blob/master/recipes/simple_form.rb

case config['form_option']
  when 'no'
    say_wizard "Form help recipe skipped."
  when 'simple_form'
    gem 'simple_form'
    # for external test
    recipes << 'simple_form'
  when 'simple_form_bootstrap'
    gem 'simple_form'
    # for external test
    recipes << 'simple_form'
    recipes << 'simple_form_bootstrap'
  else
    say_wizard "Form help recipe skipped."
end



after_bundler do

  say_wizard "Simple form recipe running 'after bundler'"

  case config['form_option']
    when 'simple_form'
      generate 'simple_form:install'
    when 'simple_form_bootstrap'
      if recipes.include? 'bootstrap'
        generate 'simple_form:install --bootstrap'
      else
        say_wizard "Bootstrap not found."
      end
  end
end


__END__

name: SimpleForm
description: "Check for 'simple_form'."
author: Gmgp

category: other
tags: [utilities, configuration]

run_after: [html5]

config:
  - form_option:
      type: multiple_choice
      prompt: "Which form gem would you like?"
      choices: [["None", no], ["simple form", simple_form], ["simple form (bootstrap)", simple_form_bootstrap]]
