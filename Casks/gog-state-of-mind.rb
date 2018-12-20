cask 'gog-state-of-mind' do
  version '1.1.24163.22473'
  sha256 '6a6bde2ef28c75217aae7eb1c3133f12c5d2d00b0e25b731eef7bf38ebba3113'

  require 'utils/lgog_downloader'

  # nil was verified as official when first introduced to the cask
  url do
    installer = Utils::LGOGDownloader
                .game('state_of_mind')
                .installer('en2installer0')
    Utils::LGOGDownloader.url(installer)
  end
  name 'State of Mind'
  homepage 'https://www.gog.com/game/state_of_mind'

  depends_on formula: 'lgogdownloader'
  container type: :pkg

  app 'State of Mind.app'

  preflight do
    installer = Utils::LGOGDownloader
                .game('state_of_mind')
                .installer('en2installer0')
    Utils::LGOGDownloader.rename_artifact! self, installer

    system_command '/usr/sbin/pkgutil',
                   args: [
                           '--expand',
                           staged_path / "state_of_mind_enUS_#{version.dots_to_underscores}.pkg",
                           staged_path / 'pkg',
                         ]

    FileUtils.rm staged_path / "state_of_mind_enUS_#{version.dots_to_underscores}.pkg"

    system_command '/bin/mv',
                   args: [
                           staged_path / 'pkg/package.pkg/Scripts/payload',
                           staged_path / 'State of Mind.app',
                         ]
  end
end
