# coding: utf-8

require 'active_support'
require 'active_support/core_ext/object'
require 'net/sftp'

require 'cosmic_rdf/constants'

module CosmicRdf
  # COSMIC file downloader
  #
  # @example
  #   dl = CosmicRdf::Downloader.new(
  #     'koichiro.yamada@genomedia.jp',
  #     '****',
  #     grch: 37
  #   )
  #   dl.download(dest_dir, only: %i[mutation cna fusion])
  class Downloader
    attr_reader :email, :password, :version, :grch

    def initialize(email, password, version: LATEST_VERSION, grch: DEFAULT_GRCH)
      raise ArgumentError, "Invalid version: #{version}" unless
        version.in? AVAILABLE_VERSIONS
      raise ArgumentError, "Invalid grch: #{grch}" unless
        grch.in? AVAILABLE_GRCH
      @email    = email
      @password = password
      @version  = "v#{version}"
      @grch     = "grch#{grch}"
    end

    def download(dest_dir, only: [], except: [])
      FileUtils.mkpath(dest_dir) unless Dir.exist? dest_dir

      files =
        if only.present?
          FILES.select { |k, _| k.in? only }.values
        elsif except.present?
          FILES.reject { |k, _| k.in? except }.values
        else
          FILES.values
        end

      Net::SFTP.start(SFTP_HOST, email, password: password) do |cli|
        files.each do |file|
          src  = File.join('cosmic', grch, 'cosmic', version, file)
          dest = File.join(dest_dir, file)
          puts "src #{src}"
          puts "dest #{dest}"
          cli.download!(src, dest)
        end
      end
    end
  end
end
