# Introducing the IPWebcam_sensor2020 gem

    require 'ipwebcam_sensor2020'


    url = 'http://192.168.4.175:8080/sensors.json?from=1595594259140&sense=motion_active,sound'      
    iws = IPWebcamSensor2020.new(url, sound_threshold: 30)

    #iws.onmotion_enter { puts 'hello there!' }
    #iws.onmotion_leave { puts 'goodbye!' }

    #iws.onsound_start { puts 'hey, keep it down!'}
    #iws.onsound_end { puts 'thank you!'}

    iws.onmotionsound_start { puts 'I feel your presence'}
    iws.onmotionsound_end { puts 'come back again soon'}

    iws.start

In the above example the JSON data is read every 4 seconds from the IP Webcam app's webserver running on an Android phone. If motion and sound is detected, the message *I feel your presence* is displayed. When there is no longer motion continuously detected, the message *come back again soon* is displayed.

Initially I had planned on using the *onmotion_enter* event, however motion is easily triggered if there is a sudden change in natural light. The *onsound_start* event does work, but it can be easily triggered from a noise source in any direction, not just the specific physical area you are interest in.

The default quit sound level is set to 150dB. The sound threshold by default is set to 30dB, therefore any noise above 180dB triggers the sound event.

## Resources

* Turn an old Android phone into a home security camera http://www.jamesrobertson.eu/blog/2020/jul/24/turn-an-old-android-phone-into-a-home-security-camera.html
* ipwebcam_sensor2020 https://rubygems.org/gems/ipwebcam_sensor2020

ipwebcam gem ipwebcamsensor2020 sensor motion sound trigger detection ipcam
