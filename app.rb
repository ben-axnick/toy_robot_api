require "sinatra/base"
require "json"
require "toy_robot"

class RobotParser
  def initialize(params)
    @params = params
  end

  def robot
    if placement
      ToyRobot::UnplacedRobot.new.place(placement)
    else
      ToyRobot::UnplacedRobot.new
    end
  end

  private

  def placement
    @params && ToyRobot::TablePlacement.place(
      @params[:x],
      @params[:y],
      @params[:f]
    )
  end
end

class SerialRobot < SimpleDelegator
  def to_h
    return unless respond_to?(:table_placement)

    {
      x: table_placement.position.x,
      y: table_placement.position.y,
      f: table_placement.orientation
    }
  end
end

class SerialResult < SimpleDelegator
  def to_h
    {
      robot: SerialRobot.new(robot).to_h,
      output: output
    }
  end
end

class App < Sinatra::Base
  get "/command" do
    content_type :json

    robot = RobotParser.new(params[:robot]).robot
    input = params[:command] || ""

    interpreter = ToyRobot::CommandInterpreter.new
    command = interpreter.process(input)

    result = SerialResult.new(command.perform(robot))

    result.to_h.to_json
  end
end
