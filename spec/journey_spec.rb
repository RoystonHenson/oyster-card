require 'journey'

describe Journey do
  let(:journey) { Journey.new }
  let(:location1) { double('location1' , name: 'Boxwood') }
  let(:location2) { double('location2', name: 'Cloverhoof', fare: 2) }

  describe '#initialize' do
    it 'has an empty current journey' do
      expect(journey.current_journey).to eq({})
    end

    it 'has an empty journey history' do
      expect(journey.journey_history).to eq([])
    end
  end

  describe '#start' do
    it 'sets the journey origin' do
      journey.start(location1.name)
      expect(journey.current_journey[:origin]).to eq(location1.name)
    end
  end

  describe '#finish' do
    it 'sets the journey destination' do
      journey.finish(location2.name)
      expect(journey.current_journey[:destination]).to eq(location2.name)
    end

    it 'saves the current journey to journey history' do
      journey.start(location1.name)
      journey.finish(location2.name)
      expect(journey.journey_history).to eq([{origin: location1.name, destination: location2.name}])
    end
  end

  describe '#complete?' do
    context 'when origin is empty after journey is completed' do        
      it 'is not complete' do
        journey.current_journey = {origin: nil, destination: 'Cloverhoof'}
        expect(journey).not_to be_complete
      end
    end

    context 'when destination is empty after journey is completed' do
      it 'is not complete' do
        journey.current_journey = {origin: 'Boxwood', destination: nil}
        expect(journey).not_to be_complete
      end
    end

    context 'when origin and destination are not empty when journey is completed' do
      it 'is complete' do
        journey.current_journey = {origin: 'Boxwood', destination: 'Cloverhoof'}
        expect(journey).to be_complete
      end
    end
  end

  describe '#calculate_fare' do
    context 'when journey started and finished' do  
      it 'sets fare to minimum fare' do
        journey.start(location1)
        journey.finish(location2)
        expect(journey.fare).to eq(Journey::MINIMUM_FARE)    
      end
    end

    context 'when journey started but not finished' do
      it 'sets fare to penalty fare' do
        journey.start(location1)
        expect(journey.fare).to eq(Journey::PENALTY_FARE)
      end
    end

    context 'when journey finished but not started' do
      it 'sets fare to penalty fare' do
        journey.finish(location2)
        expect(journey.fare).to eq(Journey::PENALTY_FARE)
      end
    end
  end
end