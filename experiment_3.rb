require "pry-nav"
require "singleton"

module NilTracker
  def method_missing(method, *args, &block)
    return if method == :call

    error_message = "=====> Trying to call method `#{method}` nil (NoMethodError)"

    puts error_message
    puts caller.take(5).join("\n")
    puts "=====> args: #{args}" if args&.size > 0
    puts "=====> block: #{block.source}" if block

    wolvernil.log(method, caller.take(5).join("\n"), args, block)

    if @@stop_execution
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

  def self.stop_execution(stop)
    @@stop_execution = stop
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

  private

  def wolvernil
    Wolvernil.instance
  end
end

class Wolvernil
  include Singleton

  def methods_list
    @methods_list ||= {}
  end

  def log(method, caller_lines, *args,  &block)
    create_method(method, args, block)
    methods_list[method] =  {
      args:, block:, caller_lines:, timestamp: Time.now
    }
  end

  def create_method(method, *args, &block)
    NilClass.define_method(method) do |*args, &block|
      p "---> Calling a method #{method} in the nil class, this has been recorded"
    end
  end
end

class RubyConf
  def break_nil
    NilTracker.stop_ex(true)
    nil.extend(NilTracker)

    data = nil
    data.help1  rescue "Opps exception raised, don't wake up the team log"

    #  data.help2("help is on the way", value: true)

    # data.help3 { puts "Help is on the way" }
    5.times.each do |variable|
      data.help1
    end
    # data.help2("ops")

    p "Missing methods: "
    p Wolvernil.instance.methods_list
  end
end


RubyConf.new.break_nil