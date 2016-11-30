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
#  cell_number            :string
#
# Indexes
#
#  index_teachers_on_email                 (email) UNIQUE
#  index_teachers_on_reset_password_token  (reset_password_token) UNIQUE
#  index_teachers_on_token                 (token)
#

class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include DeviseInvitable::Inviter
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :cell_number, :presence => true,
            :numericality => true,
            :length => {:minimum => 10, :maximum => 15}

  belongs_to :school
  has_many :grade_teachers, dependent: :destroy
  before_save :set_token
  after_create :send_invitation
  after_create :add_roles

  def set_token
    return if token.present?
    self.token = generated_token
  end

  def send_invitation
    Admin::AdminMailer.welcome_message(self.email, self.first_name, self.password).deliver_now
  end


  def password_required?
    new_record? ? false : super
  end

  def name
    "#{first_name} #{last_name} #{middle_name}"
  end

  def generated_token
    loop do
      token = SecureRandom.uuid.gsub(/\-/, '')
      return token unless Teacher.where(token: token).first
    end
  end

  def add_roles
    role = Role.find_by(name: 'Teacher')
    UserRole.create(entity_type: self.class.name, entity_id: self.id, role_id: role.id)
  end

  def name
    "#{first_name} #{last_name}"
  end

end
