require 'delegate'
require 'json'

module Hbc
  module Utils
    module LGOGDownloader
      class GameDetailsCache < SimpleDelegator
        attr_reader :binary_path, :cache_path, :game_details_map

        def load_from_file
          hash = File.open(cache_path) do |io|
            JSON.parse(io.read, symbolize_names: true)
          end
          GameDetailsMap.new(hash)
        end

        def refresh_cache!
          return if system(binary_path, '--no-color',
                           '--update-cache')
          raise LGOGDownloaderError
        end

        def stale?
          timestamp + (60 * 60) < Time.now
        end

        def with_warning
          yield
        rescue LGOGDownloaderError => e
          warn "Warning: #{e.message}."
          warn 'Continuing with cached version from ' +
               game_details_map.timestamp.strftime('%F %H:%M')
        end

        def initialize(options = {})
          @binary_path = options.fetch(:binary_path)
          @cache_path = options.fetch(:cache_path)

          refresh_cache! unless File.exist?(@cache_path)
          super(load_from_file)
          return unless stale?

          with_warning do
            refresh_cache!
            __setobj__(load_from_file)
          end
        end
      end
    end
  end
end
