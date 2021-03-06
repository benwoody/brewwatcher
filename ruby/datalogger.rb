require File.dirname(__FILE__) + '/models'
require File.dirname(__FILE__) + '/serialcomms'
require 'time'
Datastore.connect!

begin
  tty = ActiveTty.first
  communicator = Serial::Communicator.new(tty.device)
  communicator.warmup

  temperature = communicator.get_temperature
  temperature.save
  # Connecting to arduino causes system reboot -- ensure display is off!
  communicator.disable_display
rescue => e
  File.open("#{Dir.home}/logs/datalogger_error.log", "ab") do |file|
    log_time = Time.now.strftime("[%Y-%m-%d %H:%M:%S]")
    file.puts "#{log_time} #{e.message}"
    file.puts "#{e.backtrace}"
  end
end