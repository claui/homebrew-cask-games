cask 'bundesfighter' do
  version '1.0'
  sha256 'a199ef0f750e320c7a16d3bc4c607fef188825e4aa726ad9452622f757d6e704'

  url 'http://bundesfighter.de/download/bundes_mac.app.zip'
  name 'Bundes Fighter II Turbo'
  homepage 'http://bundesfighter.de'

  app 'bundes_mac.app', target: 'Bundes Fighter II Turbo.app'
end
