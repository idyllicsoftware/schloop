# @spec/apis/teacher_api_spec.rb

require 'rails_helper'

describe "Teacher API authentication" , type: :request do

  it "Making a request without authentication" do
    get "/api/v1/teacher/profile", formate: :json
    # @response.status == 401
    # json = JSON.parse(response.body)
    expect(@response).to have_http_status(401)
    # error = {:error=>'You need to sign in or sign up before continuing.'}
    # @response.body.should  eql(error.to_json)
  end

end