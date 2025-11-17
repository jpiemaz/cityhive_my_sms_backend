require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) { create(:user) }

  describe "associations" do
    it "belongs to a user" do
      message = Message.new(text: "Hello", phone_number: "+15555550123", user: user)
      expect(message.user).to eq(user)
    end
  end

  describe "validations" do
    it "is valid with text and phone_number" do
      message = Message.new(text: "Hello", phone_number: "+15555550123", user: user)
      expect(message).to be_valid
    end

    it "is invalid without text" do
      message = Message.new(text: nil, phone_number: "+15555550123", user: user)
      expect(message).not_to be_valid
      expect(message.errors[:text]).to include("can't be blank")
    end

    it "is invalid without phone_number" do
      message = Message.new(text: "Hello", phone_number: nil, user: user)
      expect(message).not_to be_valid
      expect(message.errors[:phone_number]).to include("can't be blank")
    end

    it "is invalid without a user" do
      message = Message.new(text: "Hello", phone_number: "+15555550123", user: nil)
      expect(message).not_to be_valid
      expect(message.errors[:user]).to include("can't be blank")
    end
  end
end
