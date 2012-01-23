module ReleaseNotesImporter
  def self.import(gem_name)
    release_notes, file_name = ReleaseNotesFetcher.fetch(gem_name)

    file_extension = FileExtension.from_file_name(file_name)

    versions = ReleaseNotesParser.parse(release_notes, file_extension)

    create_needed_versions(versions, file_extension.to_s, gem_name)
  end

  private

  def self.create_needed_versions(versions, file_extension, gem_name)
    gem = RubyGem.where(name: gem_name).first
    latest_known_version = Gem::Version.new(gem.current_version_number)

    versions.each do |version_number, release_notes|
      version_number = version_number.dup # In case it's frozen

      return if Gem::Version.new(version_number) <= latest_known_version

      gem.versions.create(
        number: version_number,
        release_notes: release_notes,
        file_extension: file_extension
      )
    end
  end
end
