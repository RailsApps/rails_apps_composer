require 'bundler'
Bundler.setup
require 'rspec'

Dir[File.dirname(__FILE__) + '/support/*'].each{|path| require path}

require 'rails_wizard'

RSpec.configure do |config|

end
