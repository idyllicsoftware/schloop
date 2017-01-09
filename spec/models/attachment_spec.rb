# == Schema Information
#
# Table name: attachments
#
#  id                :integer          not null, primary key
#  attachable_type   :string
#  attachable_id     :integer
#  name              :string
#  original_filename :string
#  file_size         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sub_type          :integer          default(0), not null
#

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
