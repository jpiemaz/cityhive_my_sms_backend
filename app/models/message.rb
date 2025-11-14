class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  field :phone_number, type: String
  field :text, type: String
  belongs_to :user
end
