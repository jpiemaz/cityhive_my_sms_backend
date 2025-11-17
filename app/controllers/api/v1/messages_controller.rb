# frozen_string_literal: true

module Api
  module V1
    class MessagesController < Api::V1::ApplicationController
      before_action :authenticate_user!

      def index
        messages = current_user.messages.all
        render json: messages, status: :ok
      end

      def create
        message = current_user.messages.new(message_params)
        response = message.send_to_twilio
        if response.status == "queued" && message.save!
          render json: message, status: :created
        else
          render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def message_params
        params.require(:message).permit(:text, :phone_number)
      end
    end
  end
end
