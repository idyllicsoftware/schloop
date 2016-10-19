# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  type                   :string           default("SchoolAdmin"), not null
#  first_name             :string
#  middle_name            :string
#  last_name              :string
#  work_number            :string
#  cell_number            :string
#  user_token             :string
#  school_id              :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_user_token            (user_token)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :school
  validates :first_name, :presence => true, :length => { :maximum => 30 }
  validates :middle_name,  :length => { :maximum => 30 }
  validates :last_name, :presence => true, :length => { :maximum => 30 }
  # validates :work_number, :presence => true, numericality: { only_integer: true }, :length => { :maximum => 15 }
  # validates :cell_number, :presence => true, numericality: { only_integer: true }, :length => { :maximum => 15 }

  before_save :set_user_token

  def set_user_token
    return if user_token.present?
    self.user_token = generated_user_token
  end

  def generated_user_token
    SecureRandom.uuid.gsub(/\-/,'')
  end

end
