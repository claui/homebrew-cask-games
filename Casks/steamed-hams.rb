cask 'steamed-hams' do
  version '1.0'
  sha256 '63b4460c43636b162439e8689b10b8a8d5dafb50ca7509add47c70e1fb74f58d'

  # nil was verified as official when first introduced to the cask
  url do
    json, _ = curl_output('-X', 'POST', "#{homepage}/file/735374")
    JSON.parse(json).fetch('url')
  end
  name 'Steamed Hams'
  homepage 'https://monsterjail.itch.io/steamedhams'

  depends_on formula: 'icoutils'
  depends_on formula: 'wine'

  app 'Steamed Hams.app'

  preflight do
    base_name = @cask.name.first
    app_bundle = staged_path / "#{base_name}.app"
    libexec = @cask.sourcefile_path.parent.parent / 'libexec'

    FileUtils.mkdir_p app_bundle / 'Contents' / 'MacOS'
    FileUtils.mkdir_p app_bundle / 'Contents' / 'Resources'
    FileUtils.mkdir_p staged_path / 'Steamed Hams.iconset'

    system_command '/bin/cp',
                   args: [
                           '--',
                           libexec / "launch_#{@cask.token}.bash",
                           app_bundle / 'Contents' / 'MacOS' / base_name,
                         ]

    system_command Formula['icoutils'].opt_bin / 'wrestool',
                   args: [
                           '-x', '-t', 'group_icon',
                           '-o', staged_path / 'icon_16x16.ico',
                           '--', staged_path / 'SteamedHams.exe',
                         ]

    system_command Formula['icoutils'].opt_bin / 'icotool',
                   args: [
                           '-x', '--icon',
                           '-o', staged_path / 'Steamed Hams.iconset' / 'icon_16x16.png',
                           '--', staged_path / 'icon_16x16.ico',
                         ]

    system_command '/usr/bin/iconutil',
                   args: [
                           '-c', 'icns',
                           '--', staged_path / 'Steamed Hams.iconset',
                         ]

    system_command '/bin/mv',
                   args: [
                           '-v', '--',
                           staged_path / 'Steamed Hams.icns',
                           staged_path / 'SteamedHams.exe',
                           staged_path / 'data.win',
                           app_bundle / 'Contents' / 'Resources',
                         ]

    FileUtils.chmod '+x', app_bundle / 'Contents' / 'MacOS' / base_name

    IO.write app_bundle / 'Contents' / 'Info.plist', <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>CFBundleIdentifier</key>
          <string>io.itch.monsterjail.steamed-hams</string>
          <key>CFBundleName</key>
          <string>#{base_name}</string>
          <key>CFBundleDisplayName</key>
          <string>#{base_name}</string>
          <key>CFBundleExecutable</key>
          <string>#{base_name}</string>
          <key>CFBundleIconFile</key>
          <string>#{base_name}</string>
          <key>CFBundleVersion</key>
          <string>#{@cask.version}</string>
          <key>CFBundleShortVersionString</key>
          <string>#{@cask.version}</string>
          <key>CFBundlePackageType</key>
          <string>APPL</string>
          <key>CFBundleSignature</key>
          <string>hams</string>
          <key>NSHumanReadableCopyright</key>
          <string>MonsterJail (https://monsterjail.itch.io)</string>
        </dict>
      </plist>
    EOS

    FileUtils.touch app_bundle
  end

  uninstall signal: [
                      ['TERM', 'io.itch.monsterjail.steamed-hams'],
                      ['KILL', 'io.itch.monsterjail.steamed-hams'],
                    ],
            trash: '~/Library/Application Support/Steamed Hams/wine'

  zap trash: '~/Library/Application Support/Steamed Hams'
end
