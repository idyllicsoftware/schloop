# @spec/apis/teacher_api_spec.rb

require 'rails_helper'
require 'pry'

describe "Teacher API authentication" , type: :request do

  context 'Sign in Teacher,' do
    before(:each) do
      @teacher_role = create(:role, :teacher)
      @teacher = create(:teacher)
      @headers = {'Authorization' => "Token #{@teacher.token}"}
    end

    it "returns a teacher profile" do
      get '/api/v1/teacher/profile', nil, @headers

      expect(response.status).to eq(200)

      json = JSON.parse(response.body)
      expect(json["data"]["profile"]["id"]).to eq(@teacher.id)
      expect(json["data"]["profile"]["email"]).to eq(@teacher.email)
    end
  end

  context 'Sign UP Teacher,' do
    before(:each) do
      @teacher_role = create(:role, :teacher)
      @school = create(:school)
    end

    it "Register a teacher" do
      teacher_attrs = attributes_for(:teacher)
      teacher_attrs.merge!(school_code: @school.code)
      post '/api/v1/teacher/register', {teacher: teacher_attrs}
      expect(response.status).to eq(200)
    end

    it "returns a error, if invalid school code passed." do
      teacher_attrs = attributes_for(:teacher)
      teacher_attrs.merge!(school_code: "ABCD001")
      post '/api/v1/teacher/register', {teacher: teacher_attrs}
      expect(response.status).to eq(200)

      json = JSON.parse(response.body)
      expect(json["error"]["code"]).to eq(0)
      expect(json["error"]["message"]).to eq(["Invalid School code"])
    end
  end

end