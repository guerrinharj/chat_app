# app/channels/application_cable/connection.rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_usuario

    def connect
      self.current_usuario = find_verified_user
    end

    private

    def find_verified_user
      if (user_id = cookies.encrypted[:usuario_id])
        if (user = Usuario.find_by(id: user_id))
          return user
        end
      end

      if (token = request.params[:token])
        if (user = Usuario.find_by(session_token: token))
          return user
        end
      end

      reject_unauthorized_connection
    end
  end
end
