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
  has_many :school_admins
  has_many :teachers

  before_save :update_school_unique_code
  #TODO::muktesh add field validations


    private
    def update_school_unique_code
      counter = (last_school_id + 1).to_s.rjust(4, '0')
      school_letters = (name.gsub(/\W+/, '').first(2) rescue 'AB')
      self.code = school_letters.upcase + counter
    end

    def last_school_id
      self.last.id rescue 0
    end
end
