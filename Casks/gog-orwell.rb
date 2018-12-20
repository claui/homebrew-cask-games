cask 'gog-orwell' do
  version '1.2.6771.29757.22335'
  sha256 '0f137be625e07190ceda37a11d5c8be8c7f65afb62109d2370a7e5842e0051c9'

  require 'utils/lgog_downloader'

  # nil was verified as official when first introduced to the cask
  url do
    installer = Utils::LGOGDownloader
                .game('orwell')
                .installer('en2installer0')
    Utils::LGOGDownloader.url(installer)
  end
  name 'Orwell'
  homepage 'https://www.gog.com/game/orwell'

  depends_on formula: 'lgogdownloader'
  container type: :pkg

  app 'Orwell.app'

  preflight do
    installer = Utils::LGOGDownloader
                .game('orwell')
                .installer('en2installer0')
    Utils::LGOGDownloader.rename_artifact! self, installer

    system_command '/usr/sbin/pkgutil',
                   args: [
                           '--expand',
                           staged_path / "orwell_enUS_#{version.dots_to_underscores}.pkg",
                           staged_path / 'pkg',
                         ]
    system_command '/bin/mv',
                   args: [
                           staged_path / 'pkg/package.pkg/Scripts/payload',
                           staged_path / 'Orwell.app',
                         ]
  end
end
