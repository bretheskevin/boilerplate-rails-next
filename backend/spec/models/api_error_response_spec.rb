require "rails_helper"

RSpec.describe ApiErrorResponse do
  describe "#initialize" do
    let(:error) { "InvalidRequest" }
    let(:error_description) { ["Missing parameter: user_id"] }

    context "with valid parameters" do
      subject(:response) { described_class.new(error, error_description) }

      it "creates an instance of ApiErrorResponse" do
        expect(response).to be_an_instance_of(described_class)
      end

      it "assigns the correct error" do
        expect(response.error).to eq(error)
      end

      it "assigns the correct error description" do
        expect(response.error_description).to eq(error_description)
      end

      it "freezes the error and error_description attributes" do
        expect(response.error).to be_frozen
        expect(response.error_description).to be_frozen
      end
    end

    context "with invalid error parameter" do
      it "raises an ArgumentError when error is not a string" do
        expect do
          described_class.new(123, ["Some error"])
        end.to raise_error(ArgumentError, "`error` must be a String, got Integer")
      end
    end

    context "with invalid error_description parameter" do
      it "raises an ArgumentError when error_description is not an array" do
        expect do
          described_class.new(error, "This is not an array")
        end.to raise_error(ArgumentError, "`error_description` must be an array of strings, got \"This is not an array\"")
      end

      it "raises an ArgumentError when error_description is not an array of strings" do
        expect do
          described_class.new(error, ["Valid string", 123])
        end.to raise_error(ArgumentError, "`error_description` must be an array of strings, got [\"Valid string\", 123]")
      end
    end
  end
end
