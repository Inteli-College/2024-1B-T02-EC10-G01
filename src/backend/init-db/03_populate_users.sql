SET search_path TO auth;

CREATE TABLE IF NOT EXISTS auth.users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(100) NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Insert the provided entries with bcrypt hashed passwords
INSERT INTO users (id, email, password_hash, role) VALUES 
(1, 'admin@admin.com', '$2b$12$1kdVBvyvbLdvRUB3mmoCw.Eb9EYTlSbNskq9EueQR7Z.kt8.mvEam', 'admin'),
(2, 'nurse@nurse.com', '$2b$12$RnEDdfRZppccKkjbzmL0QOqzUmNzg73sWwbd6PnQJEfj2Cxl.6sIq', 'nurse'),
(3, 'agent@agent.com', '$2b$12$odk8pcSN25kBrtN7uI/UOO146EeDACNp4qyXu5AXTsWPHHqjRIohS', 'agent');