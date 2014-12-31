#!/usr/bin/env ruby

require_relative 'robot_navigator/navigator'

def process_input_stdin
  navigator = RobotNavigator::Navigator.new
  command = STDIN.gets
  while command
    break if command && command.chomp.downcase == "quit" #type 'quit' to exit.
    navigator.execute(command)
    command = STDIN.gets
  end
end

def process_input_file(filename)
  navigator = RobotNavigator::Navigator.new
  file = File.open(filename)
  file = file.each_line do |command|
    # Creates a fresh navigator instance and starts the commands over again 
    # if "RESET" command is found. Helps to give multiple commands 
    # independently in a single file.
    (navigator = RobotNavigator::Navigator.new) and next if command && command.chomp.downcase == "reset"
    navigator.execute(command)
  end
end

#The program execution starts here. 
#In case an argument is passed, it is treated as file path from where robot instructions can be read.
#Otherwise, instructions can be given interactively one after another.

if ARGV.length > 0
  process_input_file(ARGV.shift)
else
  print "Enter one command at once and press Return key to run. Type 'quit' to exit.\n"
  process_input_stdin
end
