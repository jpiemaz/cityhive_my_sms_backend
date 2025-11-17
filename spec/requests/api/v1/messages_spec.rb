require 'rails_helper'

RSpec.describe "Api::V1::Messages", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }

  before(:each) { Mongoid.purge! }

  describe "GET /api/v1/messages" do
    context "when authenticated" do
      before do
        create_list(:message, 3, user: user)
      end

      it "returns the user's messages" do
        get "/api/v1/messages", headers: auth_headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.size).to eq(3)
        expect(json.first.keys).to include("_id", "text", "phone_number")
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        get "/api/v1/messages"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/messages" do
    let(:valid_params) do
      {
        message: {
          text: "Hello world",
          phone_number: "+15555550123"
        }
      }
    end

    context "when authenticated" do
      it "creates a message when Twilio succeeds" do
        # Inject service double that succeeds
        sender_double = double(call: true)
        allow(SendMessage).to receive(:new).with(instance_of(Message)).and_return(sender_double)

        post "/api/v1/messages", params: valid_params, headers: auth_headers

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["text"]).to eq("Hello world")
        expect(Message.count).to eq(1)
      end

      it "returns errors when Twilio fails" do
        # Inject service double that fails
        sender_double = double(call: false)
        allow(SendMessage).to receive(:new).with(instance_of(Message)).and_return(sender_double)

        post "/api/v1/messages", params: valid_params, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Twilio error")
      end

      it "returns errors when message validation fails" do
        # Twilio succeeds, but validation fails
        sender_double = double(call: true)
        allow(SendMessage).to receive(:new).with(instance_of(Message)).and_return(sender_double)

        post "/api/v1/messages", params: { message: { text: "", phone_number: "" } }, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Text can't be blank", "Phone number can't be blank")
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        post "/api/v1/messages", params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
