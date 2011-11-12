# == Schema Information
#
# Table name: votevents
#
#  id          :integer         not null, primary key
#  ventpost_id :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_votevents_on_ventpost_id  (ventpost_id)
#  index_votevents_on_user_id      (user_id)
#

class Votevent < ActiveRecord::Base
	attr_accessible :ventpost_id

  belongs_to :user
	belongs_to :ventpost

	validates :ventpost_id, :presence => true
	validates :user_id, :presence => true
end
