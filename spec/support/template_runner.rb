require 'file_utils'

class TemplateRunner
  def initialize(template, config)
    @template = template
    @config = config
  end

  def run(app_name = 'rails_app')
    @app_name = app_name
    @dir = Dir.mktmpdir
    @rails_root = File.join(@dir, @app_name)
    Dir.chdir(@dir) do |)
  end

  def rails
    RailsDirectory.new(@rails_root)
  end

  def clean
    FileUtils.remove_entry_secure @dir
  end
end
