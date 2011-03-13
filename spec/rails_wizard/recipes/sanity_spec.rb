require 'spec_helper'

# This is a simple set of tests to make sure that
# all of the recipes conform to the base requirements.

RailsWizard::Recipes.list_classes.each do |recipe|
  describe recipe do
    it("should have a name"){ recipe.name.should be_kind_of(String) }    
    it("should have a description"){ recipe.description.should be_kind_of(String) }
    it("should have a template"){ recipe.template.should be_kind_of(String) }
    it("should be able to compile"){ recipe.new.compile.should be_kind_of(String) }
    
    it "should have a string or nil category" do
      if recipe.category
        recipe.category.should be_kind_of(String)
      end
    end

    it "should have a Config or nil config" do
      if recipe.config
        recipe.config.should be_kind_of(RailsWizard::Config)
      end
    end

    it "should be in the list" do
      RailsWizard::Recipes.list_classes.should be_include(recipe)
      RailsWizard::Recipes.list.should be_include(recipe.key)
    end
  end
end
