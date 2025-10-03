class LocationsController < ApplicationController
  # GET /api/locations
  # GET /api/locations?ip=1.2.3.4 OR ?url=example.com (returns cached if present)
  def index
    if params[:ip].present? || params[:url].present?
      input = params[:ip].presence || params[:url].presence
      key = input.to_s.strip.downcase
      location = Location.find_by(key: key) || Location.find_by(ip: input)
      return render json: LocationSerializer.new(location).serializable_hash if location
      return render json: { data: nil }
    end

    render json: LocationSerializer.new(Location.order(created_at: :desc).limit(50)).serializable_hash
  end

  # GET /api/locations/:id
  def show
    location = Location.find(params[:id])
    render json: LocationSerializer.new(location).serializable_hash
  end

  # POST /api/locations
  # { "data": { "type":"location", "attributes": { "input": "1.1.1.1" | "example.com" } } }
  def create
    input = params.dig(:data, :attributes, :input).to_s.strip
    raise Errors::GeolocationError.new('Input is required', code: 'INPUT') if input.blank?

    provider = Geolocation::IpstackProvider.new
    result = provider.resolve(input)

    location = Location.create!(
      input: input,
      ip: result.ip,
      hostname: result.hostname,
      continent_code: result.continent_code,
      continent_name: result.continent_name,
      country_code: result.country_code,
      country_name: result.country_name,
      region_code: result.region_code,
      region_name: result.region_name,
      city: result.city,
      zip: result.zip,
      latitude: result.latitude,
      longitude: result.longitude,
      key: (result.ip || input).to_s.downcase
    )

    render json: LocationSerializer.new(location).serializable_hash, status: :created
  end

  # DELETE /api/locations/:id
  def destroy
    Location.find(params[:id]).destroy!
    head :no_content
  end
end
