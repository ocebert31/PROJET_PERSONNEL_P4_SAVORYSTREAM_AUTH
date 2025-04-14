class JwtService  
    # Méthode pour décoder un token JWT
    def self.decode(token)
      begin
        # Décoder le token avec la clé secrète
        decoded_token = JWT.decode(token, ENV['SECRET_KEY_BASE'], true, { algorithm: 'HS256' })
        return decoded_token[0]  # Le premier élément contient les données décodées
      rescue JWT::DecodeError => e
        raise "Invalid token: #{e.message}"
      end
    end
  end
  