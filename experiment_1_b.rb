require "pry"

class NilClass
  # attr_accessor :stop_execution

  def method_missing(method, *args, &block)
    error_message = "=====> Trying to call method `#{method}` nil (NoMethodError)"
    puts error_message
    puts "=====> args: #{args}" if args&.size > 0
    puts "=====> block: #{block.source}" if block

    caller.each { |instruction|  puts "> #{instruction}" unless instruction.match("pry") }

    puts "=====> NoMethodError not raised"
    puts "================================\n\n"
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

  def respond_to_missing?(method_name, include_private = false)
    false
  end
end

number = 12
data = nil

data.stop_execution = true

data.help
data.help2("help is on the way", value: true)
data.help3 { puts "Help is on the way" }



# undefined method `help' for nil (NoMethodError)
# binding.pry

