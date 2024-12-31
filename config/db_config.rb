# db_config.rb
require 'pg'

def connect_to_db
  PG.connect(
    dbname: 'savory_stream_auth',  
    user: 'postgres',             # Nom d'utilisateur PostgreSQL
    password: 'secret', # Le mot de passe de ton utilisateur PostgreSQL
    host: 'localhost',            # L'hôte où PostgreSQL est installé (localhost si c'est sur la même machine)
    port: 5432                    # Le port par défaut de PostgreSQL
  )
end