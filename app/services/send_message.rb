# frozen_string_literal: true

class SendMessage
  attr_accessor :message

  def initialize(message)
    @message = message
  end

  # Returns true if sent successfully, false otherwise
  def call
    send_to_twilio
    true
  rescue StandardError => e
    message.errors.add(:base, "Twilio error: #{e.message}")
    false
  end

  private

  ## this would come from the current_user if app/twilio account were real
  def send_to_twilio(phone_from = "+18332611586")
    client = Twilio::REST::Client.new(ENV.fetch("TWILIO_ACCOUNT_SID"), ENV.fetch("TWILIO_AUTH_TOKEN"))
    client.messages.create(
      body: message.text,
      ## this would come from the phone_number field
      to: "+18777804236",
      from: phone_from,
    )
  end
end
