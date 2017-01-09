require "json"
require "sinatra/base"
require "sinatra/cross_origin"
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
  register Sinatra::CrossOrigin

  configure do
    enable :cross_origin
  end

  get "/command" do
    content_type :json

    robot = RobotParser.new(params[:robot]).robot
    input = params[:command] || ""

    interpreter = ToyRobot::CommandInterpreter.new
    command = interpreter.process(input)

    result = SerialResult.new(command.perform(robot))

    result.to_h.to_json
  end

  # Assets should generally be fingerprinted, cached, and served via CDN.
  # Making an exception for the sake of saving time
  get "/assets/swagger.yml" do
    content_type "text/plain;charset=utf8"

    File.read(File.join("public", "swagger.yml"))
  end

  options "*" do
    response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"

    200
  end

  error Sinatra::NotFound do
    content_type :json

    [404, ""]
  end
end
