require 'spec_helper'

describe RailsWizard::Template do
  subject{ RailsWizard::Template }
  let(:recipe){ RailsWizard::Recipe.generate('name','# test') }
  let(:defaults){ { "some_option" => "value" } }

  describe '#initialize' do
    it 'should work with classes' do
      subject.new([recipe]).recipes.should == [recipe]
    end

    it 'should accept optional defaults' do
      subject.new([recipe], defaults).defaults.should == defaults
    end
  end

  describe '#resolve_dependencies' do
    def recipe(name, opts={})
      RailsWizard::Recipe.generate(name, '', opts)
    end

    subject do
      @template = RailsWizard::Template.new([])
      @template.stub!(:recipes_with_dependencies).and_return(@recipes)
      @template.resolve_recipes.map { |r| r.key }
    end

    it 'should sort properly' do
      @recipes = [
        recipe('add_user', :run_after => ['devise']),
        recipe('devise', :run_after => ['omniauth']),
        recipe('omniauth'),
        recipe('haml'),
        recipe('compass')
      ]

      subject.index('devise').should > subject.index('omniauth')
    end

  end

  describe '#recipes_with_dependencies' do
    def r(*deps)
      mock(:Class, :requires => deps, :superclass => RailsWizard::Recipe)
    end

    subject do
      @template = RailsWizard::Template.new([]) 
      @template.stub!(:recipes).and_return(@recipes)
      @template.stub!(:recipe_classes).and_return(@recipes)
      @template
    end
    
    it 'should return the same number recipes if none have dependencies' do
      @recipes = [r, r]
      subject.recipes_with_dependencies.size.should == 2
    end

    it 'should handle simple dependencies' do
      @recipes = [r(r, r), r(r)]
      subject.recipes_with_dependencies.size.should == 5
    end

    it 'should handle multi-level dependencies' do
      @recipes = [r(r(r))]
      subject.recipes_with_dependencies.size.should == 3
    end

    it 'should uniqify' do
      a = r
      b = r(a)
      c = r(r, a, b)
      @recipes = [a,b,c]
      subject.recipes_with_dependencies.size.should == 4
    end
  end
end
