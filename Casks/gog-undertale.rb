cask 'gog-undertale' do
  version '1.08.18327'
  sha256 '53dc2e3d3557f1f68904ba6c098d5ddba87857f030fd65a0296e3d482c20a348'

  require 'utils/lgog_downloader'

  # nil was verified as official when first introduced to the cask
  url do
    installer = Utils::LGOGDownloader
                .game('undertale')
                .installer('en2installer0')
    Utils::LGOGDownloader.url(installer)
  end
  name 'Undertale'
  homepage 'https://www.gog.com/game/undertale'

  depends_on formula: 'lgogdownloader'
  container type: :pkg

  app 'Undertale.app'

  preflight do
    installer = Utils::LGOGDownloader
                .game('undertale')
                .installer('en2installer0')
    Utils::LGOGDownloader.rename_artifact! self, installer

    system_command '/usr/sbin/pkgutil',
                   args: [
                           '--expand',
                           staged_path / "undertale_enUS_#{version.dots_to_underscores}.pkg",
                           staged_path / 'pkg',
                         ]

    FileUtils.rm staged_path / "undertale_enUS_#{version.dots_to_underscores}.pkg"

    system_command '/bin/mv',
                   args: [
                           staged_path / 'pkg/package.pkg/Scripts/payload',
                           staged_path / 'Undertale.app',
                         ]
  end

  zap trash: '~/Library/Application Support/com.tobyfox.undertale/'
end
