import bind from grasp
(bind stmt) color: "Red"

a = 'b'
c = d
(a b) c d
import c from d
(a b) c d
(c d) a b
a, b = c, d
(d a) c

macro f = (func,arg)-> "(#{func}) #{arg}"
for i = 1, 10
	a = ->
	$f print, 1
	a = f
	$f print, 2
	if cond
		$f print, 3
	::abc::
	(print) 4
	goto abc
	(print) 5

macro lua = (code)-> {
	:code
	type: "lua"
}

do
	print()
	1 |> b |> (a)
	print()
	<- (fn)

do
	print()
	() <- async_fn()
	print()
	$lua[==[
		--[[a comment to insert]]
		(haha)()
	]==]
	nil

macro v = -> 'print 123'
do
	global *
	$v!

do
	f
		:v

	tb = while f
		:v

	repeat
		print v
	until f
		:v

	with f
		:v = tb
		.x = 1

	x = if f
		:v

	x = switch f
		:v
		when f
			:v

	nums = for num = 1, len
		:num
	
	objects = for item in *items
		name: item

nil
