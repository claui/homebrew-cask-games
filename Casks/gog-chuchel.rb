cask 'gog-chuchel' do
  version '1.0.0'
  sha256 '6fe648eb33db79ce6997dcaca3c867a0fb08b0243fc2eea39b349911c542bca4'

  unless (staged_path / 'lib').exist?
    FileUtils.mkdir_p(staged_path)
    system '/bin/cp', '-R', '--',
           cask.sourcefile_path.parent.parent / 'lib', staged_path
  end
  require staged_path / 'lib/utils.rb'

  # nil was verified as official when first introduced to the cask
  url do
    Utils::LGOGDownloader.installer_url 'chuchel',
                                        'en2installer0'
  end
  name 'CHUCHEL'
  homepage 'https://www.gog.com/game/chuchel'

  depends_on formula: 'lgogdownloader'
  container type: :naked

  app 'CHUCHEL.app'

  preflight do
    Utils::LGOGDownloader.rename_artifact! self, 'chuchel',
                                           'en2installer0'
    system_command '/usr/sbin/pkgutil',
                   args: [
                           '--expand',
                           staged_path / 'chuchel_enUS_1_0_0_19094.pkg',
                           staged_path / 'pkg'
                         ]
    system_command '/bin/mv',
                   args: [
                           staged_path / 'pkg/package.pkg/Scripts/payload',
                           staged_path / 'CHUCHEL.app'
                         ]
  end
end
