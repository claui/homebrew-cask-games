require 'delegate'
require 'time'

module Cask
  module Utils
    module LGOGDownloader
      class GameDetailsMap < SimpleDelegator
        attr_reader :timestamp

        def initialize(hash)
          super(hash)
          @timestamp = Time.parse(hash[:date])
        end
      end
    end
  end
end
