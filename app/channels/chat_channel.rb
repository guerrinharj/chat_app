class ChatChannel < ApplicationCable::Channel
    def subscribed
        stream_from "chat_channel"
    end

    def speak(data)
        puts "🗨️ Método speak chamado com: #{data.inspect}" # <-- adicione isso

        usuario = connection.current_user
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
