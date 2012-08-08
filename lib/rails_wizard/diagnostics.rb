module RailsWizard
  module Diagnostics
    # collections of recipes that are known to work together
    @@recipes = []
    @@recipes << ["example"]
    @@recipes << ["setup"]
    @@recipes << ["gems", "setup"]
    @@recipes << ["gems", "readme", "setup"]
    @@recipes << ["extras", "gems", "readme", "setup"]

    # collections of preferences that are known to work together
    @@prefs = []
    @@prefs << {:database=>"sqlite", :templates=>"erb"}
    def self.recipes
      @@recipes
    end
    
    def self.prefs
      @@prefs
    end
  end
end