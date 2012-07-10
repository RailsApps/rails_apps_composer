gem 'turnip', :group => [:test]

after_bundler do
  append_to_file '.rspec', '-r turnip/rspec'
  create_file 'spec/acceptance/steps/.gitkeep'
end

__END__

name: Turnip
description: "Gherkin extension for RSpec"
author: listrophy,mathias

requires: [rspec]
run_after: [rspec]
exclusive: acceptance_testing 
category: testing
tags: [acceptance]
