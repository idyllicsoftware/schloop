require 'rails_helper'
RSpec.describe Admin::Users::SessionsController, type: :controller do

	describe "#after_sign_in_path_for" do
		login_school_admin
		login_product_admin
		it "matches returned value with school admin redirection path i.e 'admin/schools/school'" do
			expect(controller.send(:after_sign_in_path_for, @school_admin)).to eq "/admin/schools/school"
		end

		it "matches returned value with school admin redirection path i.e 'admin/schools/school'" do
			expect(controller.send(:after_sign_in_path_for, @product_admin)).to eq "/admin/schools"
		end		
	end
	describe "#create" do
		context "valid input" do
			login_school_admin
			describe "for school admin" do
				it "check for responsse status to be of redirection i.e 302" do
					@request.env["devise.mapping"] = Devise.mappings[:user]
					post :create
					expect(response.status).to eq 302
				end
				it "check for redirect to '/admin/schools/school'" do
					@request.env["devise.mapping"] = Devise.mappings[:user]
					post :create
					expect(response.body).to eq "<html><body>You are being <a href=\"http://test.host/admin/schools/school\">redirected</a>.</body></html>"
				end
				it "redirect" do
					@request.env["devise.mapping"] = Devise.mappings[:user]
					post :create
					expect(response).to redirect_to('/admin/schools/school')
				end
			end

			describe "for product admin" do
				login_product_admin

				it "check for redirect to 'admin/schools" do
					@request.env["devise.mapping"] = Devise.mappings[:user]
					post :create
					expect(response.status).to eq 302
				end
				it "check for redirect to '/admin/schools'" do
					@request.env["devise.mapping"] = Devise.mappings[:user]
					post :create
					expect(response.body).to eq "<html><body>You are being <a href=\"http://test.host/admin/schools\">redirected</a>.</body></html>"
				end
				it "redirect" do
					@request.env["devise.mapping"] = Devise.mappings[:user]
					post :create
					expect(response).to redirect_to('/admin/schools')
				end
			end
		end
		context "invalid input" do
			describe "for school admin" do
				it "check for responsse status to be 200" do
					@request.env["devise.mapping"] = Devise.mappings[:user]
					post :create
					expect(response.status).to eq 200
				end
				it "not allow for invlaid credentials" do
					errors_format = { errors: "Invalid email or password"}.to_json
					@request.env["devise.mapping"] = Devise.mappings[:user]
					post :create
					expect(response.body).to eq errors_format
				end
			end
		end
	end
end
