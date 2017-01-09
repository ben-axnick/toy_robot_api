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

  it "responds to unknown routes with a minimal response" do
    response = browser.get("/")

    aggregate_failures do
      expect(response.status).to eq(404)
      expect(response.body).to be_empty
    end
  end
end
