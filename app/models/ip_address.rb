# == Schema Information
#
# Table name: ip_addresses
#
#  id         :integer          not null, primary key
#  address    :string(255)
#  count      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class IpAddress < ActiveRecord::Base
  attr_accessible :address, :count
end
