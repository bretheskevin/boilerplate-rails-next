require 'rails_helper'

describe "Dummies" do

  before(:each) do
    @dummy = create(:dummy)
    @dummy_2 = create(:dummy, name: "Dummy 2")
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get "/dummies"
      expect(response).to be_successful
      expect(json.count).to eq(2)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get "/dummies/#{@dummy.id}"
      expect(response).to be_successful
      expect(json["name"]).to eq(@dummy.name)

      get "/dummies/#{@dummy_2.id}"
      expect(response).to be_successful
      expect(json["name"]).to eq(@dummy_2.name)
    end

    it "returns an error response" do
      get "/dummies/0"
      expect(response).to have_http_status(:not_found)
      expect(json).to have_key("error")
    end
  end

  describe 'POST #create' do
    it 'returns a success response' do
      post "/dummies", params: { dummy: { name: "Hello", description: "World" } }
      expect(response).to be_successful
      expect(json["name"]).to eq("Hello")
      expect(json["description"]).to eq("World")

      expect(Dummy.count).to eq(3)
    end
  end

  describe 'patch #update' do
    it 'returns a success response' do
      patch "/dummies/#{@dummy.id}", params: { dummy: { name: "New title" } }
      expect(response).to be_successful
      expect(json["name"]).to eq("New title")
      expect(json["description"]).to eq(@dummy.description)
    end
  end

  describe 'DELETE #destroy' do
    it 'returns a success response' do
      expect(Dummy.count).to eq(2)

      delete "/dummies/#{@dummy.id}"
      expect(response).to have_http_status(:no_content)

      expect(Dummy.count).to eq(1)
    end
  end
end
