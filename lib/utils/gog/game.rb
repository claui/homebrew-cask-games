module Cask
  module Utils
    module GOG
      class Game
        attr_reader :dlcs, :gamename, :installers, :product_id,
                    :title

        def installers_map
          @installers_map ||= begin
            mappings = installers.map do |package_properties|
              [
                package_properties.fetch(:id),
                Package.new(package_properties),
              ]
            end
            Hash[mappings]
          end
        end

        def installer(installer_id)
          installers_map.fetch(installer_id)
        end

        def dlcs_map
          @dlcs_map ||= begin
            mappings = dlcs.map do |package_properties|
              [
                package_properties.fetch(:gamename),
                Game.new(package_properties),
              ]
            end
            Hash[mappings]
          end
        end

        def dlc(dlc_name)
          dlcs_map.fetch(dlc_name)
        end

        def initialize(hash)
          @gamename = hash[:gamename]
          @product_id = hash[:product_id]
          @title = hash[:title]
          @dlcs = hash.fetch(:dlcs, [])
          @installers = hash.fetch(:installers, [])
        end
      end
    end
  end
end
