require 'delegate'
require 'time'

module Hbc
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
