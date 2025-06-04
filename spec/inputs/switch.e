
switch value
	when "cool"
		print "hello world"


switch value
	when "cool"
		print "hello world"
	else
		print "okay rad"


switch value
	when "cool"
		print "hello world"
	when "yeah"
		_ = [[FFFF]] + [[MMMM]]
	when 2323 + 32434
		print "okay"
	else
		print "okay rad"

out = switch value
	when "cool" then print "hello world"
	else print "okay rad"

out = switch value
	when "cool" then xxxx
	when "umm" then 34340
	else error "this failed big time"

with something
	switch \value!
		when .okay
			_ = "world"
		else
			_ = "yesh"

fix this
call_func switch something
	when 1 then "yes"
	else "no"

--

switch hi
	when hello or world
		_ = greene

--

switch hi
	when "one", "two"
		print "cool"
	when "dad"
		_ = no

switch hi
	when 3+1, hello!, (-> 4)!
		_ = yello
	else
		print "cool"

do
	dict = {
		{}
		{1, 2, 3}
		a: b: c: 1
		x: y: z: 1
	}

	switch dict
		when {
				first
				{one, two, three}
				a: b: :c
				x: y: :z
			}
			print first, one, two, three, c, z

do
	items =
		* x: 100
			y: 200
		* width: 300
			height: 400
		* false

	for item in *items
		switch item
			when :x, :y
				print "Vec2 #{x}, #{y}"
			when :width, :height
				print "Size #{width}, #{height}"
			when false
				print "None"
			when __class: cls
				switch cls
					when ClassA
						print "Object A"
					when ClassB
						print "Object B"
			when <>: mt
				print "A table with metatable"
			else
				print "item not accepted!"

do
	tb = {}

	switch tb
		when {:a = 1, :b = 2}
			print a, b

	switch tb
		when {:a, :b = 2}
			print "partially matched", a, b

	switch tb
		when {:a, :b}
			print a, b
		else
			print "not matched"
do
	tb = x: "abc"
	switch tb
		when :x, :y
			print "x: #{x} with y: #{y}"
		when :x
			print "x: #{x} only"

do
	matched = switch tb
		when 1
			"1"
		when :x
			x
		when false
			"false"
		else
			nil

do
	return switch tb
		when nil
			"invalid"
		when :a, :b
			"#{a + b}"
		when 1, 2, 3, 4, 5
			"number 1 - 5"
		when {:matchAnyTable = "fallback"}
			matchAnyTable
		else
			"should not reach here unless it is not a table"

do
	switch y
		when {x: <>: mt}
			print mt

do
	switch tb
		when [ [item,],]
			print item
		when [a = 1, b = "abc"]
			print a, b

do
	switch tb
		when [1, 2, 3]
			print "1, 2, 3"
		when [1, b, 3]
			print "1, #{b}, 3"
		when [1, 2, b = 3]
			print "1, 2, #{b}"

do
	switch tb
		when success: true, :result
			print "success", result
		when success: false
			print "failed", result
		else
			print "invalid"

do
	switch tb
		when {type: "success", :content}
			print "success", content
		when {type: "error", :content}
			print "failed", content
		else
			print "invalid"

do
	switch tb
		when [
				{a: 1, b: 2}
				{a: 3, b: 4}
				{a: 5, b: 6}
				fourth
			]
			print "matched", fourth

	switch tb
		when [
				{c: 1, d: 2}
				{c: 3, d: 4}
				{c: 5, d: 6}
			]
			print "OK"
		when [
				_
				_
				{a: 1, b: 2}
				{a: 3, b: 4}
				{a: 5, b: 6}
				sixth
			]
			print "matched", sixth

do
	switch v := "hello"
		when "hello"
			print "matched hello"
		else
			print "not matched"
	-- output: matched hello

do
	f = -> "ok"
	switch val := f!
		when "ok"
			print "it's ok"
	-- output: it's ok


do
	g = -> 42
	switch result := g!
		when 1, 2
			print "small"
		when 42
			print "life universe everything"
		else
			print "other #{result}"
	-- output: life universe everything

do
	check = ->
		if true
			"yes"
		else
			"no"

	switch x := check!
		when "yes"
			print "affirmative"
		else
			print "negative"
	-- output: affirmative

do
	t = (): tb ->
		tb = {a: 1}
		tb.a = 2

	switch data := t!
		when {a: 2}
			print "matched"
		else
			print "not matched"

nil
