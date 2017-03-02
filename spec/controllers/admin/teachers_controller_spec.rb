require 'rails_helper'
#require 'rake'
#load './lib/tasks/populate_roles_and_permissions'
#load File.expand_path("../../../lib/tasks/populate_roles.rake", __FILE__)

RSpec.describe Admin::TeachersController, type: :controller do
	before(:each) do
		FactoryGirl.create(:role,:teacher)
	end
	describe "#index" do
		login_school_admin
		let(:school)	{ FactoryGirl.create(:school) }
		it "" do 
			#get :index, school_id: @school_admin.school_id
			#expect(response.status).to eq 200
		end
	end
end
