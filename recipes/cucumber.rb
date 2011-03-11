gem 'cucumber-rails', :group => :test
gem 'capybara', :group => :test

after_bundler do
  generate "cucumber:install --capybara#{' --rspec' if recipes.include?('rspec')}#{' -D' unless recipes.include?('activerecord')}"
end

__END__

category: integration_testing
name: Cucumber
description: "Use Cucumber for integration testing with Capybara."
