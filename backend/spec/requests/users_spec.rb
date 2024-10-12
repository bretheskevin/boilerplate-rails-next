require "rails_helper"

describe "Users" do
  let(:params) { { user: { email: "test@newemail.com" } } }

  describe "GET #index" do
    context "when user is an admin" do
      before { get "/users", headers: @admin_header }

      it "returns a success response" do
        expect(response).to be_successful
      end

      it "returns the correct number of models" do
        expect(json["models"].count).to eq(2)
      end
    end

    context "when user is a regular user" do
      before { get "/users", headers: @user_header }

      it "returns an unauthorized response" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "contains the error key" do
        expect(json).to have_key("error")
      end
    end

    context "when user is not authenticated" do
      before { get "/users" }

      it "returns an unauthorized response" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "contains the error key" do
        expect(json).to have_key("error")
      end
    end
  end

  describe "GET #show" do
    context "when user is an admin" do
      before { get "/users/#{@user.id}", headers: @admin_header }

      it "returns a success response" do
        expect(response).to be_successful
      end

      it "returns the correct user id" do
        expect(json["id"]).to eq(@user.id)
      end

      it "returns the correct user email" do
        expect(json["email"]).to eq(@user.email)
      end
    end

    context "when user views their own account" do
      before { get "/users/#{@user.id}", headers: @user_header }

      it "returns a success response" do
        expect(response).to be_successful
      end

      it "returns the correct user id" do
        expect(json["id"]).to eq(@user.id)
      end

      it "returns the correct user email" do
        expect(json["email"]).to eq(@user.email)
      end
    end

    context "when user views another user's account" do
      let(:other_user) { create(:user, email: "otheruser@example.com") }

      before { get "/users/#{other_user.id}", headers: @user_header }

      it "returns an unauthorized response" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "contains the error key" do
        expect(json).to have_key("error")
      end
    end

    context "when user doesn't exist" do
      before { get "/users/0", headers: @admin_header }

      it "returns a not found response" do
        expect(response).to have_http_status(:not_found)
      end

      it "contains the error key" do
        expect(json).to have_key("error")
      end
    end
  end

  describe "POST #create" do
    before { post "/users", headers: @admin_header }

    it "returns a not found response" do
      expect(response).to have_http_status(:not_found)
    end

    it "contains the error key" do
      expect(json).to have_key("error")
    end
  end

  describe "PATCH #update" do
    context "when user is an admin" do
      before { patch "/users/#{@user.id}", params: params, headers: @admin_header }

      it "updates the account information successfully" do
        expect(response).to be_successful
      end

      it "updates the email correctly" do
        expect(json["email"]).to eq(params[:user][:email])
      end
    end

    context "when user is a regular user" do
      before { patch "/users/#{@user.id}", params: params, headers: @user_header }

      it "updates their own account successfully" do
        expect(response).to be_successful
      end

      it "updates their email correctly" do
        expect(json["email"]).to eq(params[:user][:email])
      end

      it "cannot update another account" do
        patch "/users/#{@admin.id}", params: params, headers: @user_header
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is an admin" do
      it "deletes the account successfully" do
        delete "/users/#{@user.id}", headers: @admin_header
        expect(response).to have_http_status(:no_content)
      end

      it "deletes own account successfully" do
        delete "/users/#{@admin.id}", headers: @admin_header
        expect(response).to have_http_status(:no_content)
      end

      it "cannot delete another admin's account" do
        admin = create(:admin, email: "a@a.fr")
        delete "/users/#{admin.id}", headers: @admin_header
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is a regular user" do
      let(:user) { create(:user, email: "a@a.fr") }

      it "cannot delete another account" do
        delete "/users/#{user.id}", headers: @user_header
        expect(response).to have_http_status(:unauthorized)
      end

      it "can delete their own account" do
        delete "/users/#{@user.id}", headers: @user_header
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
