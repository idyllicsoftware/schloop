# == Schema Information
#
# Table name: parents
#
#  id                     :integer          not null, primary key
#  email                  :string(100)      default(""), not null
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
#  first_name             :text             not null
#  last_name              :text             not null
#  guardian_type          :text             not null
#
# Indexes
#
#  index_parents_on_email                 (email) UNIQUE
#  index_parents_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe Parent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
