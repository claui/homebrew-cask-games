cask 'gog-stories-untold' do
  version '1.3'
  sha256 'c48f5d14192e4e5cb2b92c0a540ad300d71376d3faf65a50d0300dae889b1900'

  require 'utils/lgog_downloader'

  # nil was verified as official when first introduced to the cask
  url do
    installer = Utils::LGOGDownloader
                .game('stories_untold')
                .installer('en2installer0')
    Utils::LGOGDownloader.url(installer)
  end
  name 'Stories Untold'
  homepage 'https://www.gog.com/game/stories_untold'

  depends_on formula: 'lgogdownloader'
  container type: :pkg

  app 'Stories Untold.app'

  preflight do
    installer = Utils::LGOGDownloader
                .game('stories_untold')
                .installer('en2installer0')
    Utils::LGOGDownloader.rename_artifact! self, installer

    system_command '/usr/sbin/pkgutil',
                   args: [
                           '--expand',
                           staged_path / 'stories_untold_enus_gog_1_16305.pkg',
                           staged_path / 'pkg'
                         ]
    system_command '/bin/mv',
                   args: [
                           staged_path / 'pkg/package.pkg/Scripts/payload',
                           staged_path / 'Stories Untold.app'
                         ]
  end
end
