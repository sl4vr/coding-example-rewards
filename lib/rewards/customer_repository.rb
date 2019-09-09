# frozen_string_literal: true

module Rewards
  # Customer store and access
  class CustomerRepository
    CustomerRepositoryError = Class.new(StandardError)
    CustomerNotFoundError = Class.new(CustomerRepositoryError)
    CustomerExistsError = Class.new(CustomerRepositoryError)

    def initialize
      @customers = []
    end

    def find(name)
      customer = try_find(name)

      unless customer
        raise CustomerNotFoundError, "No customer with name #{name}"
      end

      customer
    end

    def create(name)
      if try_find(name)
        raise CustomerExistsError, "Customer with name #{name} already exists"
      end

      customer = Customer.new(name)
      @customers << customer
      customer
    end

    def find_or_create(name)
      try_find(name) || create(name)
    end

    def all
      @customers
    end

    private

    def try_find(name)
      @customers.find { |customer| customer.name == name }
    end
  end
end
