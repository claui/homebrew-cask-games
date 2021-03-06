require 'utils/gog'

require_relative './lgog_downloader/constants'
require_relative './lgog_downloader/game_details_cache'
require_relative './lgog_downloader/game_details_map'
require_relative './lgog_downloader/lgog_downloader_error'

module Cask
  module Utils
    module LGOGDownloader
      include Constants

      def self.cache
        @cache ||= GameDetailsCache.new(
          binary_path: BINARY_PATH,
          cache_path:  CACHE_PATH
        )
      end

      def self.cookies
        cmd_line = ['curl', '-b', COOKIES_PATH, '-sILS', PROBE_URL]
        cookie_jar = IO.popen(cmd_line, &:read)

        cookie_jar.lines.each_with_object({}) do |line, hash|
          line.chomp.match(COOKIE_PATTERN) do |match|
            hash[match[1]] = match[2]
          end
        end
      end

      def self.games_map
        @games_map ||= begin
          mappings = cache[:games].map do |game_properties|
            [
              game_properties.fetch(:gamename),
              GOG::Game.new(game_properties),
            ]
          end
          Hash[mappings]
        end
      end

      def self.game(game_name)
        games_map.fetch(game_name)
      end

      def self.url(installer)
        [installer.download_url, { cookies: cookies }]
      end

      def self.rename_artifact!(cask, installer)
        target_name = installer.path.split('/').last
        ohai "Moving #{installer.id} to #{target_name}"

        args = [
                 '--',
                 "#{cask.staged_path}/#{installer.id}",
                 "#{cask.staged_path}/#{target_name}",
               ]
        return target_name if system '/bin/mv', *args
        raise LGOGDownloaderError.new($?, args, 'mv failed')
      end
    end
  end
end
