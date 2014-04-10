$dead = 'O'
$alive = '#'

class GameOfLife

	def initialize(size, init_life)
		@size = size
		@gof = Array.new(@size) { Array.new(@size) { |i| $dead }}

		init_life.each do |e|
			@gof[e[0]][e[1]] = $alive
		end

		showState
		puts

		loop do
			generate
			showState

			str = STDIN.getc
			exit if str.chr == 'q'
		end
		
	end

	def showState()
		@gof.each do |i|
			i.each { |j| print j }
			puts
		end
	end

	def neighbours(i,j)
		neighb = Array.new
		for k in -1..1
			for l in -1..1

				# continue if it is same cell
				next if k == 0 && l == 0

				temp_x = i + k
				temp_y = j + l
				if temp_x.between?(0,@size-1) && temp_y.between?(0,@size-1)
					neighb.push([temp_x, temp_y])
				end
			end
		end
		neighb
	end

	def neighboursAlive(i,j)
		count = 0
		neighbours(i,j).each do |e|
			if @gof[e[0]][e[1]] == $alive
			 	count = count + 1
			end
		end
		count
	end

	def generate()
		# dup and clone doesn't create a new array so do marshal
		temp_gof = Marshal.load( Marshal.dump(@gof) )

		for i in 0..@size-1
			neighb_alive = nil
			for j in 0..@size-1
				neighb_alive = neighboursAlive(i,j)

				if neighb_alive < 2
					temp_gof[i][j] = $dead
				elsif neighb_alive == 3
					temp_gof[i][j] = $alive
				elsif neighb_alive.between?(2,3)
					next
				elsif neighb_alive > 3
					temp_gof[i][j] = $dead
				end
			end
		end
		@gof = temp_gof
	end

end


puts "press \"q\" to quit or enter for next generation"
puts "\n blinker \n\n"
GameOfLife.new(3, [[1, 0], [1, 1], [1, 2]])


# puts "\n glider \n\n"
# GameOfLife.new(4, [[1,0],[2,1],[0,2],[1,2],[2,2]])