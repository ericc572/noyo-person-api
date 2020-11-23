require 'rails_helper'

RSpec.describe Person, type: :model do
  describe "ensure column validations" do
    it "ensures last_name is present" do
      should validate_presence_of(:last_name)
    end

    it "ensures first_name is present" do
      should validate_presence_of(:first_name)
    end

    it "ensures email is present" do
      should validate_presence_of(:email)
    end

    it "ensures age is present" do
      should validate_presence_of(:age)
    end
  end
end
