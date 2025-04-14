Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:5173'  # Remplacez par l'URL de votre frontend (ou '*' pour toutes les origines)
  
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options],
        expose: ['Authorization']
    end
  end
  