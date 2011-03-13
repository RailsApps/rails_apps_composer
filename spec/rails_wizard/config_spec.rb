require 'spec_helper'

describe RailsWizard::Config do
  describe '#initialize' do
    subject{ RailsWizard::Config.new(@schema) }  
    it 'should add a question key for each key of the schema' do
      @schema = {
        'test' => {'type' => 'string'}, 
        'foo' => {'type' => 'boolean'}
      }
      subject.questions.should be_key('test')
    end

    it 'should instantiate the correct question type for each question' do
      @schema = {
        'string' => {'type' => 'string'},
        'boolean' => {'type' => 'boolean'},
        'multiple_choice' => {'type' => 'multiple_choice'}
      }
      subject.questions['string'].should be_kind_of(RailsWizard::Config::Prompt)
      subject.questions['boolean'].should be_kind_of(RailsWizard::Config::TrueFalse)
      subject.questions['multiple_choice'].should be_kind_of(RailsWizard::Config::MultipleChoice)
    end

    it 'should error on invalid question type' do
      @schema = {
        'invalid' => {'type' => 'invalid'}
      }
      lambda{ subject }.should raise_error(ArgumentError)
    end
  end
end
