require 'rails_helper'

RSpec.describe 'Locations API', type: :request do
  let(:api_key) { ENV['API_KEY'] || 'dev-local-key-123' }
  let(:headers) { { 'Content-Type' => 'application/json', 'X-API-KEY' => api_key } }

  it 'creates a location from IP (stubbing ipstack)' do
    stub_request(:get, /api\.ipstack\.com\/1\.1\.1\.1.*/)
      .to_return(
        status: 200,
        body: {
          ip: '1.1.1.1',
          hostname: 'one.one.one.one',
          continent_code: 'OC',
          continent_name: 'Oceania',
          country_code: 'AU',
          country_name: 'Australia',
          region_code: 'QLD',
          region_name: 'Queensland',
          city: 'Brisbane',
          zip: '4000',
          latitude: -27.47,
          longitude: 153.02
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    post '/api/locations',
      params: { data: { type: 'location', attributes: { input: '1.1.1.1' } } }.to_json,
      headers: headers

    expect(response).to have_http_status(:created)
    json = JSON.parse(response.body)
    expect(json['data']['attributes']['ip']).to eq('1.1.1.1')
  end

  it 'returns cached location via query' do
    loc = Location.create!(input: '1.1.1.1', ip: '1.1.1.1', country_code: 'AU', key: '1.1.1.1')

    get '/api/locations?ip=1.1.1.1', headers: headers

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json['data']['id']).to eq(loc.id.to_s)
  end
end