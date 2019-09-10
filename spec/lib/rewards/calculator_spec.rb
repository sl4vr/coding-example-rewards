# frozen_string_literal: true

require 'spec_helper'

describe Rewards::Calculator do
  let(:customer_repo) { Rewards::CustomerRepository.new }
  let(:recommendation_repo) { Rewards::RecommendationRepository.new }
  let(:parser) { Rewards::Parser }
  let(:input) { File.read("#{ENV['ROOT_PATH']}/spec/fixtures/input.txt") }

  subject(:calculator) do
    Rewards::Calculator.new(
      input: input,
      parser: parser,
      customers: customer_repo,
      recommendations: recommendation_repo
    )
  end
  
  describe '#calculate' do
    subject { calculator.calculate }

    it { is_expected.to eq({ 'A' => 1.75, 'B' => 1.5, 'C' => 1 }) }
  end
end
