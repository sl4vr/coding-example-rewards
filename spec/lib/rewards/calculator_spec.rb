# frozen_string_literal: true

require 'spec_helper'

describe Rewards::Calculator do
  let(:customer_repo) { Rewards::CustomerRepository.new }
  let(:recommendation_repo) { Rewards::RecommendationRepository.new }
  let(:parser) { Rewards::Parser.new(input) }
  let(:rewarder) { Rewards::Rewarder.new(recommendation_repo) }

  subject(:calculator) do
    Rewards::Calculator.new(
      parser: parser,
      customers: customer_repo,
      recommendations: recommendation_repo,
      rewarder: rewarder
    )
  end

  describe '#calculate' do
    subject { calculator.calculate }

    context 'when regular input' do
      let(:input) { File.read("#{ENV['ROOT_PATH']}/spec/fixtures/input.txt") }

      it { is_expected.to eq({'A' => 1.75, 'B' => 1.5, 'C' => 1}) }
    end

    context 'when polluted input' do
      let(:input) do
        File.read("#{ENV['ROOT_PATH']}/spec/fixtures/polluted_input.txt")
      end

      it { is_expected.to eq({'A' => 1.75, 'B' => 1.5, 'C' => 1}) }
    end

    context 'when extended input' do
      let(:input) do
        File.read("#{ENV['ROOT_PATH']}/spec/fixtures/extended_input.txt")
      end

      it { is_expected.to eq(
        {'A' => 2.375, 'B' => 2.75, 'C' => 1.5, 'D' => 1.0}
      ) }
    end
  end
end
