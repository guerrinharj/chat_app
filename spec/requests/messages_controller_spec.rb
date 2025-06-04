require 'rails_helper'

RSpec.describe "API V1 - Mensagens", type: :request do
    let(:usuario) { create(:usuario) }

    before do
        create_list(:mensagem, 3, usuario: usuario)
    end

    describe "GET /api/v1/mensagens" do
        context "quando o usuário está autenticado" do
            before do
                post "/api/v1/login", params: { login: usuario.username, password: usuario.password }, headers: { "HOST" => "localhost" }
                get "/api/v1/mensagens", headers: { "HOST" => "localhost" }
            end

            it "retorna status 200 e a lista de mensagens" do
                expect(response).to have_http_status(:ok)
            end
        end

        context "quando o usuário NÃO está autenticado" do
            before do
                post "/api/v1/login", params: { login: 'usuario-nao-autenticado', password: usuario.password }, headers: { "HOST" => "localhost" }
                get "/api/v1/mensagens", headers: { "HOST" => "localhost" }
            end
            it "retorna status 401" do
                get "/api/v1/mensagens", headers: { "HOST" => "localhost" }
                expect(response).to have_http_status(:unauthorized)
            end
        end
    end

    describe "POST /api/v1/mensagens" do
        let(:mensagem_params) do
            { mensagem: { texto: "Olá, mundo!" } }
        end

        context "quando o usuário está autenticado" do
            before do
                post "/api/v1/login", params: { login: usuario.username, password: usuario.password }, headers: { "HOST" => "localhost" }
                post "/api/v1/mensagens", params: mensagem_params, headers: { "HOST" => "localhost" }
            end

            it "cria uma mensagem e retorna 201" do
                expect(response).to have_http_status(:created)
            end
        end

        context "quando o texto está vazio" do
            before do
                post "/api/v1/login", params: { login: usuario.username, password: usuario.password }, headers: { "HOST" => "localhost" }
                post "/api/v1/mensagens", params: { mensagem: { texto: "" }}, headers: { "HOST" => "localhost" }
            end
            it "retorna 422" do
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end

        context "quando o usuário NÃO está autenticado" do
            before do
                post "/api/v1/login", params: { login: 'usuario-nao-autenticado', password: usuario.password }, headers: { "HOST" => "localhost" }
                post "/api/v1/mensagens", params: { mensagem: { texto: "" }}, headers: { "HOST" => "localhost" }
            end
            it "retorna status 401" do
                expect(response).to have_http_status(:unauthorized)
            end
        end
    end
end
