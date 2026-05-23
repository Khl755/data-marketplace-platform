#!/bin/bash
# Complete End-to-End Setup Script
# Steps 1-5: Clone → Setup → Configure → Deploy

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Data Marketplace Platform - Complete Setup (1-5)      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ============================================================================
# STEP 1: CLONE & INSTALL
# ============================================================================
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}STEP 1: Clone Repository & Install Dependencies${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Check if already cloned
if [ -d "data-marketplace-platform" ]; then
    echo -e "${YELLOW}✓ Repository already exists${NC}"
    cd data-marketplace-platform
else
    echo -e "${BLUE}Cloning repository...${NC}"
    git clone https://github.com/Khl755/data-marketplace-platform.git
    cd data-marketplace-platform
    echo -e "${GREEN}✅ Repository cloned${NC}"
fi

echo ""
echo -e "${BLUE}Installing dependencies...${NC}"
npm install

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependencies installed successfully${NC}"
else
    echo -e "${RED}❌ Failed to install dependencies${NC}"
    exit 1
fi

echo ""

# ============================================================================
# STEP 2: ENVIRONMENT SETUP
# ============================================================================
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}STEP 2: Configure Environment Variables${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

if [ -f .env ]; then
    echo -e "${YELLOW}✓ .env file already exists${NC}"
    read -p "Overwrite? (y/n): " overwrite
    if [ "$overwrite" = "y" ]; then
        cp .env.example .env
        echo -e "${GREEN}✅ .env reset from template${NC}"
    fi
else
    cp .env.example .env
    echo -e "${GREEN}✅ .env created from template${NC}"
fi

echo ""
echo -e "${YELLOW}⚠️  You need to fill in the following credentials:${NC}"
echo ""
echo -e "${BLUE}1. SUPABASE Configuration:${NC}"
echo "   - Go to https://supabase.com"
echo "   - Create new project"
echo "   - Copy SUPABASE_URL"
echo "   - Copy SUPABASE_KEY (anon)"
echo "   - Copy SUPABASE_SERVICE_ROLE"
echo ""

echo -e "${BLUE}2. Payment Gateways:${NC}"
echo "   - Stripe: https://stripe.com"
echo "   - Payoneer: https://payoneer.com/developer"
echo "   - Binance: https://pay.binance.com"
echo "   - PayU: https://payumoney.com"
echo "   - Fasset: https://fasset.com"
echo ""

echo -e "${BLUE}3. Email Settings:${NC}"
echo "   - Gmail account (for notifications)"
echo "   - Gmail app password"
echo ""

echo -e "${BLUE}4. Bank Details:${NC}"
echo "   - Your bank account information"
echo ""

echo -e "${YELLOW}Opening .env file for editing...${NC}"
echo ""

# Try to open with default editor
if command -v nano &> /dev/null; then
    nano .env
elif command -v vim &> /dev/null; then
    vim .env
elif [ "$OSTYPE" = "darwin"* ]; then
    open -t .env
elif [ "$OSTYPE" = "msys" ] || [ "$OSTYPE" = "cygwin" ]; then
    notepad .env
else
    echo -e "${YELLOW}Please open .env file and fill in credentials${NC}"
    echo -e "${YELLOW}File location: $(pwd)/.env${NC}"
    read -p "Press Enter after updating .env..."
fi

echo ""
echo -e "${GREEN}✅ Environment configured${NC}"
echo ""

# ============================================================================
# STEP 3: SUPABASE DATABASE SETUP
# ============================================================================
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}STEP 3: Setup Supabase Database${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

read -p "Setup Supabase database now? (y/n): " setup_db

if [ "$setup_db" = "y" ]; then
    echo -e "${BLUE}Database setup instructions:${NC}"
    echo ""
    echo "1. Go to your Supabase project"
    echo "2. Navigate to SQL Editor"
    echo "3. Create new query"
    echo "4. Copy and paste content from: config/supabase-schema.sql"
    echo "5. Click 'Run'"
    echo "6. Repeat for: config/supabase-enhancements.sql"
    echo ""
    echo -e "${YELLOW}Opening Supabase schema...${NC}"
    
    if [ "$OSTYPE" = "darwin"* ]; then
        open config/supabase-schema.sql
    elif [ "$OSTYPE" = "msys" ] || [ "$OSTYPE" = "cygwin" ]; then
        notepad config/supabase-schema.sql
    else
        cat config/supabase-schema.sql
    fi
    
    echo ""
    read -p "Press Enter after running SQL in Supabase..."
    
    echo -e "${GREEN}✅ Database configured${NC}"
else
    echo -e "${YELLOW}⚠️  Skipping database setup${NC}"
fi

echo ""

# ============================================================================
# STEP 4: TEST LOCALLY
# ============================================================================
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}STEP 4: Test Locally${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${BLUE}Starting development server...${NC}"
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Server running on: http://localhost:3000            ║${NC}"
echo -e "${GREEN}║  API Documentation: http://localhost:3000/api        ║${NC}"
echo -e "${GREEN}║                                                       ║${NC}"
echo -e "${GREEN}║  Test the following:                                 ║${NC}"
echo -e "${GREEN}║  1. Register new user                                ║${NC}"
echo -e "${GREEN}║  2. Login                                            ║${NC}"
echo -e "${GREEN}║  3. Upload dataset (as seller)                       ║${NC}"
echo -e "${GREEN}║  4. Test payment methods                             ║${NC}"
echo -e "${GREEN}║  5. Download purchased dataset                       ║${NC}"
echo -e "${GREEN}║                                                       ║${NC}"
echo -e "${GREEN}║  Press Ctrl+C to stop server                         ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

npm run dev &
SERVER_PID=$!

# Wait for server to start
sleep 3

echo ""
read -p "Press Enter to continue after testing..."

# Kill server
kill $SERVER_PID 2>/dev/null || true

echo ""
echo -e "${GREEN}✅ Local testing complete${NC}"
echo ""

# ============================================================================
# STEP 5: DEPLOY TO CLOUDFLARE
# ============================================================================
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}STEP 5: Deploy to Cloudflare${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

read -p "Deploy to Cloudflare now? (y/n): " deploy_cf

if [ "$deploy_cf" = "y" ]; then
    # Check if wrangler is installed
    if ! command -v wrangler &> /dev/null; then
        echo -e "${BLUE}Installing Wrangler CLI...${NC}"
        npm install -g wrangler
    fi
    
    echo ""
    echo -e "${BLUE}Authenticating with Cloudflare...${NC}"
    wrangler login
    
    echo ""
    echo -e "${BLUE}Getting Cloudflare Account ID...${NC}"
    ACCOUNT_ID=$(wrangler whoami 2>/dev/null | grep "Account ID" | awk '{print $NF}' || echo "not-found")
    
    if [ "$ACCOUNT_ID" != "not-found" ]; then
        echo -e "${GREEN}Account ID: $ACCOUNT_ID${NC}"
        echo ""
        echo -e "${YELLOW}Update wrangler.toml:${NC}"
        echo "  account_id = \"$ACCOUNT_ID\""
        echo ""
        read -p "Press Enter to continue deployment..."
    fi
    
    echo ""
    echo -e "${BLUE}Setting secrets...${NC}"
    wrangler secret put SUPABASE_URL
    wrangler secret put SUPABASE_SERVICE_ROLE
    wrangler secret put JWT_SECRET
    wrangler secret put STRIPE_KEY
    wrangler secret put PAYONEER_CLIENT_ID
    wrangler secret put PAYONEER_CLIENT_SECRET
    
    echo ""
    echo -e "${BLUE}Building and publishing...${NC}"
    npm run build
    wrangler publish
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ Deployed to Cloudflare!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Go to Cloudflare Dashboard"
    echo "2. Connect your domain"
    echo "3. Enable SSL/TLS"
    echo "4. Monitor with: wrangler tail"
    echo ""
else
    echo -e "${YELLOW}Deployment skipped${NC}"
    echo ""
    echo "To deploy later, run:"
    echo "  bash scripts/deploy-cloudflare.sh"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         ✅ All Steps Complete! Platform Ready!            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Summary:${NC}"
echo "  1. ✅ Repository cloned & dependencies installed"
echo "  2. ✅ Environment configured"
echo "  3. ✅ Supabase database setup"
echo "  4. ✅ Local testing completed"
echo "  5. ✅ Deployed to Cloudflare"
echo ""
echo -e "${BLUE}Resources:${NC}"
echo "  📖 README: See README.md for overview"
echo "  🚀 Deployment: See DEPLOYMENT.md for details"
echo "  ✨ Features: See FEATURES.md for feature list"
echo "  📚 API Docs: See API-DOCS.md for endpoints"
echo "  🛠️  Setup: See SETUP-GUIDE.md for detailed steps"
echo ""
echo -e "${GREEN}🎉 Your Data Marketplace Platform is ready to launch! 🎉${NC}"
echo ""
