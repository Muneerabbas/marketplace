# Marketplace Backend

Node + Express + MongoDB API for the iOS Marketplace app.

## Requirements
- Node.js
- MongoDB running locally (`mongodb://127.0.0.1:27017`)

## Setup
```bash
cd backend
npm install
npm start        # or: npm run dev  (auto-restart on changes)
```
Server runs at http://localhost:3000

The iOS app connects to `http://127.0.0.1:3000` (see `APIConfig.swift`). On a physical iPhone, change that to your Mac's local IP address.

## Data models
- **User** — name, email, password, `uploadedProducts` (products they sell), `orders` (products they bought)
- **Product** — name, category, price, description, location, icon, `seller` (a User)

## API

### Auth
| Method | Route | Body | Description |
|--------|-------|------|-------------|
| POST | `/api/auth/signup` | `{ name, email, password }` | Create account |
| POST | `/api/auth/login` | `{ email, password }` | Log in |

### Users
| Method | Route | Body | Description |
|--------|-------|------|-------------|
| GET | `/api/users` | — | List all users |
| GET | `/api/users/:id` | — | One user with orders + uploaded products |
| POST | `/api/users/:id/orders` | `{ productId }` | Add a product to the user's orders |

### Products
| Method | Route | Body | Description |
|--------|-------|------|-------------|
| POST | `/api/products` | `{ name, category, price, description, location, icon, seller }` | Upload a product |
| GET | `/api/products` | — | List all products (filter with `?category=` or `?location=`) |
| GET | `/api/products/:id` | — | One product |

## Quick test
```bash
# sign up
curl -X POST http://localhost:3000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"name":"Muneer","email":"m@test.com","password":"1234"}'

# upload a product (use the _id from above as seller)
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"iPhone 15","category":"Mobiles","price":89999,"location":"Srinagar","seller":"<USER_ID>"}'

# get all products
curl http://localhost:3000/api/products
```
