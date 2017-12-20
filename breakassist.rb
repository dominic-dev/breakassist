#!/usr/bin/env ruby
# For personal use on Ubuntu

# Check if xdotool is installed.
begin
  # get the id of the current window for activating it after the break.
  windowID = %x'xdotool getactivewindow'
rescue SystemCallError
  puts "xdotool is not properly installed.

  Install by running
    $ sudo apt-get install xdotool

exiting.
  "
  abort
end

# Help message
def usage
  puts "Break assist: A tool for helping you take scheduled breaks
usage: ruby breakassist.rb [delay] [-h, --help]
  delay        specify time in minutes between breaks 
  -h, --help   this message"
end

if ['--help', '-h'].include? ARGV[0]
  usage
  abort
end

# Core functionality.
def main
  # read the argument and reset counter 
  delay = ARGV[0].to_i
  counter = 0

  # if no valid argument has been passed
  if delay < 1
    # Display help 
    usage 
    # user input
    until delay >= 1
      puts "
Please specify the time between breaks (in minutes):" 
      delay = STDIN.gets.to_i
    end
  end


  # Start counting 
  while true do
    %x"notify-send 'Break assist' 'Taking a break every #{delay} minutes'"
    puts "
***********************************
Break assist has started.
Taking a break every #{delay} minutes
***********************************

#{delay} minutes remaining..."

    while counter < delay do
      sleep(60)
      counter += 1
      puts "#{delay-counter} minutes remaining..."
      # If delay is 10 minutes or more give a 5 minute heads up
      if delay - counter == 5
        %x"notify-send 'Break assist' 'In 5 minutes...'"
      end

    end

    # minimize all windows
    %x'xdotool key Control_L+Super_L+d'
    # notification
    %x"notify-send 'Break assist' 'Tijd om te pauzeren.'"
    puts "
Break time!
press enter to continue"

    # activate the window running the program
    # so the counter can be easily started again
    %x"xdotool windowactivate #{windowID}"
    STDIN.gets
    counter = 0
  end
end

if __FILE__ == $0
  main()
end
