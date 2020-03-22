cask 'gog-truberbrook' do
  version '1.6.30927'
  sha256 '3076c5c23f72c6cf8c19adb7f16484248892e02ffa5b04f22c82abe0d627657e'

  require 'utils/lgog_downloader'

  # nil was verified as official when first introduced to the cask
  url do
    installer = Utils::LGOGDownloader
                .game('truberbrook')
                .installer('en2installer0')
    Utils::LGOGDownloader.url(installer)
  end
  name 'Trüberbrook'
  homepage 'https://www.gog.com/game/truberbrook'

  depends_on formula: 'lgogdownloader'
  container type: :naked

  app 'Trüberbrook.app'

  preflight do
    installer = Utils::LGOGDownloader
                .game('truberbrook')
                .installer('en2installer0')
    Utils::LGOGDownloader.rename_artifact! self, installer

    system_command '/usr/sbin/pkgutil',
                   args: [
                           '--expand',
                           staged_path / "tr_berbrook_enUS_#{version.dots_to_underscores}.pkg",
                           staged_path / 'pkg',
                         ]
    system_command '/bin/mv',
                   args: [
                           staged_path / 'pkg/package.pkg/Scripts/payload',
                           staged_path / 'Trüberbrook.app',
                         ]
  end

  zap trash: '~/Library/Application Support/Truberbrook'
end
