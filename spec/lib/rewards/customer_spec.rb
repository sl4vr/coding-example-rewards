# frozen_string_literal: true

require 'spec_helper'

describe Rewards::Customer do
  let(:name) { 'Test' }
  subject(:customer) { Rewards::Customer.new(name) }

  describe '.new' do
    it { is_expected.to be_kind_of(Rewards::Customer) }

    it 'has name' do
      expect(customer.name).to eq(name)
    end

    it 'has 0.0 score' do
      expect(customer.score).to eq(0.0)
    end

    context 'when no name given' do
      let(:name) { nil }

      it 'raises NoNameError' do
        expect { subject }.to raise_error(Rewards::Customer::NoNameError)
      end
    end
  end

  describe '#add_score' do
    it 'adds score' do
      score_was = customer.score
      score = 3.2

      customer.add_score(score)

      expect(customer.score).to eq(score_was + score)
    end

    context 'when non-numeric given' do
      it 'raises NonNumericScoreError' do
        expect {
          customer.add_score('10')
        }.to raise_error(Rewards::Customer::NonNumericScoreError)
      end
    end
  end
end
