module Api
    module V1
        class UsuariosController < ApplicationController
            skip_before_action :verify_authenticity_token

            def create
                usuario = Usuario.new(usuario_params)

                if usuario.save
                    render json: { message: 'Usuário criado com sucesso', usuario: usuario.slice(:id, :username, :email) }, status: :created
                else
                    render json: { errors: usuario.errors.full_messages }, status: :unprocessable_entity
                end
            end

            private

            def usuario_params
                params.require(:usuario).permit(:nome, :username, :email, :password, :password_confirmation)
            end
        end
    end
end
