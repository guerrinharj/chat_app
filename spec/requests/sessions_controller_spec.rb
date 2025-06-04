# spec/requests/sessoes_spec.rb

require 'rails_helper'

RSpec.describe "Sessions Controller", type: :request do
    let(:usuario) { create(:usuario) }

    describe "POST /api/v1/login" do
        it "Login com sucesso" do
            post "/api/v1/login", params: { login: usuario.username, password: usuario.password }, headers: { "HOST" => "localhost" }
            expect(response).to have_http_status(:ok)
        end
    end

    describe "DELETE /api/v1/logout" do
        it "Logout com sucesso" do
            delete "/api/v1/logout",  headers: { "HOST" => "localhost" }

            expect(response).to have_http_status(:ok)
        end
    end
end
