module Hbc
  module Utils
    module LGOGDownloader
      module Constants
        BINARY_PATH =
          '/usr/local/opt/lgogdownloader/bin/lgogdownloader'
          .freeze

        CACHE_PATH =
          "#{Dir.home}/.cache/lgogdownloader/gamedetails.json"
          .freeze

        COOKIES_PATH =
          "#{Dir.home}/.config/lgogdownloader/cookies.txt"
          .freeze

        COOKIE_PATTERN =
          %r{
            ^Set-Cookie:\s*([^;]*)=([^;]*).*;\s
            domain=\.gog\.com(;.*)?$
          }x

        PROBE_URL = 'https://www.gog.com/account'.freeze
      end
    end
  end
end
