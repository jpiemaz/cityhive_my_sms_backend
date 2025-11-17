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

        sender = SendMessage.new(message)
        unless sender.call
          render json: { errors: message.errors.full_messages.presence || [ "Twilio error" ] }, status: :unprocessable_entity
          return
        end

        if message.valid?
          message.save
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
