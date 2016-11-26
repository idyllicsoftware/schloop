# == Schema Information
#
# Table name: teachers
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
#  school_id              :integer
#  token                  :string
#  first_name             :string
#  middle_name            :string
#  last_name              :string
#  phone                  :string
#  cell_number            :string
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default(0)
#
# Indexes
#
#  index_teachers_on_confirmation_token    (confirmation_token) UNIQUE
#  index_teachers_on_email                 (email) UNIQUE
#  index_teachers_on_invitation_token      (invitation_token) UNIQUE
#  index_teachers_on_invitations_count     (invitations_count)
#  index_teachers_on_invited_by_id         (invited_by_id)
#  index_teachers_on_reset_password_token  (reset_password_token) UNIQUE
#  index_teachers_on_token                 (token)
#

class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :school
  has_many :grade_teachers
  before_save :set_token

  def set_token
    return if token.present?
    self.token = generated_token
  end

  def generated_token
    loop do
      token = SecureRandom.uuid.gsub(/\-/,'')
      return token unless Teacher.where(token: token).first
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

end
