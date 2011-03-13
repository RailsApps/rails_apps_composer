require 'spec_helper'

describe RailsWizard::Template do
  it do
    puts RailsWizard::Template.new(['jquery', 'heroku', 'mongo_mapper']).compile
  end
end
