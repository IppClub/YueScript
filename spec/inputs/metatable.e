a = close: true, <close>: => print "out of scope"
b = <add>: (left, right)-> right - left
c = key1: true, :<add>, key2: true
w = <[name]>:123, <"new">:(val)=> {val}
w.<>["new"] w.<>[name]

do close _ = <close>: -> print "out of scope"

d, e = a.close, a.<close>

f = a\<close> 1
a.<add> = (x, y)-> x + y

do
	{:new, :<close>, <close>: closeA} = a
	print new, close, closeA

do
	local *
	x, \
	{:new, :var, :<close>, <close>: closeA}, \
	:num, :<add>, :<sub> \
	= 123, a.b.c, func!

x.abc, a.b.<> = 123, {}
func!.<> = mt --, extra
a, b.c.<>, d, e = 1, mt, "abc", nil

is_same = a.<>.__index == a.<index>

--
a.<> = __index: tb
a.<>.__index = tb
a.<index> = tb
--

mt = a.<>

tb\func #list
tb\<"func">list
tb\<"func"> list

import "module" as :<index>, <newindex>:setFunc

with tb
	print .<add>, .x\<index> "key"
	a = .<index>.<add>\<"new"> 123
	b = t#.<close>.test
	c = t #.<close> .test

<>:mt = a
a = <>:mt
a = <>:__index:mt

local index
<>:__index:index = a
:<index> = a

do <>:{new:ctor, :update} = a
do {new:ctor, :update} = a.<>

tb = {}
do
	f = tb\<"value#{x < y}">(123, ...)
	f tb\<'value'> 123, ...
	tb\<[[
		value
		1
	]]>(123, ...)
	return tb\<["value" .. tostring x > y]>(123, ...)

do
	f = tb\<'value'>(123, ...)
	f tb\<'value'>(123, ...)
	tb\<'value'>(123, ...)
	return tb\<'value'> 123, ...

do
	f = tb.<["value"]> 123, ...
	f = tb.<"value#{x < y}">(123, ...)
	f tb.<'value'> 123, ...
	tb.<[[ value
1]]>(123, ...)
	return tb.<["value" .. tostring x > y]>(123, ...)

nil
