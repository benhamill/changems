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
    def self.gunzip(data)
      require 'stringio'
      require 'zlib'
      data = StringIO.new data

      Zlib::GzipReader.new(data).read
    end

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

    module Package
      class TarReader
        def initialize(io)
          @io = io
        end

        # This method taken more or less straight from rubygems 1.8.15
        def each_entry
          loop do
            return if @io.eof?

            header = Gem::Package::TarHeader.from @io
            return if header.empty?

            entry = Gem::Package::TarReader::Entry.new header, @io
            size = entry.header.size

            yield entry

            skip = (512 - (size % 512)) % 512
            pending = size - entry.bytes_read

            begin
              # avoid reading...
              @io.seek pending, IO::SEEK_CUR
              pending = 0
            rescue Errno::EINVAL, NameError
              while pending > 0 do
                bytes_read = @io.read([pending, 4096].min).size
                raise "Unexpected EOF" if @io.eof?
                pending -= bytes_read
              end
            end

            @io.read skip # discard trailing zeros

            # make sure nobody can use #read, #getc or #rewind anymore
            entry.close
          end
        end

        # This class more or less taken straight from rubygems 1.8.15.
        class Entry
          attr_reader :header

          def initialize(header, io)
            @closed = false
            @header = header
            @io = io
            @orig_pos = @io.pos
            @read = 0
          end

          def check_closed
            raise IOError, "closed #{self.class}" if closed?
          end

          def bytes_read
            @read
          end

          def close
            @closed = true
          end

          def closed?
            @closed
          end

          def eof?
            check_closed

            @read >= @header.size
          end

          def full_name
            if @header.prefix != "" then
              File.join @header.prefix, @header.name
            else
              @header.name
            end
          rescue ArgumentError => e
            raise unless e.message == 'string contains null byte'
            raise 'tar is corrupt, name contains null byte'
          end

          def getc
            check_closed

            return nil if @read >= @header.size

            ret = @io.getc
            @read += 1 if ret

            ret
          end

          def directory?
            @header.typeflag == "5"
          end

          def file?
            @header.typeflag == "0"
          end

          def pos
            check_closed

            bytes_read
          end

          def read(len = nil)
            check_closed

            return nil if @read >= @header.size

            len ||= @header.size - @read
            max_read = [len, @header.size - @read].min

            ret = @io.read max_read
            @read += ret.size

            ret
          end

          def rewind
            check_closed

            raise "No seekable IO." unless @io.respond_to? :pos=

            @io.pos = @orig_pos
            @read = 0
          end
        end
      end

      # This class more or less taken straight from rubygems 1.8.15.
      class TarHeader
        FIELDS = [:checksum, :devmajor, :devminor, :gid, :gname, :linkname, :magic, :mode,
                  :mtime, :name, :prefix, :size, :typeflag, :uid, :uname, :version]

        PACK_FORMAT = 'a100' + # name
                      'a8'   + # mode
                      'a8'   + # uid
                      'a8'   + # gid
                      'a12'  + # size
                      'a12'  + # mtime
                      'a7a'  + # chksum
                      'a'    + # typeflag
                      'a100' + # linkname
                      'a6'   + # magic
                      'a2'   + # version
                      'a32'  + # uname
                      'a32'  + # gname
                      'a8'   + # devmajor
                      'a8'   + # devminor
                      'a155'   # prefix

        UNPACK_FORMAT = 'A100' + # name
                        'A8'   + # mode
                        'A8'   + # uid
                        'A8'   + # gid
                        'A12'  + # size
                        'A12'  + # mtime
                        'A8'   + # checksum
                        'A'    + # typeflag
                        'A100' + # linkname
                        'A6'   + # magic
                        'A2'   + # version
                        'A32'  + # uname
                        'A32'  + # gname
                        'A8'   + # devmajor
                        'A8'   + # devminor
                        'A155'   # prefix

        attr_reader(*FIELDS)

        def self.from(stream)
          header = stream.read 512
          empty = (header == "\0" * 512)

          fields = header.unpack UNPACK_FORMAT

          name     = fields.shift
          mode     = fields.shift.oct
          uid      = fields.shift.oct
          gid      = fields.shift.oct
          size     = fields.shift.oct
          mtime    = fields.shift.oct
          checksum = fields.shift.oct
          typeflag = fields.shift
          linkname = fields.shift
          magic    = fields.shift
          version  = fields.shift.oct
          uname    = fields.shift
          gname    = fields.shift
          devmajor = fields.shift.oct
          devminor = fields.shift.oct
          prefix   = fields.shift

          new :name     => name,
              :mode     => mode,
              :uid      => uid,
              :gid      => gid,
              :size     => size,
              :mtime    => mtime,
              :checksum => checksum,
              :typeflag => typeflag,
              :linkname => linkname,
              :magic    => magic,
              :version  => version,
              :uname    => uname,
              :gname    => gname,
              :devmajor => devmajor,
              :devminor => devminor,
              :prefix   => prefix,

              :empty    => empty
        end

        def initialize(vals)
          unless vals[:name] && vals[:size] && vals[:prefix] && vals[:mode] then
            raise ArgumentError, ":name, :size, :prefix and :mode required"
          end

          vals[:uid] ||= 0
          vals[:gid] ||= 0
          vals[:mtime] ||= 0
          vals[:checksum] ||= ""
          vals[:typeflag] ||= "0"
          vals[:magic] ||= "ustar"
          vals[:version] ||= "00"
          vals[:uname] ||= "wheel"
          vals[:gname] ||= "wheel"
          vals[:devmajor] ||= 0
          vals[:devminor] ||= 0

          FIELDS.each do |name|
            instance_variable_set "@#{name}", vals[name]
          end

          @empty = vals[:empty]
        end

        def empty?
          @empty
        end

        def ==(other)
          self.class === other and
          @checksum == other.checksum and
          @devmajor == other.devmajor and
          @devminor == other.devminor and
          @gid      == other.gid      and
          @gname    == other.gname    and
          @linkname == other.linkname and
          @magic    == other.magic    and
          @mode     == other.mode     and
          @mtime    == other.mtime    and
          @name     == other.name     and
          @prefix   == other.prefix   and
          @size     == other.size     and
          @typeflag == other.typeflag and
          @uid      == other.uid      and
          @uname    == other.uname    and
          @version  == other.version
        end

        def to_s
          update_checksum
          header
        end

        def update_checksum
          header = header " " * 8
          @checksum = oct calculate_checksum(header), 6
        end

        private

        def calculate_checksum(header)
          header.unpack("C*").inject { |a, b| a + b }
        end

        def header(checksum = @checksum)
          header = [
            name,
            oct(mode, 7),
            oct(uid, 7),
            oct(gid, 7),
            oct(size, 11),
            oct(mtime, 11),
            checksum,
            " ",
            typeflag,
            linkname,
            magic,
            oct(version, 2),
            uname,
            gname,
            oct(devmajor, 7),
            oct(devminor, 7),
            prefix
          ]

          header = header.pack PACK_FORMAT

          header << ("\0" * ((512 - header.size) % 512))
        end

        def oct(num, len)
          "%0#{len}o" % num
        end
      end
    end
  end
end
