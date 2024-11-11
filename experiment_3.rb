require "pry-nav"
require "singleton"
require "awesome_print"

module Wolvernil
  def method_missing(method, *args, &block)
    return if method == :call

    nil_tracker.log(method, caller.take(5).join("\n"), args, block)

    if stop_execution?
      puts "====> Raising NoMethodError <====="
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

  def stop_execution?
    nil_tracker.stop_execution
  end

  def stop_execution(value)
    nil_tracker.stop_execution = value
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

  attr_accessor :stop_execution

  def methods_list
    @methods_list ||= {}
  end

  def log(method, caller_lines, *args,  &block)
    error_message = "=====> Trying to call method `#{method}` nil (NoMethodError)"

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
      p "---> Calling a method #{method} in the nil class, this has been recorded"
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

class RubyConf
  def break_nil

    nil.extend(Wolvernil)
    nil.stop_execution(true)

    data = nil
    data.help1  rescue "Oops exception raised, don't wake up the team log"

    5.times.each do |variable|
      data.help1
    end

    nil.stop_execution(false)
    data.help2("help is on the way", value: true)
    data.help3 { puts "Help is on the way" }

    ap "Missing methods: "
    ap Wolvernil.methods_list
  end
end

RubyConf.new.break_nil


