require 'rails_helper'

RSpec.describe "API V1 - Usuarios", type: :request do
    describe "POST /api/v1/usuarios" do
        context "com parâmetros válidos" do
            let(:valid_params) do
                {
                    usuario: {
                        nome: "Gabriel Guerra",
                        username: "gabriel_guerra",
                        email: "gabriel@example.com",
                        password: "senha_segura_com_mais_de_20_chars",
                        password_confirmation: "senha_segura_com_mais_de_20_chars"
                    }
                }
            end

            it "cria o usuário e retorna 201" do
                post "/api/v1/usuarios", params: valid_params, headers: { "HOST" => "localhost" }

                expect(response).to have_http_status(:created)
                json = JSON.parse(response.body)
                expect(json["message"]).to eq("Usuário criado com sucesso. Verifique o e-mail para confirmar a conta.")
                expect(json["usuario"]["email"]).to eq("gabriel@example.com")
                expect(json["confirmation_link"]).to include("api/v1/confirmar_email?token=")
            end
        end

        context "com parâmetros inválidos" do
            let(:invalid_params) do
                {
                    usuario: {
                        nome: "",
                        username: "gg",
                        email: "errado",
                        password: "curta",
                        password_confirmation: "diferente"
                    }
                }
            end

            it "retorna 422" do
                post "/api/v1/usuarios", params: invalid_params, headers: { "HOST" => "localhost" }

                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
    end

    describe "GET /api/v1/usuarios/:id/confirmar" do
        context "com id válido" do
            let(:usuario) { create(:usuario, :confirmed) }

            it "confirma o usuário e retorna 200" do
                get "/api/v1/usuarios/#{usuario.id}/confirmar", headers: { "HOST" => "localhost" }

                expect(response).to have_http_status(:ok)
                json = JSON.parse(response.body)
                expect(json["message"]).to eq("Conta confirmada com sucesso.")
            end
        end

        context "com id inválido" do
            it "retorna 404 com erro" do
                get "/api/v1/usuarios/99999/confirmar", headers: { "HOST" => "localhost" }

                expect(response).to have_http_status(:not_found)
            end
        end
    end
end
