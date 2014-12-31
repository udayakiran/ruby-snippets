require_relative 'table'
require_relative 'robot'
require_relative 'pretty_print'
require_relative 'commander'

module RobotNavigator
  class Navigator

    attr_reader :commander
    
    def initialize(display_ouput = true)
      @table = RobotNavigator::Table.new(5, 5) #This can be read from the input to support dynamic table dimensions
      @robot = RobotNavigator::Robot.new
      @commander = RobotNavigator::Commander.new(@robot, @table, display_ouput)
    end

    def execute(command)
      return if command.strip.empty?
      @commander.execute(command)
    end
  end
end
