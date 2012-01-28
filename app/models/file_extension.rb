class FileExtension
  def self.from_file_name(file_name)
    FileExtension.new(rip_extension_off(file_name))
  end

  def initialize(file_extension = nil)
    @file_extension = file_extension.to_s
  end

  def to_s
    @file_extension
  end

  def markdown?
    @file_extension =~ /^(md|mkdn?|mdown|markdown)$/
  end

  def rdoc?
    @file_extension =~ /^rdoc$/
  end

  def plaintext?
    @file_extension =~ /^(txt|)$/
  end

  private

  def self.rip_extension_off(file_name)
    return unless file_name =~ /\./
    extension = file_name.split('.').last
  end
end
