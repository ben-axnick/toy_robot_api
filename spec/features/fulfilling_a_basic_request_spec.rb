require "spec_helper"
require "rack/test"

describe "fulfilling a basic request" do
  let(:browser) { Rack::Test::Session.new(Rack::MockSession.new(App)) }

  it "handles a /command with no parameters" do
    response = browser.get("/command")

    expect(response.body).to match_json_expression(
      robot: nil, output: nil
    )
  end

  it "handles a /command report" do
    response = browser.get(
      "/command?robot[x]=0&robot[y]=0&robot[f]=south&command=report"
    )

    expect(response.body).to match_json_expression(
      robot: {
        x: 0,
        y: 0,
        f: "SOUTH"
      },
      output: "0, 0, SOUTH"
    )
  end
end
