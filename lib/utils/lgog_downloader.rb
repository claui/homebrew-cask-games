require_relative './lgog_downloader/constants.rb'
require_relative './lgog_downloader/game_details_cache.rb'
require_relative './lgog_downloader/game_details_map.rb'
require_relative './lgog_downloader/lgog_downloader_error.rb'

module Hbc
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

      def self.installer_url(game_name, installer_id)
        installer = games_map[game_name]
                    .installers_map[installer_id]
        url_options = { cookies: cookies }
        odebug [installer.download_url, url_options].inspect
        [installer.download_url, url_options]
      end

      def self.rename_artifact!(cask, game_name, installer_id)
        game = games_map[game_name]
        installer = game.installers_map[installer_id]
        target_name = installer.path.split('/').last

        args = [
                 '--',
                 "#{cask.staged_path}/#{installer.id}",
                 "#{cask.staged_path}/#{target_name}",
               ]
        return target_name if system '/bin/mv', *args
        raise LGOGDownloaderException
      end
    end
  end
end
