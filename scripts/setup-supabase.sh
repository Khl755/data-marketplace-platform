#!/bin/bash
# Supabase Setup Script for Data Marketplace Platform

set -e

echo "🚀 Data Marketplace Platform - Supabase Setup"
echo "================================================"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  .env file not found!${NC}"
    echo "Please create .env from .env.example first:"
    echo "  cp .env.example .env"
    exit 1
fi

# Load environment variables
export $(cat .env | grep -v '#' | xargs)

if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_SERVICE_ROLE" ]; then
    echo -e "${YELLOW}⚠️  SUPABASE_URL and SUPABASE_SERVICE_ROLE not set in .env${NC}"
    exit 1
fi

echo -e "${BLUE}Supabase URL: ${SUPABASE_URL}${NC}"
echo ""

# Create tables using SQL
echo -e "${BLUE}Creating database tables...${NC}"

# Users table
psql "${SUPABASE_URL}" -c "
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(255),
  role VARCHAR(50) DEFAULT 'buyer',
  country VARCHAR(100),
  payment_method VARCHAR(50),
  profile_image_url TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
"

echo -e "${GREEN}✅ Users table created${NC}"

# Datasets table
psql "${SUPABASE_URL}" -c "
CREATE TABLE IF NOT EXISTS datasets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  seller_id UUID NOT NULL REFERENCES users(id),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100),
  regions VARCHAR(500) NOT NULL,
  file_url TEXT,
  file_size BIGINT,
  file_format VARCHAR(50),
  price DECIMAL(10, 2) NOT NULL,
  subscription_plan VARCHAR(50),
  records_count INT,
  sample_data JSONB,
  preview_lat FLOAT,
  preview_lng FLOAT,
  thumbnail_url TEXT,
  is_published BOOLEAN DEFAULT FALSE,
  download_count INT DEFAULT 0,
  rating FLOAT DEFAULT 0,
  review_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
"

echo -e "${GREEN}✅ Datasets table created${NC}"

# Purchases table
psql "${SUPABASE_URL}" -c "
CREATE TABLE IF NOT EXISTS purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  buyer_id UUID NOT NULL REFERENCES users(id),
  dataset_id UUID NOT NULL REFERENCES datasets(id),
  seller_id UUID NOT NULL REFERENCES users(id),
  amount DECIMAL(10, 2) NOT NULL,
  payment_method VARCHAR(50),
  payment_status VARCHAR(50) DEFAULT 'pending',
  transaction_id VARCHAR(255),
  downloaded BOOLEAN DEFAULT FALSE,
  download_expires_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
"

echo -e "${GREEN}✅ Purchases table created${NC}"

# Payments table
psql "${SUPABASE_URL}" -c "
CREATE TABLE IF NOT EXISTS payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(10) DEFAULT 'USD',
  payment_method VARCHAR(50),
  gateway_transaction_id VARCHAR(255),
  status VARCHAR(50) DEFAULT 'pending',
  description TEXT,
  metadata JSONB,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
"

echo -e "${GREEN}✅ Payments table created${NC}"

# Downloads table
psql "${SUPABASE_URL}" -c "
CREATE TABLE IF NOT EXISTS downloads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  purchase_id UUID NOT NULL REFERENCES purchases(id),
  dataset_id UUID NOT NULL REFERENCES datasets(id),
  user_id UUID NOT NULL REFERENCES users(id),
  file_path TEXT,
  download_token VARCHAR(255) UNIQUE,
  download_token_expires_at TIMESTAMP,
  downloaded_at TIMESTAMP,
  ip_address VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);
"

echo -e "${GREEN}✅ Downloads table created${NC}"

# Create indexes
echo -e "${BLUE}Creating indexes...${NC}"

psql "${SUPABASE_URL}" -c "
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_datasets_seller_id ON datasets(seller_id);
CREATE INDEX IF NOT EXISTS idx_datasets_published ON datasets(is_published);
CREATE INDEX IF NOT EXISTS idx_purchases_buyer ON purchases(buyer_id);
CREATE INDEX IF NOT EXISTS idx_purchases_dataset ON purchases(dataset_id);
CREATE INDEX IF NOT EXISTS idx_payments_user ON payments(user_id);
CREATE INDEX IF NOT EXISTS idx_downloads_user ON downloads(user_id);
"

echo -e "${GREEN}✅ Indexes created${NC}"

# Enable Row Level Security (RLS)
echo -e "${BLUE}Enabling Row Level Security...${NC}"

psql "${SUPABASE_URL}" -c "
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE datasets ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE downloads ENABLE ROW LEVEL SECURITY;
"

echo -e "${GREEN}✅ RLS enabled${NC}"

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}✅ Supabase database setup complete!${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo "Next steps:"
echo "1. Create an admin user:"
echo "   npm run create-admin"
echo ""
echo "2. Start the server:"
echo "   npm run dev"
echo ""
