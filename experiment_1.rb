require "pry"

data = nil

data.help
data.help2("help is on the way", value: true)
data.help3 { puts "Help is on the way" }

# undefined method `help' for nil (NoMethodError)


