class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  field :phone_number, type: String
  field :text, type: String
  belongs_to :user

  def send_to_twilio(text, phone_from = "+18332611586", phone_to = "+18777804236")
    client = Twilio::REST::Client.new(account_sid, auth_token)
    client.messages.create(
      body: text,
      to: phone_to, # Text this number
      from: phone_from, # From a valid Twilio number
    )
  end
end
