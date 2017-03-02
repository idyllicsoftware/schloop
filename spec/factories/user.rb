FactoryGirl.define do
  factory :user do
  	trait :school_admin do
	    email Faker::Internet.email
	    password "test123"
	    first_name Faker::Name.first_name
	    middle_name 'er' 
	    last_name "M"
	    work_number nil
	    cell_number "4555545127"
	    type "SchoolAdmin"
	    association :school, factory: :school
	end
	trait :product_admin do
	   	email "admin@muktesh.com" 
	    password "test123"
	    first_name "Product"
	    middle_name '' 
	    last_name "Admin"
	    work_number nil
	    cell_number "4555545127"
   	    type "ProductAdmin"
	    school_id nil
	end
  end
end