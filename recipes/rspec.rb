gem 'rspec-rails', '>= 2.0.1', :group => [:development, :test]

inject_into_file "config/initializers/generators.rb", :after => "Rails.application.config.generators do |g|\n" do
  "    g.test_framework = :rspec\n"
end

after_bundler do
  generate 'rspec:install'
end

__END__

name: RSpec
description: "Use RSpec for unit testing for this Rails app."
author: mbleigh

exclusive: unit_testing
category: testing

args: ["-T"]

