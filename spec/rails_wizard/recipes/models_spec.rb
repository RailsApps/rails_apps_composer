require 'spec_helper'

class DummyContext
  attr_reader :preferences, :file_contents

  def after_bundler; yield; end
  def say_wizard(_); end
  def git(*_); puts 'git called'; end
  def generate(_); end
  def run(_); end
  def copy_from_repo(*_); end

  def initialize
    @preferences = []
    @file_contents = <<-USER_RB
class User < ActiveRecord::Base
  attr_accessible :name, :email, :provider, :uid
end
USER_RB
  end

  def gsub_file file, needle, replace
    if file == 'app/models/user.rb'
      @file_contents.gsub!(needle, replace)
    end
  end

  def prefer *attrs
    @preferences.include?(attrs)
  end
end

describe 'models recipe' do
  subject { DummyContext.new }
  let(:proj_root) { File.expand_path('../../../..', __FILE__) }
  describe 'security' do
    describe 'for omniauth' do
      it 'does not set uid or provider as attr_accessible' do
        subject.preferences << [:authentication, 'omniauth']
        file_under_test = File.read("#{proj_root}/recipes/models.rb")
        subject.instance_eval(file_under_test)
        subject.file_contents.should_not match(/attr_accessible.*:uid/)
        subject.file_contents.should_not match(/attr_accessible.*:provider/)
      end
    end
  end
end
