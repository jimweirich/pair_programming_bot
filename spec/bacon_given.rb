module Bacon

  class VarStack

  end

  class Context
    LET_VARS = {}

    def context(desc=nil, &block)
      puts "START CONTEXT '#{desc}'"
      describe(&block)
      puts "END CONTEXT '#{desc}'"
    end

    def let(arg, &block)
      puts "DBG: arg=#{arg.inspect}"
      LET_VARS[arg] = { block: block, value: nil, set: false }
    end

    def let!(arg, &block)
      _let_define_value(let(arg, &block))
    end

    def Given(arg, &block)
      let(arg, &block)
    end

    def Given!(arg, &block)
      let!(arg, &block)
    end

    def When(arg=nil, &block)
      if arg
        let!(arg, &block)
      else
        before(&block)
      end
    end

    def Then(&block)
      it("<then>", &block)
    end

    def _let_define_value(let_var)
      let_var[:value] = let_var[:block].call
      let_var[:set] = true
      let_var
    end

    def method_missing(sym, *args, &block)
      let_var = LET_VARS[sym]
      if let_var
        _let_define_value(let_var) unless let_var[:set]
        let_var[:value]
      else
        super
      end
    end
  end
end

