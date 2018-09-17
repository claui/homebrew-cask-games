module Cask
  module Utils
    module LGOGDownloader
      class LGOGDownloaderError < StandardError
        attr_reader :detail_message, :exit_status, :invocation_args

        def initialize(exit_status, invocation_args, message = nil)
          @exit_status = exit_status
          @invocation_args = invocation_args
          @detail_message =
            message || 'LGOGDownloader has returned an error'
          super(@detail_message)
        end

        def to_s
          [
            detail_message,
            "Exit status: #{exit_status}",
            "Command-line arguments: #{invocation_args}",
          ].join("\n")
        end
      end
    end
  end
end
