class Usuario < ApplicationRecord
    has_many :mensagens, dependent: :destroy

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
end
