require "pry-nav"
require "singleton"

class TrackerHelper
  include Singleton

  attr_accessor :stop_execution
end

module NilTracker
  def method_missing(method, *args, &block)
    error_message = "=====> Trying to call method `#{method}` nil (NoMethodError)"

    puts error_message
    puts caller.take(5).join("\n")
    puts "=====> args: #{args}" if args&.size > 0
    puts "=====> block: #{block.source}" if block

    if stop_execution?
      puts "====> Raising NoMethodError <====="
      raise NoMethodError.new(error_message)
    else
      puts "=====> NoMethodError ignored"
      puts "================================\n\n"
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    puts "=====> Calling respond_to_missing? method: `#{method_name}` in a nil instance"
    false
  end

  def stop_execution?
    tracker_helper.stop_execution
  end

  def tracker_helper
    TrackerHelper.instance
  end

  def stop_execution(value)
    tracker_helper.stop_execution = value
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

  def to_str
    ""
  end
end

















########  CODE FOR DEMO ################

nil.extend(NilTracker)
#  nil.stop_execution(true)

data = nil
data.help1 # rescue "Exception"

# nil.stop_execution(false)

data.help2("help is on the way", value: true)

data.help3 { puts "Help is on the way" }

# binding.pry



