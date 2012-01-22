module ReleaseNotesImporter
  def self.import(gem_name)
    release_notes, file_name = ReleaseNotesFetcher.fetch(gem_name)

    file_extension = rip_extension_off(file_name)

    versions = pull_apart_release_notes(release_notes, file_extension)

    create_needed_versions(versions, file_extension, gem_name)
  end

  private

  def self.pull_apart_release_notes(release_notes, file_extension)
    # TODO: Parse the file and return a has like { '0.0.1' => "..." }
  end

  def self.create_needed_versions(versions, file_name, gem_name)
    gem = RubyGem.where(name: gem_name).first
    latest_known_version = Gem::Version.new(gem.current_version.number)

    versions.each do |version_number, release_notes|
      return if Gem::Version.new(version_number) <= latest_known_version

      gem.versions.create(
        number: version_number,
        release_notes: release_notes,
        file_extension: file_extension
      )
    end
  end

  def self.rip_extension_off(file_name)
    return unless file_name =~ /\./
    extension = file_name.split('.').last
  end
end
