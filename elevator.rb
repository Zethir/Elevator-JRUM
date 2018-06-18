class Elevator
	
	@@person = []
	def protoElevator
		elevator = {status: "up", floor: 0}
		while true do
			if @@person.any?
				puts @@person
				if @@person[0][:state] == 'off' and elevator[:floor] < @@person[0][:in_floor]
					elevator[:floor] += 1
				elsif @@person[0][:state] == 'off' and elevator[:floor] > @@person[0][:in_floor]
					elevator[:floor] -= 1
				elsif @@person[0][:state] == 'off' and elevator[:floor] == @@person[0][:in_floor]
					@@person[0][:state] = 'on'
					if @@person[0][:action] == 'up'
						if elevator[:floor] + 1 == 5
							@@person[0][:goes_to] = 5
						elsif
							@@person[0][:goes_to] = rand(elevator[:floor] + 1...5)
						end
					else
						if elevator[:floor] - 1 == 0
							@@person[0][:goes_to] = 0
						elsif
							@@person[0][:goes_to] = rand(0...elevator[:floor] - 1)
						end
					end
				elsif @@person[0][:state] == 'on' and elevator[:floor] < @@person[0][:goes_to]
					elevator[:floor] += 1
				elsif @@person[0][:state] == 'on' and elevator[:floor] > @@person[0][:goes_to]
					elevator[:floor] -= 1
				elsif @@person[0][:state] == 'on' and elevator[:floor] == @@person[0][:goes_to]
					puts "shift elem"
					@@person.shift
				end
			end
			puts "Elevator is in floor: " + elevator[:floor].to_s
			sleep 1
		end
	end
	
	def randomAction
		while true do
			action = ["down", "up"]
			@@person << {action: action[rand(2)], in_floor: rand(5), goes_to: nil, state: "off"}
			sleep 7
		end
	end
end

E = Elevator.new

t1 = Thread.new{E.protoElevator}
t2 = Thread.new{E.randomAction}

t1.join
t2.join
