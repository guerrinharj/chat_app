module Api
    module V1
        class UsuariosController < ApplicationController
        skip_before_action :verify_authenticity_token

            def create
                usuario = Usuario.new(usuario_params)

                if usuario.save
                    confirmation_link = "http://localhost:3000/api/v1/confirmar_email?token=#{usuario.confirmation_token}"
                    Rails.logger.info("🔔 Link de confirmação: #{confirmation_link}")

                    render json: {
                        message: 'Usuário criado com sucesso. Verifique o e-mail para confirmar a conta.',
                        confirmation_link: confirmation_link,
                        usuario: usuario.slice(:id, :username, :email)
                    }, status: :created
                    else
                    render json: { errors: usuario.errors.full_messages }, status: :unprocessable_entity
                end
            end

            def confirmar
                usuario = Usuario.find_by(confirmation_token: params[:token])

                if usuario.present?
                    usuario.confirm!
                    render json: { message: 'Conta confirmada com sucesso.' }, status: :ok
                else
                    render json: { error: 'Token inválido ou expirado.' }, status: :not_found
                end
            end

            private

            def usuario_params
                params.require(:usuario).permit(:nome, :username, :email, :password, :password_confirmation)
            end
        end
    end
end
