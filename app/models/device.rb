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

class Device < ActiveRecord::Base
  validates_uniqueness_of :deviceable_id, :scope => [:deviceable_type, :device_type, :token, :status]

  belongs_to :deviceable, polymorphic: true

  enum status: {active: 0, inactive: 1}
  enum device_types: {android: 0, ios: 1}
end
