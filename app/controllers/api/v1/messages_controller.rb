# frozen_string_literal: true

module Api
  module V1
    class MessagesController < Api::V1::ApplicationController
      before_action :authenticate_user!

      def index
        messages = current_user.messages.all
        render json: messages, status: :ok
      end
    end
  end
end
