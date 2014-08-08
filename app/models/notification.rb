class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :lesson

  def self.check45
  end

  def self.check00
end
