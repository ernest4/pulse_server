def __icr_exec__
  [{:a => "A", :b => "B"}, {:a => "C", :b => "D"}].each {|x| puts x}
  [{:a => "A", :b => "B"}, {:a => "C", :b => "D"}].each {|x| a, b = x.values_at(:a, :b); puts a; puts b}
  exit
end

puts "|||YIH22hSkVQN|||#{__icr_exec__.inspect}"