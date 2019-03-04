cask 'gog-chuchel' do
  version '1.0.0.19094'
  sha256 '6fe648eb33db79ce6997dcaca3c867a0fb08b0243fc2eea39b349911c542bca4'

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
