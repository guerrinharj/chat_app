usuario = Usuario.create!(
    nome: "Admin",
    username: "admin_user",
    email: "admin@example.com",
    password: "12345678901234567890",
    password_confirmation: "12345678901234567890"
)

Mensagem.create!(
    texto: "Seja bem vindo! esta mensagem foi criada do ambiente de #{Rails.env}",
    usuario: usuario
)
