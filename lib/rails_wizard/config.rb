require 'active_support/ordered_hash'

module RailsWizard
  class Config
    attr_reader :questions, :defaults

    def initialize(schema, defaults=nil)
      @questions = ActiveSupport::OrderedHash.new
      @defaults = defaults
      schema.each do |hash|
        key = hash.keys.first
        details = hash.values.first

        kind = details['type']
        raise ArgumentError, "Unrecognized question type, must be one of #{QUESTION_TYPES.keys.join(', ')}" unless QUESTION_TYPES.keys.include?(kind)
        @questions[key] = QUESTION_TYPES[kind].new(details)
      end
    end

    def compile(values = {})
      result = []
      values.merge!(defaults) if defaults
      result << "config = #{values.inspect}"
      @questions.each_pair do |key, question|
        result << "config['#{key}'] = #{question.compile} unless config.key?('#{key}') || prefs.has_key?(:#{key})"
      end
      result.join("\n")
    end

    class Prompt
      attr_reader :prompt, :details
      def initialize(details)
        @details = details
        @prompt = details['prompt']
      end

      def compile
        "#{question} if #{conditions}"
      end

      def question
        "ask_wizard(#{prompt.inspect})"
      end

      def conditions
        [config_conditions, recipe_conditions].join(' && ')
      end

      def config_conditions
        if details['if']
          "config['#{details['if']}']"
        elsif details['unless']
          "!config['#{details['unless']}']"
        else
          'true'
        end
      end

      def recipe_conditions
        if details['if_recipe']
          "recipe?('#{details['if_recipe']}')"
        elsif details['unless_recipe']
          "!recipe?('#{details['unless_recipe']}')"
        else
          'true'
        end
      end
    end

    class TrueFalse < Prompt
      def question
        "yes_wizard?(#{prompt.inspect})"
      end
    end

    class MultipleChoice < Prompt
      def question
        "multiple_choice(#{prompt.inspect}, #{@details['choices'].inspect})"
      end
    end

    QUESTION_TYPES = {
      'boolean' => TrueFalse,
      'string' => Prompt,
      'multiple_choice' => MultipleChoice
    }
  end
end
