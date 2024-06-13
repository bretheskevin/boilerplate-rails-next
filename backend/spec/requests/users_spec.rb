require "rails_helper"

describe "Users" do
  let(:params) { { user: { email: "test@newemail.com" } } }

  describe "GET #index" do
    context "when user is an admin" do
      it "returns a success response" do
        get "/users", headers: @admin_header
        expect(response).to be_successful
        expect(json["models"].count).to eq(2)
      end
    end

    context "when user is not an admin" do
      it "returns an error response" do
        get "/users", headers: @user_header
        expect(response).to have_http_status(:unauthorized)
        expect(json).to have_key("error")
      end
    end

    context "when user is not authenticated" do
      it "returns an error response" do
        get "/users"
        expect(response).to have_http_status(:unauthorized)
        expect(json).to have_key("error")
      end
    end
  end

  describe "GET #show" do
    context "when user is an admin" do
      it "returns the account information" do
        get "/users/#{@user.id}", headers: @admin_header
        expect(response).to be_successful
        expect(json["id"]).to eq(@user.id)
        expect(json["email"]).to eq(@user.email)
      end
    end

    context "when user views their own account" do
      it "returns their own account information" do
        get "/users/#{@user.id}", headers: @user_header
        expect(response).to be_successful
        expect(json["id"]).to eq(@user.id)
        expect(json["email"]).to eq(@user.email)
      end
    end

    context "when user views another user's account" do
      let(:other_user) { create(:user, email: "otheruser@example.com") }

      it "returns an error response" do
        get "/users/#{other_user.id}", headers: @user_header
        expect(response).to have_http_status(:unauthorized)
        expect(json).to have_key("error")
      end
    end

    context "when user is not authenticated" do
      it "returns an error response" do
        get "/users/#{@user.id}"
        expect(response).to have_http_status(:unauthorized)
        expect(json).to have_key("error")
      end
    end

    context "when user doesn't exist" do
      it "returns a 404 response" do
        get "/users/0", headers: @admin_header
        expect(response).to have_http_status(:not_found)
        expect(json).to have_key("error")
      end
    end
  end

  describe "POST #create" do
    it "does not create a user" do
      post "/users", headers: @admin_header
      expect(response).to have_http_status(:not_found)
      expect(json).to have_key("error")
    end
  end

  describe "PATCH #update" do
    context "when user is an admin" do
      it "updates the account information" do
        patch "/users/#{@user.id}", params: params, headers: @admin_header
        expect(response).to be_successful
        expect(json["email"]).to eq(params[:user][:email])
      end
    end

    context "when user is not admin" do
      it "updates his own account information" do
        patch "/users/#{@user.id}", params: params, headers: @user_header
        expect(response).to be_successful
        expect(json["email"]).to eq(params[:user][:email])
      end

      it "updates other account information" do
        patch "/users/#{@admin.id}", params: params, headers: @user_header
        expect(response).to have_http_status(:unauthorized)
        expect(json).to have_key("error")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is an admin" do
      it "deletes the account" do
        delete "/users/#{@user.id}", headers: @admin_header
        expect(response).to have_http_status(:no_content)
      end

      it "deletes his own account" do
        delete "/users/#{@admin.id}", headers: @admin_header
        expect(response).to have_http_status(:no_content)
      end

      it "can't delete others admin" do
        admin = create(:admin, email: "a@a.fr")

        delete "/users/#{admin.id}", headers: @admin_header
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is not an admin" do
      it "can't delete other account" do
        user = create(:user, email: "a@a.fr")

        delete "/users/#{user.id}", headers: @user_header
        expect(response).to have_http_status(:unauthorized)
      end

      it "can delete his own account" do
        delete "/users/#{@user.id}", headers: @user_header
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
