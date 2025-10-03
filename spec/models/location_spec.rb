require 'rails_helper'

RSpec.describe Location, type: :model do
  it 'is valid with minimal fields' do
    loc = Location.new(input: '1.1.1.1', ip: '1.1.1.1', country_code: 'AU')
    expect(loc).to be_valid
  end
end