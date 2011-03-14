class TemplateRunner
  def initialize(template, config)
    @template = template
    @config = config
  end

  def run(app_name = 'rails_app')
    @app_name = app_name
    @dir = Dir.mktmpdir
    @rails_dir = File.join(@dir, @app_name)
    
  end

  def clean
    FileUtils.remove_entry_secure @dir
  end
end
