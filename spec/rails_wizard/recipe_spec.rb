require 'spec_helper'

describe RailsWizard::Recipe do
  context "with a generated recipe" do
    subject{ RailsWizard::Recipe.generate('recipe_example', "# this is a test", :category => 'example', :name => "RailsWizard Example") }

    context 'string setter methods' do
      (RailsWizard::Recipe::ATTRIBUTES - ['config']).each do |setter|
        it "should be able to set #{setter} with an argument" do
          subject.send(setter + '=', "test")
          subject.send(setter).should == 'test'
        end

        it 'should be able to get the value from the instance' do
          subject.send(setter + '=', 'test')
          subject.new.send(setter).should == subject.send(setter)
        end
      end
    end

    describe '.attributes' do
      it 'should be accessible from the instance' do
        subject.new.attributes.should == subject.attributes
      end
    end

    describe '.generate' do
      it 'should work with a string and hash as arguments' do
        recipe = RailsWizard::Recipe.generate('some_key', '# some code', :name => "Example")
        recipe.superclass.should == RailsWizard::Recipe
      end

      it 'should work with an IO object' do
        file = StringIO.new <<-RUBY
# this is an example

__END__

category: example
name: This is an Example
description: You know it's an exmaple.
RUBY
        recipe = RailsWizard::Recipe.generate('just_a_test', file)
        recipe.template.should == '# this is an example'
        recipe.category.should == 'example'
        recipe.name.should == 'This is an Example'
      end

      it 'should raise an exception if the file is incorrectly formatted' do
        file = StringIO.new <<-RUBY
# just ruby, no YAML
RUBY
        lambda{RailsWizard::Recipe.generate('testing',file)}.should raise_error(ArgumentError)
      end
    end

    describe '#compile' do
      it 'should say the name' do
        subject.name = "Awesome Sauce"
        subject.new.compile.should be_include("say_recipe 'Awesome Sauce'")
      end

      it 'should include the template' do
        subject.template = "This is only a test."
        subject.new.compile.should be_include(subject.template)
      end
    end
  end

  it 'should set default attributes' do
    recipe = RailsWizard::Recipe.generate('abc','# test')

    RailsWizard::Recipe::DEFAULT_ATTRIBUTES.each_pair do |k,v|
      recipe.send(k).should == v
    end
  end

  describe ".from_mongo" do
    context "when asked for a known recipe" do
      before(:all) do
        @recipe_key = 'recipe_example'
        @recipe = RailsWizard::Recipe.generate(@recipe_key, '# this is a test', {
            :category => 'example',
            :name     => 'RailsWizard Example',
            } )
        RailsWizard::Recipes.add(@recipe)
        @recipe_klass = Kernel.
            const_get('RailsWizard'  ).
            const_get('Recipes'      ).
            const_get('RecipeExample')
      end

      context "by key" do
        it "returns the recipe" do
          RailsWizard::Recipe.from_mongo(@recipe_key).should == @recipe_klass
        end
      end
      context "by class" do
        it "returns the recipe" do
          RailsWizard::Recipe.from_mongo(@recipe_klass).should == @recipe_klass
        end
      end
    end

    context "when asked for an unknown recipe" do
      it "raises an UnknownRecipeError" do
        expect { RailsWizard::Recipe.from_mongo("foo") }.to raise_error RailsWizard::UnknownRecipeError, "No recipe found with name 'foo'"
      end
    end
  end
end

__END__

this is a test
