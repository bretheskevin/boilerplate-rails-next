require "rails_helper"

class DefaultsController < ApplicationController
end

describe "Dummies" do
  let!(:dummy) { create(:dummy) }
  let!(:dummy_2) { create(:dummy, name: "Dummy 2") }

  describe "GET #index" do
    it "returns a success response" do
      get "/dummies"
      expect(response).to be_successful
      expect(json["models"].count).to eq(2)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get "/dummies/#{dummy.id}"
      expect(response).to be_successful
      expect(json["name"]).to eq(dummy.name)
    end

    context "when the model is not found" do
      it "returns a 404 error" do
        get "/dummies/0"
        expect(response).to have_http_status(:not_found)
        expect(json).to have_key("error")
      end
    end
  end

  describe "POST #create" do
    it "returns a success response" do
      post "/dummies", params: { dummy: { name: "Hello", description: "World" } }
      expect(response).to be_successful
      expect(json["name"]).to eq("Hello")
      expect(json["description"]).to eq("World")

      expect(Dummy.count).to eq(3)
    end

    it "returns an error response" do
      post "/dummies", params: { dummy: { description: "Hello" } }
      expect(response).to have_http_status(:unprocessable_content)
      expect(json).to have_key("error")
    end
  end

  describe "PATCH #update" do
    it "returns a success response" do
      patch "/dummies/#{dummy.id}", params: { dummy: { name: "New title" } }
      expect(response).to be_successful
      expect(json["name"]).to eq("New title")
      expect(json["description"]).to eq(dummy.description)
    end

    it "returns an error response" do
      patch "/dummies/0", params: { dummy: { name: "New title" } }
      expect(response).to have_http_status(:not_found)
      expect(json).to have_key("error")
    end

    context "when wrong param name" do
      it "returns unprocessable content" do
        patch "/dummies/#{dummy.id}", params: { wrong_param: { name: "New title" } }
        expect(response).to have_http_status(:unprocessable_content)
        expect(json).to have_key("error")
      end
    end
  end

  describe "DELETE #destroy" do
    it "returns a success response" do
      delete "/dummies/#{dummy.id}"
      expect(response).to have_http_status(:no_content)
    end

    it "returns an error response" do
      delete "/dummies/0"
      expect(response).to have_http_status(:not_found)
      expect(json).to have_key("error")
    end
  end

  describe "object_class" do
    context "when is not implemented" do
      it "raises an error" do
        expect { DefaultsController.new.object_class }.to raise_error(NotImplementedError)
      end
    end
  end

  describe "soft_delete query params" do
    let(:dummy) { create(:dummy) }
    let(:dummy_2) { create(:dummy) }

    before do
      dummy
      dummy_2
      dummy.destroy
    end

    context "when no params" do
      it "returns 0 dummies" do
        get "/dummies"
        expect(json["models"].count).to eq(1)
        expect(json["models"].first["id"]).to eq(dummy_2.id)
      end
    end

    context "when with_deleted" do
      it "returns 2 dummies" do
        get "/dummies?with_deleted=1"
        expect(json["models"].count).to eq(2)
      end
    end

    context "when only_deleted" do
      it "returns 1 dummy" do
        get "/dummies?only_deleted=1"
        expect(json["models"].count).to eq(1)
        expect(json["models"].first["id"]).to eq(dummy.id)
      end
    end

    context "when try to find a deleted object" do
      it "returns the dummy" do
        get "/dummies/#{dummy.id}"
        expect(response).to be_successful
      end
    end
  end

  describe "not found route" do
    it "returns a 404 error" do
      get "/not_found"
      expect(response).to have_http_status(:not_found)
      expect(json).to have_key("error")
      expect(json).to have_key("error_description")
    end
  end
end
