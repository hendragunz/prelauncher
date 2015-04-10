# == Schema Information
#
# Table name: social_networks
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  provider     :string(255)
#  uid          :string(255)
#  token        :string(255)
#  token_secret :string(255)
#  raw_info     :text
#  auto_share   :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class SocialNetwork < ActiveRecord::Base
end
