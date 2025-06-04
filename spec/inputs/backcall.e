do
	(x) <- map {1,2,3}
	x * 2

do
	(x) <- map _,{1,2,3}
	x * 2

do
	(x) <- filter _, do
		(x) <- map _,{1,2,3,4}
		x * 2
	x > 2

do
	data <- http?.get "ajaxtest"
	body[".result"]\html data
	processed <- http.post "ajaxprocess", data
	body[".result"]\append processed
	<- setTimeout 1000
	print "done"

do
	<- syncStatus
	(err, data="nil") <- loadAsync "file.yue"
	if err
		print err
		return
	(codes) <- compileAsync data
	func = loadstring codes
	func!

do
	<- f1
	<- f2
	do
		<- f3
		<- f4
	<- f5
	<- f6
	f7!

do
	:result,:msg = do
		(data) <- receiveAsync "filename.txt"
		print data
		(info) <- processAsync data
		check info
	print result,msg

	totalSize = (for file in *files
		(data) <- loadAsync file
		addToCache file,data) |> reduce 0,(a,b)-> a+b

propA = do
	(value) <= property => @_value
	print "old value: #{@_value}"
	print "new value: #{value}"
	@_value = value

propB = do
	<= property _, (value)=>
		print "old value: #{@_value}"
		print "new value: #{value}"
		@_value = value
	@_value

alert "hi"

local x, y, z
x = do (a) < -b
x, y, z = do (a) <- b
x, y, z = do (a) <-b

x = do a <= b
x, y, z = do (a) <= b

nil

