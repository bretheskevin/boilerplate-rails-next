require "rails_helper"

describe User do
  describe "soft delete" do
    let!(:user) { create(:user) }

    before { user.destroy }

    it "sets the deleted_at column" do
      expect(user.deleted_at).not_to be_nil
    end

    it "reduces the count of active users" do
      expect(described_class.count).to eq(0)
    end

    it "maintains the count of all users, including deleted" do
      expect(described_class.with_deleted.count).to eq(1)
    end
  end
end
