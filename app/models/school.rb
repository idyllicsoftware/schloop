# == Schema Information
#
# Table name: schools
#
#  id                 :integer          not null, primary key
#  name               :string           not null
#  address            :text             not null
#  zip_code           :string           not null
#  phone1             :string           not null
#  phone2             :string
#  website            :string           not null
#  school_director_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  code               :string           not null
#

class School < ActiveRecord::Base
  belongs_to :school_director, class_name: 'Teacher'

  #TODO::muktesh add field validations
end
