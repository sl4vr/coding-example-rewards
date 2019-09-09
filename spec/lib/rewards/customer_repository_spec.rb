# frozen_string_literal: true

require 'spec_helper'

describe Rewards::CustomerRepository do
  subject(:customer_repo) do
    repository = Rewards::CustomerRepository.new
    repository.instance_variable_set('@customers', customers)
    repository
  end

  let(:customer_a) { Rewards::Customer.new('A') }
  let(:customer_b) { Rewards::Customer.new('B') }
  let(:customer_c) { Rewards::Customer.new('C') }

  let(:customers) { [customer_a, customer_b, customer_c] }

  describe '.new' do
    subject(:customer_repo) { Rewards::CustomerRepository.new }

    it 'creates empty repository' do
      expect(customer_repo.instance_variable_get('@customers')).to be_empty
    end
  end

  describe '#find' do
    let(:name) { 'B' }

    it 'returns customer with given name' do
      customer = customer_repo.find(name)

      expect(customer).to be(customer_b)
    end

    context 'when customer does NOT exist' do
      let(:name) { 'D' }

      it 'raises CustomerNotFoundError' do
        expect {
          customer_repo.find(name)
        }.to raise_error(Rewards::CustomerRepository::CustomerNotFoundError)
      end
    end
  end

  describe '#create' do
    let(:name) { 'D' }

    it 'creates customer and stores it in repository' do
      customer_repo.create(name)

      expect(customer_repo.instance_variable_get('@customers').count).to eq(4)
    end

    context 'when customer with same name already exists' do
      let(:name) { 'A' }

      it 'raises CustomerNotFoundError' do
        expect {
          customer_repo.create(name)
        }.to raise_error(Rewards::CustomerRepository::CustomerExistsError)
      end
    end
  end

  describe '#find_or_create' do
    context 'when customer does NOT exist' do
      let(:name) { 'D' }

      it 'creates customer and stores it in repository' do
        customer_repo.find_or_create(name)
  
        expect(customer_repo.instance_variable_get('@customers').count).to eq(4)
      end

      it 'returns customer with given name' do
        customer = customer_repo.find_or_create(name)
  
        expect(customer.name).to be(name)
      end
    end

    context 'when customer with same name already exists' do
      let(:name) { 'A' }

      it 'returns customer with given name' do
        customer = customer_repo.find_or_create(name)
  
        expect(customer).to be(customer_a)
      end
    end
  end

  describe '#all' do
    it 'returns customers array' do
      expect(customer_repo.all).to match(customers)
    end
  end
end
