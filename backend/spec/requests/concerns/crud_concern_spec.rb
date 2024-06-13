require "rails_helper"

describe "Dummies" do
  let(:dummy) { create(:dummy) }
  let(:dummy_2) { create(:dummy, name: "Dummy 2") }

  before do
    dummy
    dummy_2
  end

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

    it "returns an error response" do
      get "/dummies/0"
      expect(response).to have_http_status(:not_found)
      expect(json).to have_key("error")
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
end
