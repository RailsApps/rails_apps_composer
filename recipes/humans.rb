# Humans.txt application template recipe for the rails_apps_composer gem

after_bundler do

  say_wizard "Humans recipe running 'after bundler'"
  get 'https://raw.github.com/akiva/rails-application-boilerplates/master/humans.txt', 'public/humans.txt'

end

__END__

name: humans
description: "Places a humans.txt file template in public directory."
author: Akiva Levy

category: other
tags: [utilities]
