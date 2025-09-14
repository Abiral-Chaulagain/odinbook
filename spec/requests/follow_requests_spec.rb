require 'rails_helper'

RSpec.describe "FollowRequests", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/follow_requests/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/follow_requests/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/follow_requests/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
