class Usuario < ApplicationRecord
    has_many :mensagens, class_name: "Mensagem", dependent: :destroy

    has_secure_password

    validates :nome, presence: true, length: { in: 3..255 }

    validates :username,
                presence: true,
                uniqueness: true,
                length: { in: 5..50 },
                format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "só permite letras, números, - e _" }

    validates :email,
                presence: true,
                uniqueness: true,
                format: { with: URI::MailTo::EMAIL_REGEXP }

    validates :password, length: { in: 20..100 }, confirmation: true, if: :password_digest_changed?

    before_create :generate_confirmation_token

    def confirm!
        update(confirmed_at: Time.current, confirmation_token: nil)
    end

    def confirmed?
        confirmed_at.present?
    end

    private

    def generate_confirmation_token
        self.confirmation_token = SecureRandom.hex(20)
    end
end
