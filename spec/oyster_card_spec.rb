require 'oyster_card'

describe OysterCard do
  let(:oyster_card) { OysterCard.new }

  describe '#initialize' do
    it 'has an opening balance of 0' do
      expect(oyster_card.balance).to eq(0)
    end
  end

  describe '#top_up' do
    context 'when card balance remains below balance limit' do
      it 'adds money to the balance' do
        oyster_card.top_up(1)
        expect(oyster_card.balance).to eq(1)
      end
    end

    context 'when top up will exceed balance limit' do
      it 'will throw an error' do
        expect { oyster_card.top_up(91) }.to raise_error(
          RuntimeError, "This transaction would exceed the card limit of #{OysterCard::MAX_BALANCE}. Please top up a smaller amount.")
      end

      it 'will not add money to the current balance' do
        expect { oyster_card.top_up(91) rescue nil }.not_to change { oyster_card.balance }
      end
    end
  end
end