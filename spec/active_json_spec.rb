RSpec.describe ActiveJson do

  subject(:active_json) { ActiveJson.select(json, where: filters) }

  let(:json)    { IO.read(file) }
  let(:filters) { 'drink_name == "latte"' }
  let(:file)    { 'spec/data/prices.json' }

  it 'has a version number' do
    expect(ActiveJson::VERSION).not_to be nil
  end

  context 'Selects JSON' do
    it do
      expect(active_json).to eq(
        [
          { drink_name: 'latte',
            prices: { small: 3.5, medium: 4.0, large: 4.5 } }
        ]
      )
    end
  end


  context 'Selects JSON' do
    let(:filters) { 'drink_name != "short espresso", drink_name != "long black", prices.small <= 3.5' }
    it do
      expect(active_json).to eq(
        [
          { drink_name: 'latte',
            prices: { small: 3.5, medium: 4.0, large: 4.5 } },
          { drink_name: 'flat white',
            prices: { small: 3.5, medium: 4.0, large: 4.5 } }
        ]
      )
    end
  end

  context 'Selects JSON' do
    let(:filters) { 'drink_name == "short espresso"' }
    it do
      expect(active_json).to eq(
        [
          { drink_name: 'short espresso',
            prices: { small: 3.0 } }
        ]
      )
    end
  end

  context 'Selects JSON' do
    let(:filters) { 'prices.small == 3.0' }
    it do
      expect(active_json).to eq(
        [
          { drink_name: 'short espresso',
            prices: { small: 3.0 } }
        ]
      )
    end
  end

  context 'Selects JSON' do
    let(:filters) { 'prices.small < 3.5, drink_name != "latte"' }
    it do
      expect(active_json).to eq(
        [
          { drink_name: 'short espresso',
            prices: { small: 3.0 } },
          { drink_name: 'long black',
            prices: { small: 3.25, medium: 3.5 } }
        ]
      )
    end
  end

end
