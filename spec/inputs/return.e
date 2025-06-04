-- testing `return` propagation

_ = -> _ = x for x in *things
_ = -> [x for x in *things]


-- doesn't make sense on purpose
do
	for x in *things do return x

do
	return [x for x in *things]

do
	return {x,y for x,y in *things}

_ = ->
	if a
		if a
			a
		else
			b
	elseif b
		if a
			a
		else
			b
	else
		if a
			a
		else
			b


do
	return if a
		if a
			a
		else
			b
	elseif b
		if a
			a
		else
			b
	else
		if a
			a
		else
			b

do
	return
		:value
		itemA: 123
		itemB: "abc"

do
	return
		* 1
		* 2
		* ...three
		* 4

_ = -> a\b
do a\b


