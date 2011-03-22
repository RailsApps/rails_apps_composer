gem 'cucumber-rails', :group => [:development, :test]
gem 'capybara', :group => [:development, :test]

after_bundler do
  generate "cucumber:install --capybara#{' --rspec' if recipes.include?('rspec')}#{' -D' unless recipes.include?('activerecord')}"
end

__END__

name: Cucumber
description: "Use Cucumber for integration testing with Capybara."
author: mbleigh

exclusive: acceptance_testing 
category: testing
tags: [acceptance]
