module ReleaseNotesFetcher
  RELEASE_NOTES_REGEXP = /^changelog|^changes|^history/i

  def self.fetch(gem_name)
    raw_gem = fetch_raw_gem(gem_name)
    gem_data, _ = untar(raw_gem, /^data\.tar/)
    release_notes, file_name = untar(gem_data, RELEASE_NOTES_REGEXP)

    [release_notes, file_name]
  end

  private

  def self.fetch_raw_gem(gem_name)
    uri = URI.parse(Gems.info(gem_name)['gem_uri'])
    fetcher = Gem::RemoteFetcher.new

    fetcher.fetch_http(uri)
  end

  def self.untar(tar_string, file_name_matcher)
    extracted_file, file_name = nil

    Gem::Package::TarReader.new(StringIO.new(tar_string)).each_entry do |entry|
      if entry.full_name =~ file_name_matcher
        extracted_file = extract_entry(entry)
        file_name = entry.full_name
      end
    end

    [extracted_file, file_name]
  end

  def self.extract_entry(entry)
    return Gem.gunzip(entry.read) if entry.full_name =~ /\.gz$/
    entry.read
  end


  # Below code mimics the API from rubygems 1.8.15. When we can deploy to a place with
  # that version of rubygems, we can pull this out and use the real stuff. This does a
  # lot less than what rubygems does, but it'll do for now.

  module Gem
    class RemoteFetcher
      def fetch_http(uri, depth = 0)
        response = Net::HTTP.get_response(uri)

        case response
        when Net::HTTPOK, Net::HTTPNotModified
          response.body
        when Net::HTTPMovedPermanently, Net::HTTPFound, Net::HTTPSeeOther, Net::HTTPTemporaryRedirect
          raise "Too many retries for #{uri.inspect}." if depth > 10

          fetch_http(URI.parse(response['Location']), depth + 1)
        else
          raise "Bad response from #{usi.inspect}: #{reponse.message} #{response.code}"
        end
      end
    end
  end
end
