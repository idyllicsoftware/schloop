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
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default(0)
#  activation_status      :boolean
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_user_token            (user_token)
#

#

class Parent < User
  has_many :students, dependent: :destroy
  has_many :parent_details,  dependent: :destroy
  has_many :devices, as: :deviceable, dependent: :destroy

  validates :cell_number, :presence => true,
            :numericality => true,
            :length => {:minimum => 10, :maximum => 15}
  after_create :send_invitation

  validate do |parent|
    parent.students.each do |student|
      next if student.valid?
      student.errors.full_messages.each do |message|
        # you can customize the error message here:
        errors.add :base, "#{message}"
      end
    end
  end

  def send_invitation
    Admin::AdminMailer.delay.welcome_message(self.email, self.first_name, self.password, "schloopparent")
  end

  def password_required?
    new_record? ? false : super
  end

  def generated_token
    loop do
      token = SecureRandom.uuid.gsub(/\-/, '')
      return token unless Teacher.where(token: token).first
    end
  end

  def send_password_reset
    token = generated_token
    self.reset_password_token = token
    self.reset_password_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def active?
    students.active.present?
  end
end
