# == Schema Information
#
# Table name: ecirculars
#
#  id              :integer          not null, primary key
#  title           :string
#  body            :text
#  circular_tag    :integer
#  created_by_type :integer
#  created_by_id   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  school_id       :integer
#

require 'rails_helper'
RSpec.describe Ecircular, type: :model do
  before(:each) do
    #role = Role.create(name:"Teacher", role_map:"teacher", status:true)
    role = FactoryGirl.create(:role,:teacher)
    @school=School.create( 
      name:"Loyla", 
      address:"pune", 
      zip_code:"400103", 
      phone1:"07588584810", 
      phone2:"07588584810", 
      website:"www.loyla.com", 
      code:"LO0001", 
      board:nil, 
      principal_name:nil, 
      logo: nil)
    #@teacher = Teacher.create( 
    #    email:"supriya+1@idyllic.co", 
    #    school_id: @school.id,
    #    first_name:"Sups", 
    #    middle_name:nil, 
    #    last_name:"..", 
    #    cell_number:"5656545412")
    @teacher = FactoryGirl.create(:teacher)
    51.times{Ecircular.create(
      title:"Holiday", 
      body:"Pre-Primary section shall not function on 8/12/16 & 9/12/16 on account of Annual Art, Craft & Science Exhibition preparation.", 
      circular_tag:"holiday", 
      created_by_type:"teacher", 
      created_by_id:151, 
      school_id:@school.id)}
    @from = Ecircular.first.id
    @to = Ecircular.last.id
  end
  it "check that activities to be returned are sorted in reverse order of created_at of activity_shares" do 
    records,count = Ecircular.school_circulars(@school,@teacher,{id: (@from..@to).to_a},0,50)
    expect(count).to be <= 50   
  end
end
