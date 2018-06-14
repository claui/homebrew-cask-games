module Hbc
  module Utils
    module LGOGDownloader
      class LGOGDownloaderError < StandardError
        def initialize(exit_status, invocation_args, message = nil)
          @exit_status = exit_status
          @invocation_args = invocation_args
          super(message || 'LGOGDownloader has returned an error')
        end

        def to_s
          [
            message,
            "Exit status: #{exit_status}",
            "Command-line arguments: #{invocation_args}",
          ].join("\n")
        end
      end
    end
  end
end
