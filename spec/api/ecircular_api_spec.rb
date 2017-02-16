# @spec/apis/ecircular_api_spec.rb

require 'rails_helper'
require 'pry'

describe "Ecircular API" , type: :request do

  context 'Ecircular for Teachers,' do
    before(:each) do
      @teacher_role = create(:role, :teacher)
      @teacher = create(:teacher)
      @headers = {'Authorization' => "Token #{@teacher.token}"}
      @division = create(:division)

    end

    it "create a ecricular" do
      create_params = attributes_for(:ecircular)

      create_params.merge!(
        recipients: {
          @division.grade.id => [@division.id]
        },
        attachments: [
          {original_file_name: 'abc.pdf', s3_url: 'http://abc.com/def/abc.pdf]'}
        ]
      )
      post '/api/v1/ecircular/create', create_params, @headers
      expect(response.status).to eq(200)
    end
    
  end



end