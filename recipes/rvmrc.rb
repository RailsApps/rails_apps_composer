if config['ruby_version'] && config['gemset']
  say_wizard "Using RVM: #{config['ruby_version'] + config['gemset']} ..."
  run "echo 'rvm #{config['ruby_version']}@#{config ['gemset']}' > .rvmrc" 
end

__END__

name: .rvmrc
description: "Allow the user to specify a version of ruby to use with the project."
author: devinmrn, vegetables
tags: [other]

config:
  - ruby_version:
      type: string
      prompt: "Which ruby version are you using with RVM (ex. 1.9.2-p180)?"
  - gemset:
      type: string
      prompt: "Which gemset do you want to use? (ex. default)"