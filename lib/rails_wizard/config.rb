require 'active_support/ordered_hash'

module RailsWizard
  class Config
    attr_reader :questions

    def initialize(schema)
      @questions = ActiveSupport::OrderedHash.new
      schema.each do |hash| 
        key = hash.keys.first
        details = hash.values.first

        kind = details['type']
        raise ArgumentError, "Unrecognized question type, must be one of #{QUESTION_TYPES.keys.join(', ')}" unless QUESTION_TYPES.keys.include?(kind)
        @questions[key] = QUESTION_TYPES[kind].new(details)
      end
    end

    def compile(values = {})
            
    end

    class Question
      def initialize(schema)
      end
    end
    
    class Prompt
      def initialize(details)

      end
    end

    class TrueFalse < Question
      def compile
        "wizard_yes?(#{prompt.inspect})"
      end
    end

    class MultipleChoice < Question
    end

    QUESTION_TYPES = {
      'boolean' => TrueFalse,
      'string' => Prompt,
      'multiple_choice' => MultipleChoice
    }
  end
end
