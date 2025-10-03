class Location < ApplicationRecord
  validates :input, :ip, :country_code, presence: true

  before_validation :set_key

  private

  def set_key
    self.key ||= (ip.presence || input).to_s.strip.downcase
  end
end

