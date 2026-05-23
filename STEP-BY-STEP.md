# 🎯 Data Marketplace Platform - Steps 1-5 Complete Guide

## 📋 Quick Navigation

| Step | Title | Duration | Instructions |
|------|-------|----------|--------------|
| 1️⃣ | Clone & Install | 5 min | [Go to Step 1](#step-1-clone--install) |
| 2️⃣ | Configure Credentials | 15 min | [Go to Step 2](#step-2-configure-credentials) |
| 3️⃣ | Setup Database | 5 min | [Go to Step 3](#step-3-setup-database) |
| 4️⃣ | Test Locally | 5 min | [Go to Step 4](#step-4-test-locally) |
| 5️⃣ | Deploy Live | 5 min | [Go to Step 5](#step-5-deploy-to-cloudflare) |

**Total Time: ~35 minutes** ⏱️

---

## 🚀 Automated Setup (Recommended)

If you want everything done automatically:

```bash
bash COMPLETE-SETUP.sh
```

This script will guide you through all 5 steps interactively.

---

# 📍 STEP 1: Clone & Install

**Time: 5 minutes**

### 1.1 Clone Repository

```bash
git clone https://github.com/Khl755/data-marketplace-platform.git
cd data-marketplace-platform
```

**Expected:**
```
Cloning into 'data-marketplace-platform'...
remote: Enumerating objects...
✓ Done
```

### 1.2 Verify Node.js Installation

```bash
node --version  # Should be v16 or higher
npm --version   # Should be v8 or higher
```

**If not installed:**
- Download from https://nodejs.org
- Install Node.js (includes npm)

### 1.3 Install Dependencies

```bash
npm install
```

**Expected output:**
```
added 150+ packages in ~2 minutes
up to date, audited 152 packages
found 0 vulnerabilities
```

### 1.4 Verify Installation

```bash
npm --version
npm list express
```

✅ **Step 1 Complete!** Your project is ready for configuration.

---

# 🔑 STEP 2: Configure Credentials

**Time: 15 minutes** (includes account creation)

## 2.1 Create .env File

```bash
cp .env.example .env
```

You now have a template with all required variables.

## 2.2 Get Supabase Credentials

### Create Supabase Account
1. Go to **https://supabase.com**
2. Click **"Sign Up"** or **"Start your project"**
3. Choose **"Continue with GitHub"** or email
4. Verify email
5. Create organization (use any name)

### Create Project
1. Click **"New Project"**
2. Fill in:
   - **Project Name:** `data-marketplace`
   - **Password:** Create a strong password (save it!)
   - **Region:** Choose closest to your location
     - Asia: Singapore
     - Europe: Frankfurt/London
     - Americas: US East
3. Click **"Create new project"**
4. Wait for provisioning (5-10 minutes) ⏳

### Get API Keys
1. Project created → Click on project name
2. Go to **Settings** (bottom left)
3. Click **"API"**
4. You'll see:
   - **Project URL** (under "Project API keys")
   - **Anon public** key
   - **Service role** secret

### Copy to .env
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=eyJ0eXAiOiJKV1QiLCJhbGc...
SUPABASE_SERVICE_ROLE=eyJ0eXAiOiJKV1QiLCJhbGc...
```

## 2.3 Get Payment Gateway Credentials

### ➕ Stripe (Card Payments)
```bash
1. Go to https://dashboard.stripe.com
2. Sign up or login
3. Dashboard → Settings → API keys
4. Copy "Secret key" (starts with sk_test_)
5. Add to .env:
   STRIPE_KEY=sk_test_...
```

### 📱 Payoneer (Popular in Bangladesh)
```bash
1. Go to https://www.payoneer.com/developer
2. Sign up for developer account
3. Create application
4. Get Client ID & Client Secret
5. Add to .env:
   PAYONEER_CLIENT_ID=xxx
   PAYONEER_CLIENT_SECRET=xxx
```

### ₿ Binance Pay (Crypto Support)
```bash
1. Go to https://pay.binance.com
2. Sign up or login
3. Merchant Services → Create Merchant
4. Generate API Key
5. Add to .env:
   BINANCE_API_KEY=xxx
   BINANCE_API_SECRET=xxx
```

### 💰 PayU (India-focused)
```bash
1. Go to https://merchant.payumoney.com
2. Create merchant account
3. Complete verification
4. Get Merchant Key & Salt
5. Add to .env:
   PAYU_MERCHANT_KEY=xxx
   PAYU_MERCHANT_SALT=xxx
```

### 🏦 Fasset (Multi-region)
```bash
1. Go to https://www.fasset.com
2. Create business account
3. Generate API Key
4. Add to .env:
   FASSET_API_KEY=xxx
   FASSET_MERCHANT_ID=xxx
```

## 2.4 Email Configuration

### Gmail Setup (Recommended)
```bash
1. Go to https://myaccount.google.com
2. Security (left sidebar)
3. Enable 2-Factor Authentication
4. Search "App password"
5. Select Mail & Windows Computer
6. Copy generated password
```

### Add to .env
```env
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-generated-app-password
```

## 2.5 Bank Account Details

Add your bank information for manual transfers:

```env
BANK_ACCOUNT_NAME=Your Company Name
BANK_ACCOUNT_NUMBER=1234567890
BANK_ROUTING_NUMBER=routing-code
BANK_SWIFT_CODE=SWIFT
```

## 2.6 Generate JWT Secret

```bash
# On Mac/Linux
openssl rand -base64 32

# On Windows (PowerShell)
[Convert]::ToBase64String((1..32 | ForEach-Object {Get-Random -Maximum 256}))
```

Add to .env:
```env
JWT_SECRET=your-generated-secret-here
```

## 2.7 Complete .env File

```bash
# Open and edit
nano .env
```

Final .env should look like:
```env
# ========== SUPABASE ==========
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_KEY=eyJ...
SUPABASE_SERVICE_ROLE=eyJ...

# ========== JWT ==========
JWT_SECRET=your-generated-secret

# ========== PAYMENTS ==========
STRIPE_KEY=sk_test_...
PAYONEER_CLIENT_ID=xxx
PAYONEER_CLIENT_SECRET=xxx
BINANCE_API_KEY=xxx
BINANCE_API_SECRET=xxx
PAYU_MERCHANT_KEY=xxx
PAYU_MERCHANT_SALT=xxx
FASSET_API_KEY=xxx
FASSET_MERCHANT_ID=xxx

# ========== EMAIL ==========
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-app-password

# ========== BANK ==========
BANK_ACCOUNT_NAME=Your Company
BANK_ACCOUNT_NUMBER=1234567890
BANK_ROUTING_NUMBER=routing
BANK_SWIFT_CODE=SWIFT

# ========== SERVER ==========
BASE_URL=http://localhost:3000
PORT=3000
NODE_ENV=development
MAX_FILE_SIZE=104857600
```

✅ **Step 2 Complete!** All credentials configured.

---

# 🗄️ STEP 3: Setup Database

**Time: 5 minutes**

## 3.1 Access Supabase SQL Editor

1. Go to your **Supabase Dashboard**
2. Click your project
3. Left sidebar → **"SQL Editor"**
4. Click **"New Query"** (top right)

## 3.2 Run Main Schema

1. View the schema file:
```bash
cat config/supabase-schema.sql
```

2. In Supabase SQL Editor:
   - Copy entire content of `config/supabase-schema.sql`
   - Paste into the query editor
   - Click **"Run"** (bottom right)
   - Wait for completion ✓

## 3.3 Run Enhancements

Repeat for additional features:

1. Copy content of `config/supabase-enhancements.sql`
2. New Query → Paste → Run

## 3.4 Verify Tables

In Supabase **Table Editor** (left sidebar), verify these exist:

```
✓ users
✓ datasets
✓ purchases
✓ payments
✓ downloads
✓ subscriptions
✓ reviews
✓ wishlists
✓ support_tickets
✓ analytics
✓ bank_transfers
✓ api_keys
```

All should show with green checkmarks ✓

✅ **Step 3 Complete!** Database is ready.

---

# 🧪 STEP 4: Test Locally

**Time: 5 minutes**

## 4.1 Start Development Server

```bash
npm run dev
```

**Expected output:**
```
🚀 Server running on port 3000
📍 Environment: development
🌍 Database: ✅ Connected

Available endpoints:
  📊 Dashboard: http://localhost:3000
  🏥 API: http://localhost:3000/api
```

## 4.2 Test Registration

1. Open browser → **http://localhost:3000**
2. Click **"Register"** button
3. Fill in:
   - Email: `buyer@test.com`
   - Password: `Test123!@`
   - Full Name: `Test Buyer`
   - Country: `Bangladesh`
   - Role: `buyer`
4. Click **Register**

**Expected:** "Registration successful" message, logged in

## 4.3 Create Seller Account

1. Register another user:
   - Email: `seller@test.com`
   - Role: `seller` ← Important!

## 4.4 Test Dataset Upload (As Seller)

1. Login as seller
2. In dashboard, click **"Upload Dataset"**
3. Fill in:
   - Title: `Test Dataset`
   - Description: `Sample data`
   - Category: `business`
   - Regions: `USA`
   - Price: `49.99`
   - Records: `1000`
4. Upload sample CSV file
5. Click **"Create"**

**Expected:** Dataset created

## 4.5 Test Purchase (As Buyer)

1. Logout (click logout button)
2. Login as buyer
3. Browse datasets
4. Find "Test Dataset"
5. Click **"Buy"** button
6. Select payment method: `Stripe` (for testing)
7. Follow payment flow

**Expected:** Payment processed (test mode)

## 4.6 Test Download

1. Go to **"My Purchases"**
2. Find the dataset
3. Click **"Download"**

**Expected:** File downloads

## 4.7 Stop Server

Press **Ctrl+C** in terminal

✅ **Step 4 Complete!** Platform works locally.

---

# 🌐 STEP 5: Deploy to Cloudflare

**Time: 5 minutes**

## 5.1 Install Wrangler CLI

```bash
npm install -g wrangler
```

Verify:
```bash
wrangler --version
```

## 5.2 Authenticate with Cloudflare

```bash
wrangler login
```

Browser opens → Sign in to Cloudflare account
(Create account if needed at https://cloudflare.com)

## 5.3 Get Your Account ID

```bash
wrangler whoami
```

Output example:
```
Account ID: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
```

**Copy this ID**

## 5.4 Update wrangler.toml

```bash
nano wrangler.toml
```

Update these lines:
```toml
name = "data-marketplace"
type = "javascript"
account_id = "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"  # Paste your ID
```

Save: **Ctrl+X → Y → Enter**

## 5.5 Set Production Secrets

Run these commands one by one:

```bash
wrangler secret put SUPABASE_URL
# Paste: https://your-project.supabase.co
# Press Enter

wrangler secret put SUPABASE_SERVICE_ROLE
# Paste: eyJ0eXAiOiJKV1QiLCJhbGc...
# Press Enter

wrangler secret put JWT_SECRET
# Paste: your-jwt-secret
# Press Enter

wrangler secret put STRIPE_KEY
# Paste: sk_live_... (or sk_test_)
# Press Enter

# Continue for remaining secrets:
wrangler secret put PAYONEER_CLIENT_ID
wrangler secret put PAYONEER_CLIENT_SECRET
wrangler secret put BINANCE_API_KEY
wrangler secret put BINANCE_API_SECRET
wrangler secret put EMAIL_USER
wrangler secret put EMAIL_PASSWORD
```

## 5.6 Build & Deploy

```bash
npm run build
wrangler publish
```

**Expected output:**
```
✓ Successfully published your Worker
✓ https://data-marketplace.workers.dev
```

## 5.7 Connect Custom Domain

### Option A: Use Provided Subdomain
Your app is live at: `https://data-marketplace.workers.dev`

### Option B: Connect Your Domain
1. Go to **https://dash.cloudflare.com**
2. Add your domain
3. Create CNAME record:
   - Name: `datahub` (or your subdomain)
   - Content: `data-marketplace.workers.dev`
4. Enable SSL/TLS (Full Strict)
5. Wait 24 hours for DNS propagation

## 5.8 Monitor Live

```bash
wrangler tail
```

Shows real-time logs from production

✅ **Step 5 Complete!** Platform is live!

---

## ✅ Final Checklist

- [ ] Step 1: Repository cloned, Node.js installed, dependencies installed
- [ ] Step 2: All .env variables filled with credentials
- [ ] Step 3: Database tables created in Supabase
- [ ] Step 4: Local tests passed (register, upload, purchase, download)
- [ ] Step 5: Deployed to Cloudflare, domain connected

---

## 🎉 Success! What's Next?

Your Data Marketplace Platform is now:
- ✅ Running locally (for development)
- ✅ Live on Cloudflare (for production)
- ✅ Connected to Supabase (database)
- ✅ Accepting payments (6 methods)
- ✅ Delivering downloads (secure tokens)

### Recommended Next Steps:

1. **Create Admin Account**
   - Register with special role
   - Access admin dashboard
   - Approve datasets

2. **Add Sample Datasets**
   - Create as seller
   - Upload data
   - Publish

3. **Monitor Metrics**
   - Check Cloudflare Analytics
   - View application logs
   - Track user activity

4. **Setup Marketing**
   - Create landing page
   - Add social media links
   - Start promotions

5. **Scale & Optimize**
   - Enable caching
   - Optimize images
   - Monitor performance

---

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| Port 3000 in use | `lsof -i :3000` then `kill -9 PID` |
| Supabase connection error | Check credentials, verify IP whitelist |
| Payment gateway error | Use test credentials, check API keys |
| Cloudflare deployment failed | Ensure wrangler.toml has correct account_id |
| Download not working | Check file permissions in uploads folder |

---

## 📚 Additional Resources

- **API Documentation**: `API-DOCS.md`
- **Feature Guide**: `FEATURES.md`
- **Deployment Details**: `DEPLOYMENT.md`
- **Setup Details**: `SETUP-GUIDE.md`

---

**🎊 Congratulations! You're ready to launch! 🎊**

Your platform is production-ready and can start accepting customers and payments immediately.

Start building your data marketplace empire! 🚀💰
