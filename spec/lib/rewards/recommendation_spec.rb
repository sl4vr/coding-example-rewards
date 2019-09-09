# frozen_string_literal: true

require 'spec_helper'

describe Rewards::Recommendation do
  let(:customer) { Rewards::Customer.new('A') }
  let(:recommended_name) { 'B' }
  let(:created_at) { Time.now }

  subject(:recommendation) do
    Rewards::Recommendation.new(
      customer: customer,
      recommended_name: recommended_name,
      created_at: created_at
    )
  end

  describe '.new' do
    it { is_expected.to be_kind_of(Rewards::Recommendation) }

    it 'has customer' do
      expect(recommendation.customer).to eq(customer)
    end

    it 'has recommended_name' do
      expect(recommendation.recommended_name).to eq(recommended_name)
    end

    it 'has no recommended_customer' do
      expect(recommendation.recommended_customer).to be_nil
    end

    it 'has created_at' do
      expect(recommendation.created_at).to eq(created_at)
    end

    it 'is NOT active' do
      expect(recommendation.active).to be(false)
    end

    context 'when no customer given' do
      let(:customer) { nil }

      it 'raises NoCustomerError' do
        expect {
          recommendation
        }.to raise_error(Rewards::Recommendation::NoCustomerError)
      end
    end

    context 'when no recommended_name given' do
      let(:recommended_name) { nil }

      it 'raises NoRecommendedNameError' do
        expect {
          recommendation
        }.to raise_error(Rewards::Recommendation::NoRecommendedNameError)
      end
    end

    context 'when no created_at given' do
      let(:created_at) { nil }

      it 'has created_at anyway' do
        expect(recommendation.created_at).not_to be_nil
      end
    end
  end
end
