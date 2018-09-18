cask 'gog-thimbleweed-park-dlc-ransome-unbeeped' do
  version '1.0.958.19287'
  sha256 '53a1c82cae2a951dd47dd335613c75bf1280085815dd1c455b09fda7110f6f8b'

  require 'utils/lgog_downloader'

  # nil was verified as official when first introduced to the cask
  url do
    installer = Utils::LGOGDownloader
                .game('thimbleweed_park')
                .dlc('thimbleweed_park_ransome_unbeeped')
                .installer('en2installer0')
    Utils::LGOGDownloader.url(installer)
  end
  name 'Thimbleweed Park'
  homepage 'https://www.gog.com/game/thimbleweed_park'

  depends_on formula: 'lgogdownloader'
  depends_on cask: 'gog-thimbleweed-park'
  container type: :pkg

  stage_only true

  preflight do
    installer = Utils::LGOGDownloader
                .game('thimbleweed_park')
                .dlc('thimbleweed_park_ransome_unbeeped')
                .installer('en2installer0')
    Utils::LGOGDownloader.rename_artifact! self, installer

    system_command '/usr/sbin/pkgutil',
                   args: [
                           '--expand',
                           staged_path / "dlc_ransome_unbeeped_en_#{version.dots_to_underscores}.pkg",
                           staged_path / 'pkg',
                         ]

    system_command '/bin/mv',
                   args: [
                           staged_path / 'pkg/package.pkg/Scripts/payload/ThimbleweedPark.ggpack3',
                           '/Applications/Thimbleweed Park.app/',
                         ]

    system_command '/bin/mv',
                   args: [
                           staged_path / 'pkg/package.pkg/Scripts/payload/Contents/Resources/goggame-1858019230.hashdb',
                           staged_path / 'pkg/package.pkg/Scripts/payload/Contents/Resources/goggame-1858019230.info',
                           staged_path / 'pkg/package.pkg/Scripts/payload/Contents/Resources/goggame-1858019230.script',
                           '/Applications/Thimbleweed Park.app/Contents/Resources/',
                         ]
  end

  uninstall trash: [
                     '/Applications/Thimbleweed Park.app/Contents/Resources/goggame-1858019230.*',
                     '/Applications/Thimbleweed Park.app/ThimbleweedPark.ggpack3',
                   ]
end
