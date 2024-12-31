const { Client } = require('pg');

const client = new Client({
  dbname: 'user_signup_db',
  user: 'postgres', 
  password: 'secret', 
  host: 'localhost', 
  port: 5432  
});

client.connect()
  .then(() => {
    console.log('Connexion à PostgreSQL réussie!');
  })
  .catch(err => {
    console.error('Erreur de connexion à PostgreSQL:', err);
  })
  .finally(() => client.end());
