连接 = (...) ->
	带有 with 变量a
		\函数!
	带有 with 变量a
		\函数 ...

	列表生成 [项目[i] for i = 1, 10]
	列表生成 [项目[i] ... for i = 1, 10]
	列表生成 [物品 for 物品 in *项目]
	列表生成 [物品 ... for 物品 in *项目]

	类生成 class 变量A
		函数!
	类生成 class 变量A
		函数 ...

	表生成 {键, 值 for 键, 值 in pairs 表}
	表生成 {键, 值 ... for 键, 值 in pairs 表}
	表生成 {物品, true for 物品 in *项目}
	表生成 {物品(...), true for 物品 in *项目}

	做操作 do
		函数!
	做操作 do
		函数 ...

	当操作 while false
		函数!
	当操作 while false
		函数 ...

	如果操作 if false
		函数!
	如果操作 if false
		函数 ...

	除非操作 unless true
		函数!
	除非操作 unless true
		函数 ...

	切换操作 switch 变量x
		when "abc"
			函数!
	切换操作 switch 变量x
		when "abc"
			函数 ...

	表达式操作 函数?!
	表达式操作 函数? ...

	冒号 f!\函数
	冒号 f(...)\函数

	_ = ->
		列表 = {1, 2, 3, 4, 5}
		函数名 = (确定) ->
		  确定, table.unpack 列表
		确定, ... = 函数名 true
		打印 确定, ...

		多参数函数 = ->
		  10, nil, 20, nil, 30

		... = 多参数函数!
		打印 select "#", ...
		打印 ...

	do
		... = switch 变量x when 1
			with 表
				.变量x = 123
		else
			表2
		打印 ...

	do
		... = 1, 2, if 条件
			3, 4, 5
		打印 ...

	do
		表, ... =
			名字: "abc"
			值: 123
		打印 ...
	nil

