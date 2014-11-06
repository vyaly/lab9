# == Schema Information
#
# Table name: quits
#
#  id         :integer          not null, primary key
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Quit < ActiveRecord::Base
  belongs_to :user

  validates :text, presence: true, length: { maximum: 200 }
  validates :user_id, presence: true
end
