class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  field :phone_number, type: String
  field :text, type: String
  belongs_to :user

  ## this would come from the current_user if app/twilio account were real
  def send_to_twilio(phone_from = "+18332611586")
    client = Twilio::REST::Client.new(ENV.fetch("TWILIO_ACCOUNT_SID"), ENV.fetch("TWILIO_AUTH_TOKEN"))
    client.messages.create(
      body: text,
      ## this would come from the phone_number field
      to: "+18777804236",
      from: phone_from,
    )
  end
end
