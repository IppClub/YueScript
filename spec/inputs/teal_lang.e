import "macro_teal" as $

$local "a:{string:number}", {value:123}
$local "b:number", a.value

$function "add(a:number, b:number):number", -> a + b

s = add(a.value, b)
print(s)

$record Point,
	x: number
	y: number

$method "Point.new(x:number, y:number):Point", ->
	$local "point:Point", setmetatable {}, __index: Point
	point.x = x or 0
	point.y = y or 0
	point

$method "Point:move(dx:number, dy:number)", ->
	@x += dx
	@y += dy

$local "p:Point", Point.new 100, 100

p\move 50, 50

$function "filter(tab:{string}, handler:function(item:string):boolean):{string}", ->
	[item for item in *tab when handler item]

$function "cond(item:string):boolean", -> item ~= "a"

res = filter {"a", "b", "c", "a"}, cond
for s in *res
	print s
