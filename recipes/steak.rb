gem 'steak', '>= 1.0.0.rc.1'
gem 'capybara'

after_bundler do
  generate 'steak:install'
end

__END__

category: integration_testing
name: Steak
description: "Use Steak and Capybara for integration testing."
