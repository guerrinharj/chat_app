class Mensagem < ApplicationRecord
  belongs_to :usuario

  validates :texto, presence: true, length: { maximum: 1000 }
end
