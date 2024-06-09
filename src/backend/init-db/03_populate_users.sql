SET search_path TO auth;

CREATE TABLE IF NOT EXISTS auth.users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(100) NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    mobile_token VARCHAR(255)
);

-- Insert the provided entries with bcrypt hashed passwords
INSERT INTO users (id, name, email, password_hash, role) VALUES 
(1, 'Larissa Morais', 'admin@admin.com', '$2b$12$1kdVBvyvbLdvRUB3mmoCw.Eb9EYTlSbNskq9EueQR7Z.kt8.mvEam', 'admin'),
(2, 'Neide Santos', 'nurse@nurse.com', '$2b$12$RnEDdfRZppccKkjbzmL0QOqzUmNzg73sWwbd6PnQJEfj2Cxl.6sIq', 'nurse'),
(3, 'Pedro Ferreira', 'agent@agent.com', '$2b$12$odk8pcSN25kBrtN7uI/UOO146EeDACNp4qyXu5AXTsWPHHqjRIohS', 'agent');

SELECT setval(pg_get_serial_sequence('auth.users', 'id'), (SELECT MAX(id) FROM auth.users));
