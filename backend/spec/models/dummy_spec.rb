require "rails_helper"

describe Dummy do
  let!(:dummy) { create(:dummy) }

  describe "soft delete" do
    before { dummy.destroy }

    it "sets the deleted_at column" do
      expect(dummy.deleted_at).not_to be_nil
    end

    it "reduces the count of active dummies" do
      expect(described_class.count).to eq(0)
    end

    it "maintains the count of all dummies, including deleted" do
      expect(described_class.with_deleted.count).to eq(1)
    end
  end
end
