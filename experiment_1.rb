require "pry-nav"
require "awesome_print"

class NilClass
  def method_missing(method, *args, &block)
    error_message = "=====> Trying to call method `#{method}` nil (NoMethodError)"

    ap error_message
    ap caller.take(5).join("\n")
    if args&.size > 0
      ap "=====> args:"
      ap args
    end
    if block
      ap "=====> block:"
      ap block.source
    end

    ap "=====> NoMethodError ignored"
    ap "================================\n\n"
  end

  def respond_to_missing?(method_name, include_private = false)
    false
  end

  def to_ary
    []
  end

  def to_h
    {}
  end

  def to_hash
    {}
  end
end



























########  CODE FOR DEMO ################


number = 12
data = nil

data.help
data.help2("help is on the way", value: true)
data.help3 { ap "Help is on the way" }

# binding.pry




