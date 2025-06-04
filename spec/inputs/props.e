class Props
	__index: (name): nil =>
		cls = @.<>
		if item := cls.__getter?[name] -- access properties
			return item @
		elseif item := rawget cls, name -- access member functions
			return item
		else
			c = cls
			while c := c.<> -- recursive to access base classes
				if item := c.__getter?[name]
					cls.__getter ??= {}
					cls.__getter[name] = item -- cache base properties to class
					return item @
				elseif item := rawget c, name
					rawset cls, name, item -- cache base member to class
					return item

	__newindex: (name, value) =>
		cls = @.<>
		if item := cls.__setter?[name] -- access properties
			item @, value
		else
			c = cls
			while c := c.<> -- recursive to access base classes
				if item := c.__setter?[name]
					cls.__setter ??= {}
					cls.__setter[name] = item -- cache base property to class
					item @, value
					return
			rawset @, name, value -- assign field to self

	assignReadOnly = -> error "assigning a readonly property"

	prop: (name, props) =>
		{
			:get
			:set = assignReadOnly
		} = props
		if getter := rawget @__base, "__getter"
			getter[name] = get
		else
			rawset @__base, "__getter", [name]: get
		if setter := rawget @__base, "__setter"
			setter[name] = set
		else
			rawset @__base, "__setter", [name]: set

class A extends Props
	@prop 'x'
		get: => @_x + 1000
		set: (v) => @_x = v
	new: =>
		@_x = 0
		
class B extends A
	@prop 'abc', get: => "hello"

b = B!
b.x = 999
print b.x, b.abc
