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

class Parent < User
	has_many :students, :dependent => :destroy
	has_many :parent_details,  :dependent => :destroy
	after_create :send_invitaion
	
  def send_invitaion
    parent = Parent.invite!(:email => self.email)
    parent.deliver_invitation
  end	

  def password_required?
    new_record? ? false : super
  end
end
