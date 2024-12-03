require "pry-nav"
require "singleton"
require "awesome_print"

module Wolvernil
  def method_missing(method, *args, &block)
    return if method == :call

    nil_tracker.log(method, caller.take(5).join("\n"), args, block)

    if raise_exception?
      error_message = "=====> Trying to call method `#{method}` nil (NoMethodError)"
      puts "====> Raising NoMethodError <=====\n\n"
      raise NoMethodError.new(error_message)
    else
      puts "=====> NoMethodError not raised for method #{method}"
      puts "================================\n\n"
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    p "=====> Calling respond_to_missing? method: `#{method_name}` in a nil instance"
    false
  end

  def raise_exception?
    nil_tracker.raise_exception
  end

  def raise_exception(value)
    nil_tracker.raise_exception = value
  end

  def self.methods_list
    NilTracker.instance.methods_list
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

  def []=(key, value)
  end

  def process_wait
    super
  end

  def call(*args)
    super(args)
  end

  def permitted?
    false
  end

  private

  def nil_tracker
    NilTracker.instance
  end
end

class NilTracker
  include Singleton

  attr_accessor :raise_exception

  def methods_list
    @methods_list ||= {}
  end

  def log(method, caller_lines, *args,  &block)
    error_message = "=====> Trying to call method **#{method}** in `nil` (NoMethodError)"

    puts error_message
    puts "=====> Caller: (stacktrace)"
    puts caller.take(5).join("\n")
    puts "=====> args: #{args}" if args&.size > 0
    puts "=====> block: #{block.source}" if block

    create_method(method, args, block)
    store_method_info(method, caller_lines, args, block)
  end

  def create_method(method, *args, &block)
    return if methods_list[method]

    Wolvernil.define_method(method) do |*args, &block|
      p "---> Calling a method #{method} in the nil class, this has been logged"
    end
  end

  def store_method_info(method, caller_lines, *args,  &block)
    new_block = args[1].source if args[1]&.class == Proc
    methods_list[method] =  {
      args:, block: new_block, caller_lines:, timestamp: Time.now
    }
  end
end














########  CODE FOR DEMO ################
# require 'wolvernil'

class RubyConf
  def break_nil_more
    puts "Done testing help1 \n\n\n"

    nil.raise_exception(false)
    data.help2("help is on the way", value: true)
    data.help3 { puts "Help is on the way" }
  end

  def data
    nil
  end











  def break_nil
    # nil setup
    nil.extend(Wolvernil)
    nil.raise_exception(true)

    data.help1(value: true) rescue "Oops exception raised, don't wake up the team log"

    5.times.each do |variable|
      data.help1(value: true)
    end
  end
end

conf = RubyConf.new
conf.break_nil

# conf.break_nil_more





