require "rails_helper"

describe Dummy do
  let(:dummy) { create(:dummy) }

  before do
    dummy
  end

  describe "has soft delete" do
    it "change deleted_at column" do
      dummy.destroy
      expect(dummy.deleted_at).not_to be_nil
    end

    it "Dummy.count change" do
      dummy.destroy
      expect(described_class.count).to eq(0)
      expect(described_class.with_deleted.count).to eq(1)
    end
  end
end
