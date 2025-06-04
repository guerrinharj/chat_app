require 'rails_helper'

RSpec.describe Usuario, type: :model do
  describe 'validações' do
    it 'é válido com atributos válidos' do
      usuario = build(:usuario)
      expect(usuario.valid?).to eq(true)
    end

    it 'é inválido sem nome' do
      usuario = build(:usuario, nome: nil)
      expect(usuario.valid?).to eq(false)
      expect(usuario.errors[:nome].any?).to eq(true)
    end

    it 'é inválido com username muito curto' do
      usuario = build(:usuario, username: 'abc')
      expect(usuario.valid?).to eq(false)
      expect(usuario.errors[:username].any?).to eq(true)
    end

    it 'é inválido com email em formato incorreto' do
      usuario = build(:usuario, email: 'invalid-email')
      expect(usuario.valid?).to eq(false)
      expect(usuario.errors[:email].any?).to eq(true)
    end

    it 'é inválido com senha menor que 20 caracteres' do
      usuario = build(:usuario, password: 'short', password_confirmation: 'short')
      expect(usuario.valid?).to eq(false)
      expect(usuario.errors[:password].any?).to eq(true)
    end

    it 'é inválido com senha diferente da confirmação' do
      usuario = build(:usuario, password: 'umaboasenhacom22chars', password_confirmation: 'diferente')
      expect(usuario.valid?).to eq(false)
      expect(usuario.errors[:password_confirmation].any?).to eq(true)
    end
  end

  describe 'métodos de confirmação' do
    it '#confirm! preenche confirmed_at e limpa confirmation_token' do
      usuario = create(:usuario)
      expect(usuario.confirmed?).to eq(false)

      usuario.confirm!
      expect(usuario.confirmed?).to eq(true)
      expect(usuario.confirmation_token).to eq(nil)
    end
  end

  describe 'callbacks' do
    it 'gera um confirmation_token ao criar' do
      usuario = create(:usuario)
      expect(usuario.confirmation_token.nil?).to eq(false)
      expect(usuario.confirmation_token.length).to eq(40) 
    end
  end
end
