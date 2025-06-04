require 'rails_helper'

RSpec.describe Mensagem, type: :model do
  describe 'validações' do
    it 'é válida com atributos corretos' do
      mensagem = build(:mensagem)
      expect(mensagem.valid?).to eq(true)
    end

    it 'é inválida sem texto' do
      mensagem = build(:mensagem, texto: nil)
      expect(mensagem.valid?).to eq(false)
      expect(mensagem.errors[:texto].any?).to eq(true)
    end

    it 'é inválida com texto maior que 1000 caracteres' do
      mensagem = build(:mensagem, texto: 'a' * 1001)
      expect(mensagem.valid?).to eq(false)
      expect(mensagem.errors[:texto].any?).to eq(true)
    end
  end

  describe 'associações' do
    it 'pertence a um usuário' do
      usuario = create(:usuario)
      mensagem = create(:mensagem, usuario: usuario)
      expect(mensagem.usuario).to eq(usuario)
    end
  end
end
