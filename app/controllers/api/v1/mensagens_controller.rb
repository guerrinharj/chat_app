module Api
    module V1
        class MensagensController < ApplicationController
            skip_before_action :verify_authenticity_token
            before_action :require_login

            def index
                mensagens = Mensagem.includes(:usuario).order(created_at: :desc)
                render json: mensagens.map { |m| serialize(m) }
            end

            def create
                mensagem = current_usuario.mensagens.build(mensagem_params)

                if mensagem.save
                    ActionCable.server.broadcast("chat_channel", {
                        id: mensagem.id,
                        texto: mensagem.texto,
                        usuario: mensagem.usuario.username,
                        created_at: mensagem.created_at.strftime("%H:%M:%S")
                    })

                    render json: serialize(mensagem), status: :created
                else
                    render json: { errors: mensagem.errors.full_messages }, status: :unprocessable_entity
                end
            end

            private

            def mensagem_params
                params.require(:mensagem).permit(:texto)
            end

            def require_login
                unless current_usuario
                    render json: { error: "Usuário não autenticado" }, status: :unauthorized
                end
            end

            def current_usuario
                @current_usuario ||= Usuario.find_by(id: session[:usuario_id])
            end

            def serialize(mensagem)
                {
                id: mensagem.id,
                texto: mensagem.texto,
                usuario: {
                    id: mensagem.usuario.id,
                    username: mensagem.usuario.username
                },
                created_at: mensagem.created_at
                }
            end
        end
    end
end
