class Admin::EcircularsController < ApplicationController
	def new
		
	end

	def create
		new_circular = Ecircular.create(cicular_params)

	end
	private

	def cicular_params
		 params[:circular_type] = params[:circular_type].to_sym
		 if current_user.class.name == 'ProductAdmin'
		 	params.merge(:created_by_type =>:product_admin)
		 elsif current_user.class.name == 'SchoolAdmin'
		 	params.merge(:created_by_type =>:school_admin)
		 else
		 	params.merge(:created_by_type =>:teacher)
		 end	
		 params.merge(:created_by_id => current_user.id)
		 params.permit(:title, :body, :circular_type, :created_by_type, :created_by_id)
	end
end
