require 'rails_helper'

RSpec.describe ChatChannel, type: :channel do
  include ActionCable::TestHelper

  let(:usuario) { create(:usuario) }

  before do
    stub_connection current_user: usuario
  end

  describe '#subscribed' do
    it 'faz stream do canal correto' do
      subscribe
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("chat_channel")
    end
  end

  describe '#speak' do
    it 'cria mensagem e transmite via ActionCable.server.broadcast' do
      subscribe

      expect(ActionCable.server).to receive(:broadcast) do |canal, payload|
        expect(canal).to eq("chat_channel")
        expect(payload[:texto]).to eq("Olá mundo!")
        expect(payload[:usuario][:username]).to eq(usuario.username)
        expect(payload[:created_at]).to be_present
      end

      perform :speak, { texto: 'Olá mundo!' }

      mensagem = Mensagem.last
      expect(mensagem.texto).to eq('Olá mundo!')
      expect(mensagem.usuario).to eq(usuario)
    end
  end
end
