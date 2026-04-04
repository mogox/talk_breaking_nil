
# Inside a view
span = @tags[:level][:label]

# Inside a controller
@tags = props[:tags]
@labels = props[:labels]


# Inside a Helper
def level_icon(level)
  case level[:filter]
  when "beginner"
    "beginner_123.png"
  when "intermediate"
    "intermediate_456.png"
  when "advanced"
    "advanced_678.png"
  else
    "beginner_123.png"
  end
end

# module NilTracker
#   def method_missing(method, *args, &block)
#   	if @recoverable_methods.include?(method)
#   		setup_method(method, params: args)
#   	else

#   	end
#   end

#   def setup_method(method, result, params: nil)
#   	define_method(method.to_sym, *params) { result }
#   end
# end