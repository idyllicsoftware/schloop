require 'rails_helper'

RSpec.describe Api::V1::TeachersController, type: :controller do
  it "returns a teacher profile" do
  binding.pry
    get '/cats/1'
    json = JSON.parse(last_response.body)
    expect(json["data"]["id"]).to eq(1)
  end
end
