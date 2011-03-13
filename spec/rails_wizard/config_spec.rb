require 'spec_helper'

describe RailsWizard::Config do
  describe '#initialize' do
    subject{ RailsWizard::Config.new(YAML.load(@schema)) }  
    it 'should add a question key for each key of the schema' do
      @schema = <<-YAML
      - test:
          type: string
      YAML
      subject.questions.should be_key('test')
    end

    it 'should instantiate the correct question type for each question' do
      @schema = <<-YAML
      - string:
          type: string
      - boolean:
          type: boolean
      - multiple_choice:
          type: multiple_choice
      YAML
      subject.questions['string'].should be_kind_of(RailsWizard::Config::Prompt)
      subject.questions['boolean'].should be_kind_of(RailsWizard::Config::TrueFalse)
      subject.questions['multiple_choice'].should be_kind_of(RailsWizard::Config::MultipleChoice)
    end

    it 'should error on invalid question type' do
      @schema = <<-YAML
      - invalid
        type: invalid
      YAML
      lambda{ subject }.should raise_error(ArgumentError)
    end
  end
end
