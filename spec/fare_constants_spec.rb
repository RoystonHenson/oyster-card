require 'fare_constants'

describe FareConstants do
  let(:fares) { FareConstants }

  it 'sets minimum fare' do
    expect(fares::MIN_FARE).to eq(1)
  end

  it 'sets penalty fare' do
    expect(fares::PENALTY_FARE).to eq(100)
  end
end