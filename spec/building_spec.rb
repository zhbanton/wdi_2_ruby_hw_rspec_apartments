require_relative '../lib/building.rb'
require_relative '../lib/factories.rb'

describe Building do

  let(:building) { new_building }
  let(:home) { new_apartment }
  let(:downstairs) { new_apartment(number: 1, rent: 2200, square_footage: 500, bedrooms: 2, bathrooms: 1) }

  include Factory

  describe 'attributes' do
    it 'has an address and many tenants' do
      expect(building.address).to eq '241 Washington St.'
      expect(building.apartments).to eq []
    end
  end

  describe '#add_apartment' do
    it 'adds an apartment to the building' do
      building.add_apartment(home)
      building.add_apartment(downstairs)
      expect(building.apartments).to match_array [home, downstairs]
    end
  end

  describe '#remove_apartment' do
    it 'deletes an apartment from the building' do
      building.add_apartment(home)
      building.add_apartment(downstairs)
      building.remove_apartment(2)
      expect(building.apartments).to match_array [downstairs]
    end

    it 'raises an error if the apartment is not found' do
      building.add_apartment(home)
      building.add_apartment(downstairs)
      expect { building.remove_apartment(3) }.to raise_error(ArgumentError, 'could not find apartment with that number')
    end

    it 'raises an error if the apartment has tenants' do
      home.add_tenant(new_tenant)
      building.add_apartment(home)
      building.add_apartment(downstairs)
      expect { building.remove_apartment(2) }.to raise_error(ArgumentError, 'cannot remove occupied apartment')

    end
  end

  describe '#square_footage' do
    it 'calculates the building\'s total square_footage' do
      building.add_apartment(home)
      building.add_apartment(downstairs)
      expect(building.square_footage).to eq 1500
    end
  end

  describe '#monthly_revenue' do
    it 'sums the rent of each apartment in the building' do
      building.add_apartment(home)
      building.add_apartment(downstairs)
      expect(building.monthly_revenue).to eq 6600
    end
  end

  describe '#tenants' do
    it 'returns a list of all tenants in the building' do
      home.add_tenant(zack = new_tenant)
      home.add_tenant(paul = new_tenant)
      building.add_apartment(home)
      downstairs.add_tenant(brian = new_tenant)
      building.add_apartment(downstairs)
      expect(building.tenants).to match_array [zack, paul, brian]
    end
  end

  describe '#by_credit score' do
    it 'returns the apartments grouped by credit rating and sorted by credit score' do
      home.add_tenant(new_tenant)
      building.add_apartment(home)
      downstairs.add_tenant(new_tenant(credit_score: 730))
      building.add_apartment(downstairs)
      basement = new_apartment
      basement.add_tenant(new_tenant(credit_score: 750))
      building.add_apartment(basement)
      expect(building.by_credit_score).to eq ({'great' => [basement, downstairs], 'good' => [home]})
    end
  end
end

