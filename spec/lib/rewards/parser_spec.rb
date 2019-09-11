# frozen_string_literal: true

require 'spec_helper'

describe Rewards::Parser do
  let(:input) { File.read("#{ENV['ROOT_PATH']}/spec/fixtures/input.txt") }
  subject(:parser) { Rewards::Parser.new(input) }

  describe '#parse' do
    subject(:result) { parser.parse }

    it { is_expected.to be_kind_of(Array) }

    it { is_expected.to all(respond_to(:to_h)) }

    context 'when there are lines with wrong format' do
      let(:input) do
        File.read("#{ENV['ROOT_PATH']}/spec/fixtures/polluted_input.txt")
      end

      it 'parses only correct ones' do
        expect(result.count).to eq(7)
      end
    end
  end
end
