class Message < ApplicationRecord

  belongs_to :inbox
  belongs_to :outbox

  validates :body, :outbox_id, :inbox_id, presence: true

  LOST_MESSAGE = "I've lost my script, please issue a new one at a charge of €10"

  class << self
    def lost_message
      LOST_MESSAGE
    end
  end

end