require 'journey'

describe Journey do
  let(:journey)       { Journey.new }
  let(:entry_station) { double('entry station')}
  let(:exit_station)  { double('exit_station')}
  let(:third_station) { double('third station')}

  before(:each) do
    @original_stderr = $stderr
    @file = File.open(File::NULL, 'w')
    $stderr = @file
  end

  after(:each) do
    $stderr = @original_stderr
    @file.close
  end

  describe '.history' do
    it 'is initialised as empty' do
      expect(journey.class.history).to eq([])
    end
  end

  describe '#initialize' do
    it 'current journey has an entry station key' do
      expect(journey.current_journey.include?(:entry_station)).to eq(true)
    end
    it 'entry station key is nil' do
      expect(journey.current_journey[:entry_station]).to eq(nil)
    end

    it 'current journey has an exit station key' do
      expect(journey.current_journey.include?(:exit_station)).to eq(true)
    end

    it 'exit station key is nil' do
      expect(journey.current_journey[:exit_station]).to eq(nil)
    end

    it 'sets fare to minimum fare' do
      expect(journey.fare).to eq(Journey::MIN_FARE)
    end
  end

  describe '#start' do
    before(:each) do |example|
      unless example.metadata[:skip_before]
      journey.start(entry_station)
      end
    end

    context 'when entry and exit stations are correctly unset' do
      it 'saves entry station to current journey' do
        expect(journey.current_journey[:entry_station]).to eq(entry_station)
      end

      it 'sets fare to minimum fare', :skip_before do
        journey.instance_variable_set(:@fare, 100)
        journey.start(entry_station)
        expect(journey.fare).to eq(Journey::MIN_FARE)
      end
    end

    context 'when entry station is already set to the current station' do
      it 'throws an error' do
        expect { journey.start(entry_station) }.to raise_error(
          RuntimeError, 'You have already touched in at this station!')
      end
    end

    context 'when entry station is incorrectly already set to a different station' do
      it 'throws an error' do
        expect { journey.start(third_station) }.to output(
          "You failed to complete your last journey correctly. "\
          "You will be charged £#{Journey::PENALTY_FARE} for this journey.\n").to_stderr
      end

      it 'sets fare to penalty fare' do
        expect { journey.start(third_station) rescue nil }.to change { journey.fare} .to eq(Journey::PENALTY_FARE)
      end
    end
  end

  describe '#finish' do
    before(:each) do
      Journey.class_variable_set(:@@history, [])
    end

    context 'when the current journey correctly has an entry station set' do
      it 'saves exit station when finishing journey' do
        journey.start(entry_station)
        journey.finish(exit_station)
        expect(Journey.history.last[:exit_station]).to eq(exit_station)
      end

      it 'saves completed journey to journey history' do
        journey.start(entry_station)
        journey.finish(exit_station)
        expect(Journey.history).to eq([{entry_station: entry_station, exit_station: exit_station}])
      end

      it 'clears current journey after saving it to journey history' do
        journey.start(entry_station)
        journey.finish(exit_station)
        expect(journey.current_journey).to eq({entry_station: nil, exit_station: nil})
      end
    end

    context 'when the current journey incorrectly has no entry station set' do
      it 'throws an error' do
        expect { journey.finish(exit_station) }.to output(
          "You failed to complete your last journey correctly. "\
          "You will be charged £#{Journey::PENALTY_FARE} for this journey.\n").to_stderr
      end

      it 'sets fare to penalty fare' do
        expect { journey.finish(exit_station) rescue nil }.to change { journey.fare }.to eq(Journey::PENALTY_FARE)
      end
    end
  end
end