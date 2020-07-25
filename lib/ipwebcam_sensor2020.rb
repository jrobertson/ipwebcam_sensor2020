#!/usr/bin/env ruby

# file: ipwebcam_sensor2020.rb

require 'json'
require 'open-uri'


class IPWebcamSensor2020

  def initialize(url, interval: 4, quiet: 150, sound_threshold: 30, 
                 debug: false)
    
    @url, @interval, @debug = url, interval, debug
    @quiet, @sound_threshold = quiet, sound_threshold
    @exe_motion, @exe_sound, @exe_motionsound = [], [], []
    
  end

  def onmotion_enter(&blk)
    @exe_motion[0] = blk if block_given?
  end

  def onmotion_leave(&blk)
    @exe_motion[1] = blk if block_given?
  end
  
  def onmotionsound_start(&blk)
    @exe_motionsound[0] = blk if block_given?
  end

  def onmotionsound_end(&blk)
    @exe_motionsound[1] = blk if block_given?
  end  
  
  def onsound_start(&blk)
    @exe_sound[0] = blk if block_given?
  end
  
  def onsound_end(&blk)
    @exe_sound[1] = blk if block_given?
  end  

  def start()

    @prev_motion, @prev_loud, @prev_motionsound = false, false, false
    @old_sound = []

    loop do 

      h = JSON.parse(open(@url).read, symbolize_names: true )

      motion = motion_active(h[:motion_active][:data])      
      sound = sound_event(h[:sound][:data])
      
      if @exe_motionsound[0] and motion and sound and not @prev_motionsound then
        @exe_motionsound[0].call
        @prev_motionsound = true
      elsif @exe_motionsound[1] and @prev_motionsound and not motion
        @exe_motionsound[1].call
        @prev_motionsound = false
      end
            
      puts h.inspect if @debug       

      sleep @interval
    end
  end

  private

  # Handles 1 or more motion_active results of value 1.0 or 0.0
  # require url to contain *sense* param with value *motion_active*
  #  
  def motion_active(a)

    rawtime, raw_motion = a.last
    time = Time.at(rawtime.to_s[0..-4].to_i)
    motion = raw_motion.first.to_i == 1
    
    if @exe_motion[0] and motion and not @prev_motion then
    
      @exe_motion[0].call() 

      
    elsif @exe_motion[1] and not motion and @prev_motion then
      
      @exe_motion[1].call() 
      
    end

    @prev_motion = motion 

    puts [time, motion] if @debug
    
    return motion == true

  end

  def sound_event(a)
    
    soundlevels = if @old_sound.any? then

      all_sound = (@old_sound + a).uniq        
      timestamp = @old_sound.last[0] 
      all_sound.reverse.take_while {|x,y| x != timestamp}.reverse
    else
      a
    end    
    
    levels = soundlevels.map do |rawtime, raw_vol|
      time = Time.at(rawtime.to_s[0..-4].to_i)
      vol = raw_vol.first
      vol
    end    
        
    threshold = @quiet + @sound_threshold = 30
    
    loud = levels.max > threshold
    puts loud ? 'noisy' : 'quiet'  if @debug  
    
    if @exe_sound[0] and loud and not @prev_loud then
    
      @exe_sound[0].call
      
    elsif @exe_sound[1] and not loud and @prev_loud
      
      @exe_sound[1].call
      
    end
    
    @prev_loud = loud
    @old_sound = a
    
    return loud == true
    
  end

end

