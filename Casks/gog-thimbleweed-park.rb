cask 'gog-thimbleweed-park' do
  version '1.0.958.19287'
  sha256 '06ef0dc7edff04d4f517c2420576d6ba0b17d7fbf603cfbac5dd9d1a458c7579'

  require 'utils/lgog_downloader'

  # nil was verified as official when first introduced to the cask
  url do
    installer = Utils::LGOGDownloader
                .game('thimbleweed_park')
                .installer('en2installer0')
    Utils::LGOGDownloader.url(installer)
  end
  name 'Thimbleweed Park'
  homepage 'https://www.gog.com/game/thimbleweed_park'

  depends_on formula: 'lgogdownloader'
  container type: :pkg

  app 'Thimbleweed Park.app'

  preflight do
    installer = Utils::LGOGDownloader
                .game('thimbleweed_park')
                .installer('en2installer0')
    Utils::LGOGDownloader.rename_artifact! self, installer

    system_command '/usr/sbin/pkgutil',
                   args: [
                           '--expand',
                           staged_path / "thimbleweed_park_enUS_#{version.dots_to_underscores}.pkg",
                           staged_path / 'pkg',
                         ]
    system_command '/bin/mv',
                   args: [
                           staged_path / 'pkg/package.pkg/Scripts/payload',
                           staged_path / 'Thimbleweed Park.app',
                         ]
  end
end
