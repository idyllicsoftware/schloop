module ControllerMacros
	def login_school_admin
		before(:each) do
			@request.env["devise.mapping"] = Devise.mappings[:user]
			@school_admin = FactoryGirl.create(:user,:school_admin)
			sign_in @school_admin
		end
	end
	def login_product_admin
		before(:each) do
			@request.env["devise.mapping"] = Devise.mappings[:user]
			#@product_admin = FactoryGirl.create(:user,:product_admin)
			@product_admin = ProductAdmin.first
			sign_in @product_admin
		end
	end
	def login_teacher
		before(:each) do
			@request.env["devise.mapping"] = Devise.mappings[:teacher]
			@teacher = FactoryGirl.create(:teacher)
			sign_in @teacher 
		end
	end
	def login_parent
		before(:each) do
			@request.env["devise.mapping"] = Devise.mappings[:user]
			@parent = FactoryGirl.create(:parent) 
			sign_in @parent
		end
	end
end