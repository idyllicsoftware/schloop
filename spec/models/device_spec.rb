# == Schema Information
#
# Table name: devices
#
#  id              :integer          not null, primary key
#  deviceable_id   :integer
#  deviceable_type :string
#  device_type     :integer          default(0)
#  token           :string           not null
#  os_version      :string
#  status          :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_devices_on_deviceable_type_and_deviceable_id  (deviceable_type,deviceable_id)
#

require 'rails_helper'

RSpec.describe Device, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
