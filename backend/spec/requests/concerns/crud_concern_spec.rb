require "rails_helper"

class DefaultsController < ApplicationController
end

describe "Dummies" do
  let!(:dummy) { create(:dummy) }
  let!(:dummy_2) { create(:dummy, name: "Dummy 2") }

  describe "GET #index" do
    before { get "/dummies" }

    it "returns a success response" do
      expect(response).to be_successful
    end

    it "returns the correct number of models" do
      expect(json["models"].count).to eq(2)
    end

    it "returns the current page" do
      expect(json["current_page"]).to eq(1)
    end

    it "returns the total number of pages" do
      expect(json["total_pages"]).to eq(1)
    end

    it "returns the total number of dummies" do
      expect(json["total_objects"]).to eq(2)
    end
  end

  describe "GET #show" do
    context "when the dummy exists" do
      before { get "/dummies/#{dummy.id}" }

      it "returns a success response" do
        expect(response).to be_successful
      end

      it "returns the correct dummy name" do
        expect(json["name"]).to eq(dummy.name)
      end
    end

    context "when the model is not found" do
      before { get "/dummies/0" }

      it "returns a 404 error" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error key in the response" do
        expect(json).to have_key("error")
      end
    end
  end

  describe "POST #create" do
    context "when valid parameters are provided" do
      before do
        post "/dummies", params: { dummy: { name: "Hello", description: "World" } }
      end

      it "returns a success response" do
        expect(response).to be_successful
      end

      it "returns the correct name" do
        expect(json["name"]).to eq("Hello")
      end

      it "returns the correct description" do
        expect(json["description"]).to eq("World")
      end

      it "increments the dummy count" do
        expect(Dummy.count).to eq(3)
      end
    end

    context "when invalid parameters are provided" do
      before do
        post "/dummies", params: { dummy: { description: "Hello" } }
      end

      it "returns an unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error key in the response" do
        expect(json).to have_key("error")
      end
    end
  end

  describe "PATCH #update" do
    context "when valid parameters are provided" do
      before do
        patch "/dummies/#{dummy.id}", params: { dummy: { name: "New title" } }
      end

      it "returns a success response" do
        expect(response).to be_successful
      end

      it "returns the updated dummy name" do
        expect(json["name"]).to eq("New title")
      end

      it "keeps the old description" do
        expect(json["description"]).to eq(dummy.description)
      end
    end

    context "when the model is not found" do
      before do
        patch "/dummies/0", params: { dummy: { name: "New title" } }
      end

      it "returns a 404 error" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error key in the response" do
        expect(json).to have_key("error")
      end
    end

    context "when wrong param name is provided" do
      before do
        patch "/dummies/#{dummy.id}", params: { wrong_param: { name: "New title" } }
      end

      it "returns unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error key in the response" do
        expect(json).to have_key("error")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when a valid dummy is deleted" do
      before { delete "/dummies/#{dummy.id}" }

      it "returns a no content status" do
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the model is not found" do
      before { delete "/dummies/0" }

      it "returns a 404 error" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error key in the response" do
        expect(json).to have_key("error")
      end
    end
  end

  describe "object_class" do
    context "when not implemented" do
      it "raises a NotImplementedError" do
        expect { DefaultsController.new.object_class }.to raise_error(NotImplementedError)
      end
    end
  end

  describe "soft_delete query params" do
    let!(:dummy) { create(:dummy) }
    let!(:dummy_2) { create(:dummy) }

    before do
      dummy.destroy
    end

    context "when no params are provided" do
      before { get "/dummies" }

      it "returns only active dummies" do
        expect(json["models"].count).to eq(1)
      end

      it "returns the correct active dummy" do
        expect(json["models"].first["id"]).to eq(dummy_2.id)
      end
    end

    context "when with_deleted param is set" do
      before { get "/dummies?with_deleted=1" }

      it "returns all dummies" do
        expect(json["models"].count).to eq(2)
      end
    end

    context "when only_deleted param is set" do
      before { get "/dummies?only_deleted=1" }

      it "returns only deleted dummies" do
        expect(json["models"].count).to eq(1)
      end

      it "returns the correct deleted dummy" do
        expect(json["models"].first["id"]).to eq(dummy.id)
      end
    end

    context "when trying to find a deleted object" do
      it "returns a success response for the deleted dummy" do
        get "/dummies/#{dummy.id}"
        expect(response).to be_successful
      end
    end
  end

  describe "not found route" do
    before { get "/not_found" }

    it "returns a 404 error" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns error key in the response" do
      expect(json).to have_key("error")
    end

    it "returns error_description key in the response" do
      expect(json).to have_key("error_description")
    end
  end
end
