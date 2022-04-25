module ApplicationService
    module ClassMethods
        def call(*args)
            new(*args).call
        end
    end

    def self.prepended(base)
        base.extend ClassMethods
    end

    attr_reader :errors

    def initialize(*args)
        super(*args)
        @errors = []
    end

    def call
        super
        self
    end

    def failure?
        @errors.any?
    end

    def success?
        !failure?
    end

    private

    def fail!(messages)
        @errors += Array(messages)
        self
    end
end