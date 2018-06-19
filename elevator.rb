class Elevator
	
	@@person = []
	@@elevator = {status: "down", floor: 0}
			
	def self.sortQueue
		tab_up, tab_down = @@person.partition { |x| x[:action] == "up" }
	#	up_a, up_b = tab_up.partition { |x| x[:in_floor] > @@elevator[:floor] }
	#	up_a.sort_by! { |k| k[:in_floor] }
	#	tab_up = up_a.push(*up_b)
	#	down_a, down_b = tab_down.partition { |x| x[:in_floor] > @@elevator[:floor] }
	#	down_a.sort_by! { |k| k[:in_floor] }.reverse!
	#	down_b.sort_by! { |k| k[:in_floor] }.reverse!
	#   tab_down = down_b.push(*down_a)
		tab_down.sort_by! { |k| k[:in_floor] }.reverse!
		tab_up.sort_by! { |k| k[:in_floor] }
		if @@elevator[:status] == "up"
			@@person = tab_up.push(*tab_down)
		elsif @@elevator[:status] == "down"
			@@person = tab_down.push(*tab_up)
		end
	end

	def protoElevator
		while true do
			if @@person.any?
				if @@person[0][:state] == 'off' and @@elevator[:floor] < @@person[0][:in_floor]
					@@elevator[:status] = "up"
					@@elevator[:floor] += 1
				elsif @@person[0][:state] == 'off' and @@elevator[:floor] > @@person[0][:in_floor]
					@@elevator[:status] = "down"
					@@elevator[:floor] -= 1
				elsif @@person[0][:state] == 'off' and @@elevator[:floor] == @@person[0][:in_floor]
					@@person[0][:state] = 'on'
					if @@person[0][:action] == 'up'
						if @@elevator[:floor] + 1 >= 5
							@@person[0][:in_floor] = 5
						else
							@@person[0][:in_floor] = rand(@@elevator[:floor] + 1...5)
						end
					else
						if @@elevator[:floor] - 1 <= 0
							@@person[0][:in_floor] = 0
						else
							@@person[0][:in_floor] = rand(0...@@elevator[:floor] - 1)
						end
					end
					puts "Person " + @@person[0][:id].to_s + " is entering the elevator and wants to go at floor " + @@person[0][:in_floor].to_s
				elsif @@person[0][:state] == 'on' and @@elevator[:floor] < @@person[0][:in_floor]
					@@elevator[:status] = "up"
					@@elevator[:floor] += 1
				elsif @@person[0][:state] == 'on' and @@elevator[:floor] > @@person[0][:in_floor]
					@@elevator[:status] = "down"
					@@elevator[:floor] -= 1
				elsif @@person[0][:state] == 'on' and @@elevator[:floor] == @@person[0][:in_floor]
					puts "Person " + @@person[0][:id].to_s + " is exiting the elevator"
					@@person.shift
				end
			end
			self.class.sortQueue
			puts "Elevator is in floor: " + @@elevator[:floor].to_s
			sleep 1
		end
	end
	
	def randomAction
		while true do
			action = ["down", "up"]
			res_action = action[rand(2)]
			res_floor = rand(5)
			id = rand(100)
			@@person << {action: res_action, in_floor: res_floor, state: "off", id: id}
			puts "A new call is made: the person with the ID " + id.to_s + " wants to go " + res_action + " and is in floor " + res_floor.to_s
			self.class.sortQueue
			sleep 3
		end
	end
end

E = Elevator.new

t1 = Thread.new{E.protoElevator}
t2 = Thread.new{E.randomAction}

t1.join
t2.join
