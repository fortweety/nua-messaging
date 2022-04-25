class StubResponse
  def initialize(status)
    @status = status
    @errors = []
  end
  attr_reader :status
  attr_accessor :errors
end

class Provider
  def debit_card(user, err = false)
    if err
      res = StubResponse.new(422)
      res.errors << 'connection error'
      res
    else
      StubResponse.new(201)
    end
  end
end

class PaymentProviderFactory
  def self.provider
    @provider ||= Provider.new
  end
end
