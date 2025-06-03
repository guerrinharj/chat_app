module Api
    module V1
        class SessionsController < ApplicationController
            skip_before_action :verify_authenticity_token

            MAX_LOGIN_ATTEMPTS = 5
            LOCKOUT_PERIOD = 1.hour

            def create
                identifier = params[:login]
                usuario = Usuario.find_by(username: identifier) || Usuario.find_by(email: identifier)

                if usuario.nil?
                    render json: { error: 'Usuário não encontrado' }, status: :unauthorized and return
                end

                if locked_out?(usuario)
                    render json: { error: 'Usuário bloqueado por múltiplas tentativas. Tente novamente mais tarde.' }, status: :forbidden and return
                end

                if usuario.authenticate(params[:password])
                    reset_attempts(usuario)
                    session[:usuario_id] = usuario.id

                    usuario.update!(session_token: SecureRandom.hex(20))

                    render json: {
                        message: 'Login bem-sucedido',
                        usuario: usuario.slice(:id, :username, :email),
                        token: usuario.session_token
                    }
                else
                    increment_attempts(usuario)
                    render json: { error: 'Credenciais inválidas' }, status: :unauthorized
                end
            end

            def destroy
                session[:usuario_id] = nil
                render json: { message: 'Logout efetuado com sucesso' }
            end

            private

            def locked_out?(usuario)
                usuario.login_attempts.to_i >= MAX_LOGIN_ATTEMPTS &&
                usuario.last_failed_login_at.present? &&
                usuario.last_failed_login_at > LOCKOUT_PERIOD.ago
            end

            def increment_attempts(usuario)
                usuario.login_attempts = usuario.login_attempts.to_i + 1
                usuario.last_failed_login_at = Time.current
                usuario.save(validate: false)
            end

            def reset_attempts(usuario)
                usuario.update_columns(login_attempts: 0, last_failed_login_at: nil)
            end
        end
    end
end
