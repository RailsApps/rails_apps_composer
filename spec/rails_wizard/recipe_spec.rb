require 'spec_helper'

module RailsWizard
  module Recipes
    class RecipeExample < ::RailsWizard::Recipe
      category "example"
    end
  end
end

describe RailsWizard::Recipe do
  subject{ RailsWizard::Recipes::RecipeExample }

  context 'string setter methods' do
    (RailsWizard::Recipe::ATTRIBUTES + ['category']).each do |setter|
      it "should be able to set #{setter} with an argument" do
        subject.send(setter, "test")
        subject.send(setter).should == 'test'
      end

      it 'should be able to get the value from the instance' do
        subject.send(setter, 'test')
        subject.new.send(setter).should == subject.send(setter)
      end
    end
  end

  describe ".key" do
    it 'should be the underscored class name (without modules)' do
      subject.key.should == "recipe_example"
    end
  end

  describe '.attributes' do
    it 'should be a hash of the set attributes' do
      hash = subject::ATTRIBUTES.inject({}){|hash,att| subject.send(att, att); hash[att.to_sym] = att; hash}
      subject.attributes.should == hash
    end

    it 'should be accessible from the instance' do
      subject.new.attributes.should == subject.attributes
    end
  end

  describe '.template' do
    it 'should be the trimmed data that comes after __END__' do
      class RailsWizard::Recipes::TemplateExample < RailsWizard::Recipe; end
      RailsWizard::Recipes::TemplateExample.template.should == 'this is a test'
    end
  end

  describe '#compile' do
    it 'should say the name' do
      subject.name "Awesome Sauce"
      subject.new.compile.should be_include("say_recipe 'Awesome Sauce'")
    end

    it 'should include the template' do
      subject.template "This is only a test."
      subject.new.compile.should be_include(subject.template)
    end
  end
end

describe RailsWizard::Recipes do
  subject{ RailsWizard::Recipes }
  it '.list_classes should include recipe classes' do
    subject.list_classes.should be_include(RailsWizard::Recipes::RecipeExample)
  end

  it '.list should include recipe keys' do
    subject.list.should be_include('recipe_example')
  end

  describe '.for' do
    it 'should find for a given category' do
      RailsWizard::Recipes::RecipeExample.category 'example'
      RailsWizard::Recipes.for('example').should be_include('recipe_example')
    end
  end
end

__END__

this is a test
