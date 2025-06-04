describe "loops", ->
	it "should continue", ->
		input = {1,2,3,4,5,6}
		output = for x in *input
			continue if x % 2 == 1
			x

		assert.same { 2,4,6 }, output

	it "continue in repeat", ->
		output = {}
		a = 0
		repeat
			a += 1
			if a == 3
				continue
			if a == 5
				break
			output[] = a
		until a == 8

		assert.same { 1,2,4 }, output

