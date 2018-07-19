# frozen_string_literal: true

module Piktur::Spec::Helpers

  module Inheritance

    STRATEGIES ||= {}

    STRATEGIES[:clone] ||= lambda do |klass, anonymous: false, **options, &block|
      if anonymous
        klass.clone(&block)
      else
        Test.safe_const_reset(:Clone, klass.clone(&block))
      end
    end

    STRATEGIES[:subclass] ||= lambda do |klass, anonymous: false, **options, &block|
      if anonymous
        Class.new(klass, &block)
      else
        Test.safe_const_reset(:SubClass, ::Class.new(klass, &block))
      end
    end

    def self.extended(base)
      base.include self
    end

    # @example
    #   include context 'inheritance',
    #                   :clone,            # the duplication strategy
    #                   anonymous: false   # assign to constant?
    #                   dfn: ->(klass) { } # the definition
    def define_class(strategy, klass, **options, &block)
      STRATEGIES[strategy][klass, **options, &block]
    end

  end

end
