{
	:help3 => {
		:args => [
			[0] [],
			[1] #<Proc:0x000000011bd838f0 experiment_3.rb:121>
		],
		:block => "data.help3 { puts \"Help is on the way\" }\n",
		:caller_lines => "experiment_3.rb:121:in `break_nil'\nexperiment_3.rb:129:in `<main>'",
		:timestamp => 2024-11-10 16:34:43.744649 -0800
	}
}

def mark_lesson_complete(user_id:, lesson_id:)
  user = User.find_by(id: user_id)
  user&.complete(lesson_id)
end

# Called with:
mark_lesson_complete(user_id: params[:user_id], lesson_id: params[:lesson_id])


### Experiment 0
[1] pry(main)> ls nil
NilClass#methods:
  &    =~  inspect  pretty_print_cycle  to_a  to_f  to_i  to_s
  ===  ^   nil?     rationalize         to_c  to_h  to_r  |


### Experiment 1
[1] pry(main)> ls nil
NilClass#methods:
  &    =~  inspect         nil?                rationalize  to_ary  to_f  to_hash  to_r  |
  ===  ^   method_missing  pretty_print_cycle  to_a         to_c    to_h  to_i     to_s

### Experiment 2
[1] pry(main)> ls nil

NilTracker#methods:
  method_missing  stop_execution  stop_execution?  to_ary  to_hash  to_str  tracker_helper
NilClass#methods:
  &    =~  inspect  pretty_print_cycle  to_a  to_f  to_i  to_s
  ===  ^   nil?     rationalize         to_c  to_h  to_r  |



### Experiment 3
[1] pry(#<RubyConf>)> ls nil

Wolvernil#methods:
  []=   help1  help3           permitted?    stop_execution   to_ary   to_str
  call  help2  method_missing  process_wait  stop_execution?  to_hash

NilClass#methods:
  &    =~  inspect  pretty_print_cycle  to_a  to_f  to_i  to_s
  ===  ^   nil?     rationalize         to_c  to_h  to_r  |


 Timeout.timeout(timeout, Timeout::Error, "eeeeeeeror") do

  sleep 10
  put "Done"

end