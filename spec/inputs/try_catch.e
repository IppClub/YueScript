f = ->
	try
		func 1, 2, 3
	catch err
		print err

	try func 1, 2, 3
	catch err
		print err

	try
		print "trying"
		func 1, 2, 3

	do
		success, result = try
			func 1, 2, 3
		catch err
			print err

		success, result = try func 1, 2, 3

	tb = {}

	try tb.func
	try tb.func!
	try tb.func()
	try (tb.func!)
	try (tb\func(1, 2, 3))

	try tb.func 1
	try tb.func(1)

	if (try func 1
	catch err
		print err)
		print "OK"

	if try (func 1)
	catch err
			print err
		print "OK"

	do
		if success, result := try func "abc", 123
			print result

		success, result = try func "abc", 123
		catch err
			print err

		print result if success, result := try func "abc", 123
		catch err
			print err

	do
		try
			func 1, 2, 3

		try func 1, 2, 3

	do
		<- x
		local tb, a, b, c
		f1 = -> try tb.f a, b, c

	do
		f1 = -> do
			ok, ... = try func!
			...

	do
		local func
		a, b, c = try? func!
	
	do
		a, b, c = try? func!

	do
		a = (try? func!) ?? "default"

	do
		f try? func!
	
	do
		f try?
			print 123
			func!
		catch e
			print e
			e

	nil

do
	try
		func 1, 2, 3
	catch err
		print err

	try func 1, 2, 3
	catch err
		print err

	try
		print "trying"
		func 1, 2, 3

	do
		success, result = try
			func 1, 2, 3
		catch err
			print err

		success, result = try func 1, 2, 3

	tb = {}

	try tb.func
	try tb.func!
	try tb.func()
	try (tb.func!)
	try (tb\func(1, 2, 3))

	try tb.func 1
	try tb.func(1)

	if (try func 1
	catch err
		print err)
		print "OK"

	if try (func 1)
	catch err
			print err
		print "OK"

	do
		if success, result := try func "abc", 123
			print result

		success, result = try func "abc", 123
		catch err
			print err

		print result if success, result := try func "abc", 123
		catch err
			print err

	do
		try
			func 1, 2, 3

		try func 1, 2, 3

	do
		<- x
		local tb, a, b, c
		f1 = -> try tb.f a, b, c

	do
		f1 = -> do
			ok, ... = try func!
			...

	do
		local func
		a, b, c = try? func!
	
	do
		a, b, c = try? func!

	do
		a = (try? func!) ?? "default"

	do
		f try? func!
	
	do
		f try?
			print 123
			func!
		catch e
			print e
			e

nil
