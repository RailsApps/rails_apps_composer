gem 'steak', '>= 1.0.0.rc.1'
gem 'capybara'

after_bundler do
  generate 'steak:install'
end

__END__

name: Capybara
description: "Use the Capybara acceptance testing libraries with RSpec."
author: mbleigh

requires: [rspec]
exclusive: acceptance_testing 
category: testing
tags: [acceptance]
