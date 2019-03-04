cask 'gog-chuchel' do
  version '2.0.0.26125'
  sha256 '3c582e76bdb1dc44cfdcf83eacb27f5b88fd3c7f27449d3d0c2bfb4e57f5135a'

  require 'utils/lgog_downloader'

  # nil was verified as official when first introduced to the cask
  url do
    installer = Utils::LGOGDownloader
      .game('chuchel')
      .installer('en2installer0')
    Utils::LGOGDownloader.url(installer)
  end
  name 'CHUCHEL'
  homepage 'https://www.gog.com/game/chuchel'

  depends_on formula: 'lgogdownloader'
  container type: :naked

  app 'CHUCHEL.app'

  preflight do
    installer = Utils::LGOGDownloader
      .game('chuchel')
      .installer('en2installer0')
    Utils::LGOGDownloader.rename_artifact! self, installer

    system_command '/usr/sbin/pkgutil',
                   args: [
                           '--expand',
                           staged_path / "chuchel_enUS_#{version.dots_to_underscores}.pkg",
                           staged_path / 'pkg'
                         ]
    system_command '/bin/mv',
                   args: [
                           staged_path / 'pkg/package.pkg/Scripts/payload',
                           staged_path / 'CHUCHEL.app'
                         ]
  end
end
