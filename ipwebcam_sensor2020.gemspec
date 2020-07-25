Gem::Specification.new do |s|
  s.name = 'ipwebcam_sensor2020'
  s.version = '0.1.0'
  s.summary = 'Fetches the motion and sound event data from the ' + 
      'IP Webcam webserver API #Android #JSON #ipwebcam #ipcam'
  s.authors = ['James Robertson']
  s.files = Dir['lib/ipwebcam_sensor2020.rb']
  s.signing_key = '../privatekeys/ipwebcam_sensor2020.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/ipwebcam_sensor2020'
end
