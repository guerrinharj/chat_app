class ChatChannel < ApplicationCable::Channel
    def subscribed
        stream_from "chat_channel"
    end

    def speak(data)
        usuario = Usuario.find_by(id: connection.current_user&.id)
        return unless usuario

        mensagem = usuario.mensagens.create(texto: data['texto'])
        ActionCable.server.broadcast("chat_channel", {
            id: mensagem.id,
            texto: mensagem.texto,
            usuario: {
                id: usuario.id,
                username: usuario.username
            },
            created_at: mensagem.created_at.strftime('%H:%M:%S')
        })
    end
end
