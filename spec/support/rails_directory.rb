class RailsDirectory
  def initialize(path)
    @path = path
  end

  def file_path(path)
    File.join(@path, path)
  end

  def has_file?(path)
    File.exist?(file_path(path))
  end

  def [](path)
    File.open(file_path(path)).read
  end
end
