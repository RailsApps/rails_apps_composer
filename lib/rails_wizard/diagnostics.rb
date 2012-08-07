module RailsWizard
  module Diagnostics
    # collections of recipes that are known to work together
    @@diagnostics = []
    @@diagnostics << ["setup", "gems"].sort
    @@diagnostics << ["setup", "gems", "readme"].sort
  
    def self.list
      @@diagnostics
    end
  end
end