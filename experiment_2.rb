require "pry-nav"
require "singleton"
require "awesome_print"

class TrackerHelper
  include Singleton

  attr_accessor :raise_exception
end

module NilTracker
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

    if raise_exception?
      ap "====> Raising NoMethodError <=====\n\n"
      raise NoMethodError.new(error_message)
    else
      ap "=====> NoMethodError ignored"
      ap "================================\n\n"
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    ap "=====> Calling respond_to_missing? method: `#{method_name}` in a nil instance"
    false
  end

  def raise_exception?
    tracker_helper.raise_exception
  end

  def tracker_helper
    TrackerHelper.instance
  end

  def raise_exception(value)
    tracker_helper.raise_exception = value
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

nil.extend(NilTracker)
nil.raise_exception(true)

data = nil
data.help1 rescue ap "Rescue, please ignore Exception\n\n"

nil.raise_exception(false)

data.help2("parameters go here", value: true)

data.help3 { ap "This is a block! and help is on the way" }



