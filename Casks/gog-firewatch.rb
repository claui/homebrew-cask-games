cask 'gog-firewatch' do
  version '1.09.20961'
  sha256 'c54c15c174a5b599af5496e59faecbbeefaf1e4993e39d3d4d835b68377e264e'

  require 'utils/lgog_downloader'

  # nil was verified as official when first introduced to the cask
  url do
    installer = Utils::LGOGDownloader
                .game('firewatch')
                .installer('en2installer0')
    Utils::LGOGDownloader.url(installer)
  end
  name 'Firewatch'
  homepage 'https://www.gog.com/game/firewatch'

  depends_on formula: 'lgogdownloader'
  container type: :pkg

  app 'Firewatch.app'

  preflight do
    installer = Utils::LGOGDownloader
                .game('firewatch')
                .installer('en2installer0')
    Utils::LGOGDownloader.rename_artifact! self, installer

    system_command '/usr/sbin/pkgutil',
                   args: [
                           '--expand',
                           staged_path / "firewatch_enUS_#{version.dots_to_underscores}.pkg",
                           staged_path / 'pkg',
                         ]

    FileUtils.rm staged_path / "firewatch_enUS_#{version.dots_to_underscores}.pkg"

    system_command '/bin/mv',
                   args: [
                           staged_path / 'pkg/package.pkg/Scripts/payload',
                           staged_path / 'Firewatch.app',
                         ]
  end
end
