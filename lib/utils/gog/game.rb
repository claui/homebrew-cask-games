module Hbc
  module Utils
    module GOG
      class Game
        attr_reader :dlcs, :gamename, :installers, :product_id,
                    :title

        def installers_map
          @installers_map ||= begin
            mappings = installers.map do |installer_properties|
              [
                installer_properties.fetch(:id),
                Installer.new(installer_properties),
              ]
            end
            Hash[mappings]
          end
        end

        def initialize(hash)
          @dlcs = hash[:dlcs]
          @gamename = hash[:gamename]
          @installers = hash[:installers]
          @product_id = hash[:product_id]
          @title = hash[:title]
        end
      end
    end
  end
end
