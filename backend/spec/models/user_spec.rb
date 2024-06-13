require "rails_helper"

describe User do
  describe "has soft delete" do
    let(:user) { create(:user) }

    before do
      user
    end

    it "change deleted_at column" do
      user.destroy
      expect(user.deleted_at).not_to be_nil
    end

    it "User.count change" do
      user.destroy
      expect(described_class.count).to eq(0)
      expect(described_class.with_deleted.count).to eq(1)
    end
  end
end
