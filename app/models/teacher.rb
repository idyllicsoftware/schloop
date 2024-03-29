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
#  token                  :string
#  first_name             :string
#  middle_name            :string
#  last_name              :string
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
  include DeviseInvitable::Inviter
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :first_name, :presence => true, :length => { :maximum => 30 }
  validates :middle_name,  :length => { :maximum => 30 }
  validates :last_name, :presence => true, :length => { :maximum => 30 }
  validates :cell_number, :presence => true,
            :numericality => true,
            :length => {:minimum => 10, :maximum => 15}

  has_and_belongs_to_many :schools
  has_many :comments
  has_many :grade_teachers, dependent: :destroy
  has_many :activity_shares
  has_many :topics, dependent: :destroy
  has_many :devices, as: :deviceable, dependent: :destroy

  before_save :set_token
  after_create :send_invitation
  after_create :add_roles

  def set_token
    return if token.present?
    self.token = generated_token
  end

  def send_invitation
    Admin::AdminMailer.delay.welcome_message(self.email, self.first_name, self.password, "schloopteacher")
  end


  def password_required?
    new_record? ? false : super
  end

  def no_grade_assigned?
    self.grade_teachers.blank?
  end

  def associated_students(search_params = {})
    filtered_student_ids = []
    division_ids = self.grade_teachers.pluck(:division_id).uniq
    student_ids = StudentProfile.where(division_id: division_ids).pluck(:student_id)
    associated_students = Student.where(id: student_ids)
    if search_params.present?
      search_params[:names].each do |name|
        filtered_student_ids += associated_students.where("first_name ILIKE ?", "%#{name}%").ids
        filtered_student_ids += associated_students.where("last_name ILIKE ?", "%#{name}%").ids
      end
      associated_students = Student.where(id: filtered_student_ids.uniq)
    end
    return associated_students
  end

  def associated_parents(student_name = nil)
    parents_data, search_params = [], {}
    if student_name.present?
      student_name = student_name.strip
      names = student_name.split(" ")
      search_params[:names] = names
      searched_students = associated_students(search_params)
    else
      searched_students = associated_students
    end

    students = searched_students.includes(:parent, student_profiles: [:grade, :division]).order(:first_name, :last_name).limit(50)

    students.each do |student|
      parents_data << {
        student_id: student.id,
        parent_id: student.parent.id,
        student_name: student.name,
        parent_name: student.parent.name,
        parent_mobile: student.parent.cell_number,
        parent_email: student.parent.email,
        grade: {
          grade_id: student.student_profiles.last.grade_id,
          grade_name: student.student_profiles.last.grade.name
        },
        division: {
          division_id: student.student_profiles.last.division_id,
          division_name: student.student_profiles.last.division.name
        }
      }
    end

    return parents_data
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

  def send_password_reset
    token = generated_token
    self.reset_password_token = token
    self.reset_password_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver

  end
end
