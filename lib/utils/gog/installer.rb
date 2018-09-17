module Cask
  module Utils
    module GOG
      class Installer
        DOWNLOAD_BASE_URL = 'https://www.gog.com/downlink'.freeze

        attr_reader :gamename, :id, :language, :name,
                    :path, :platform

        def download_url
          "#{DOWNLOAD_BASE_URL}/#{gamename}/#{id}"
        end

        def initialize(hash)
          @gamename = hash[:gamename]
          @id = hash[:id]
          @language = hash[:language]
          @name = hash[:name]
          @path = hash[:path]
          @platform = hash[:platform]
        end
      end
    end
  end
end
