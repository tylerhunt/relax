module Relax
  module Contextable # :nodoc:
    def context
      @context ||= Context.new
    end

    def extend_context(base)
      @context = base.context.clone
    end

    def defaults(&block)
      context.evaluate(&block)
    end
  end
end
