require 'spec_helper'

describe RailsWizard::Recipes do
  subject{ RailsWizard::Recipes }
  let(:recipe){ RailsWizard::Recipe.generate("recipe_test", "# Testing", :name => "Test Recipe", :category => "test", :description => "Just a test.")}

  before(:all) do
    RailsWizard::Recipes.add(recipe)
  end

  it '.list_classes should include recipe classes' do
    subject.list_classes.should be_include(recipe)
  end

  it '.list should include recipe keys' do
    subject.list.should be_include('recipe_test')
  end

  describe '.for' do
    it 'should find for a given category' do
      RailsWizard::Recipes.for('test').should be_include('recipe_test')
    end
  end

  it 'should add recipes in a directory with add_from_directory' do
    subject.add_from_directory(File.join(File.dirname(__FILE__), '..', 'test_recipes'))
    subject.list.should include 'test_recipe_in_file'
  end

  describe '.clear' do
    it 'should remove all current recipes' do
      RailsWizard::Recipes.clear
      subject.list.should == []
      subject.categories.should == []
    end
  end
end
