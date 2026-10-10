# GeoAPI (Ruby on Rails)

A simple **Geolocation API** built with Ruby on Rails that stores and retrieves geolocation data based on an **IP address** or **URL**.  
It integrates with [ipstack](https://ipstack.com/) (or a mock provider for testing) and demonstrates RESTful design, error handling, and RSpec test coverage.

---

## Features
- Store geolocation info by IP or URL
- Fetch cached locations
- Delete stored locations
- External geolocation provider abstraction (easily switchable)
- JSON:API style input/output
- API key authentication (`X-API-KEY` header)
- RSpec tests with WebMock stubbing
- Docker support for quick setup

---

## Requirements
- Ruby 3.2+
- Rails 7+
- PostgreSQL
- Bundler

Optional:
- Docker + Docker Compose

---

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/DenysSoloshenko/geoapi-ruby.git
cd geoapi-ruby
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Configure database

```bash
bin/rails db:create db:migrate
```

### 4. Environment variables

Create a `.env` file in the project root:

```dotenv
IPSTACK_API_KEY=your_real_key_here
API_KEY=dev-local-key-123
```

For development without ipstack, you can run:

```bash
USE_MOCK_GEO=1 bin/rails s
```

## Running the server

```bash
bin/rails s
```

Server will start at http://localhost:3000.

## API Usage

### Create location

```bash
curl -X POST http://localhost:3000/api/locations \
  -H "Content-Type: application/json" \
  -H "X-API-KEY: dev-local-key-123" \
  -d '{"data":{"type":"location","attributes":{"input":"1.1.1.1"}}}'
```

### Query by IP

```bash
curl -X GET "http://localhost:3000/api/locations?ip=1.1.1.1" \
  -H "X-API-KEY: dev-local-key-123"
```

### Delete location

```bash
curl -X DELETE http://localhost:3000/api/locations/1 \
  -H "X-API-KEY: dev-local-key-123"
```

## Testing

Run the test suite:

```bash
bundle exec rspec
```
