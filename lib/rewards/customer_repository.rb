# frozen_string_literal: true

module Rewards
  # Customer store and access
  class CustomerRepository
    CustomerRepositoryError = Class.new(StandardError)
    CustomerExistsError = Class.new(CustomerRepositoryError)

    def initialize
      @customers = []
    end

    def find(name)
      @customers.find { |customer| customer.name == name }
    end

    def create(name)
      if find(name)
        raise CustomerExistsError, "Customer with name #{name} already exists"
      end

      customer = Customer.new(name)
      @customers << customer
      customer
    end

    def find_or_create(name)
      find(name) || create(name)
    end

    def all
      @customers
    end
  end
end
