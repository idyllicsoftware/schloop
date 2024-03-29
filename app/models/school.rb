# == Schema Information
#
# Table name: schools
#
#  id             :integer          not null, primary key
#  name           :string           not null
#  address        :text             not null
#  zip_code       :string           not null
#  phone1         :string           not null
#  phone2         :string
#  website        :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  code           :string           not null
#  board          :string
#  principal_name :string
#  logo           :string
#

class School < ActiveRecord::Base

  has_many :school_admins, dependent: :destroy
  has_and_belongs_to_many :teachers, dependent: :destroy
  has_many :grades, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :parent_details, dependent: :destroy
  has_many :ecirculars, dependent: :destroy
  has_many :activity_shares, dependent: :destroy
  belongs_to :school_director, class_name: 'Teacher'

  before_save :update_school_unique_code

  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :address, :presence =>true, :length => { :maximum => 300 }
  validates :zip_code, :presence => true, numericality: { only_integer: true }, :length => { :is => 6 }
  validates :phone1, :presence => true, numericality: { only_integer: true },  :length => { :maximum => 15 } 
  validates :phone2, :length => { :maximum => 15 }
  validates :website, :presence => true, :length => { :maximum => 100 }
  validates :board, presence: :true
  #validates :code, :presence => true, :uniqueness => true, :length => { :is => 6}
 
  private

    def update_school_unique_code
      counter = (last_school_id + 1).to_s.rjust(4, '0')
      school_letters = (name.gsub(/\W+/, '').first(2) rescue 'AB')
      self.code = school_letters.upcase + counter
    end

    def last_school_id
      School.last.id rescue 0
    end
end
