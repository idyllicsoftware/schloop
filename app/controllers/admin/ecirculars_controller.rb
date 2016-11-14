class Admin::EcircularsController < ApplicationController
	def new
		
	end

	def create

		new_circular = Ecircular.create(cicular_params)
 	end
	private

	def cicular_params
 		user_type = current_user.type rescue ''
		 if user_type == 'ProductAdmin'
		 	created_by_type = Ecircular.created_by_types[:product_admin]
		 elsif user_type == 'SchoolAdmin'
		 	created_by_type = Ecircular.created_by_types[:school_admin]
		 else
		 	created_by_type = Ecircular.created_by_types[:teacher]
		 end	

		 return {
		 	title: params[:title], 
		 	body: params[:body], 
		 	circular_type: Ecircular.circular_types[params[:circular_type].to_sym], 
		 	created_by_type:created_by_type, 
		 	created_by_id: current_user.id
		 }
	end
end
