require "pry"

module NilTracker
  def method_missing(method, *args, &block)
    error_message = "=====> Trying to call `#{method}` from nil instance"
    puts error_message
    puts "=====> args: #{args}" if args&.size > 0
    puts "=====> block: #{block.source}" if block

    caller.each { |instruction|  puts instruction unless instruction.match("pry") }

    if @@stop_execution
      raise NoMethodError.new(error_message)
    else
      puts "=====> NoMethodError not raised"
      puts "================================\n\n"
    end
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
    p "=====> Calling respond_to_missing? method: `#{method_name}` in a nil instance"
    false
  end

  def self.stop_execution(stop)
    @@stop_execution = stop
  end
end

NilTracker.stop_execution(false)
nil.extend(NilTracker)

data = nil
data.help1

data.help2("help is on the way", value: true)

data.help3 { puts "Help is on the way" }


