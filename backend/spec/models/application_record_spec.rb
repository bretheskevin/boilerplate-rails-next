require "rails_helper"

class Record < ApplicationRecord
end

describe Record do
  it "default_sort is by creation" do
    expect(described_class.default_sort).to eq("created_at DESC")
  end

  it "strong_params is an array" do
    expect(described_class.strong_params).to eq([])
  end
end
