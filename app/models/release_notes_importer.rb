module ReleaseNotesImporter
  def self.import(gem_name)
    release_notes, file_name = ReleaseNotesFetcher.fetch(gem_name)

    versions = pull_apart_release_notes(release_notes)

    create_needed_versions(versions, file_name, gem_name)
  end

  private

  def self.pull_apart_release_notes(release_notes)
    # TODO: Parse the file and return a has like { '0.0.1' => "..." }
  end

  def self.create_needed_versions(versions, file_name, gem_name)
    gem = RubyGem.where(name: gem_name).first
    latest_known_version = Gem::Version.new(gem.current_version.number)

    versions.each do |version_number, release_notes|
      return if Gem::Version.new(version_number) <= latest_known_version

      extension = file_name.rpartition('.').last
      extension = nil if extension == file_name.partition('.').first

      gem.versions.create(
        number: version_number,
        release_notes: release_notes,
        file_extension: extension
      )
    end
  end
end
