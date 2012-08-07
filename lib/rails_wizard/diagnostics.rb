module RailsWizard
  module Diagnostics
    # collections of recipes that are known to work together
    @@recipes = []
    @@recipes << ["gems", "setup"]
    @@recipes << ["gems", "readme", "setup"]

    # collections of preferences that are known to work together
    @@prefs = []
    @@prefs << {:git=>true, :dev_webserver=>"webrick"}
    @@prefs << {:git=>true, :dev_webserver=>"webrick", :database=>"sqlite", :templates=>"erb", :form_builder=>"none", :email=>"none"}
    def self.recipes
      @@recipes
    end
    
    def self.prefs
      @@prefs
    end
  end
end