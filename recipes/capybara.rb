gem 'capybara', :group => [:development, :test]

after_bundler do
  create_file "spec/support/capybara.rb", <<-RUBY
require 'capybara/rails'
require 'capybara/rspec'
RUBY

  create_file "spec/requests/home_spec.rb", <<-RUBY
require 'spec_helper'

describe 'visiting the homepage' do
  before do
    visit '/'
  end

  it 'should have a body' do
    page.should have_css('body')    
  end
end
RUBY
end

__END__

name: Capybara
description: "Use the Capybara acceptance testing libraries with RSpec."
author: mbleigh

requires: [rspec]
run_after: [rspec] 
exclusive: acceptance_testing 
category: testing
tags: [acceptance]
