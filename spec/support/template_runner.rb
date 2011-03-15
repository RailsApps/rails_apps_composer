class TemplateRunner
  attr_reader :template, :config, :app_name, :dir, :rails_dir, :output
  def initialize(template, config)
    @template = template
    @config = config
  end

  def run(app_name = 'rails_app')
    @app_name = app_name
    @dir = Dir.mktmpdir
    @rails_dir = File.join(@dir, @app_name)
    Dir.chrdir(@dir) do
      template_file = File.open 'template.rb', 'w'
      template_file.write
      template_file.close
      @output = `rails new #{@app_name} -m template.rb`
    end
    @output
  end

  def rails
    RailsDirectory.new(@rails_dir)
  end

  def clean
    FileUtils.remove_entry_secure @dir
  end
end
