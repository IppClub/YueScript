join = (...) ->
	f_with with a
		\func!
	f_with with a
		\func ...

	f_listcomp [items[i] for i = 1, 10]
	f_listcomp [items[i] ... for i = 1, 10]
	f_listcomp [item for item in *items]
	f_listcomp [item ... for item in *items]

	f_class class A
		func!
	f_class class A
		func ...

	f_tblcomp {k, v for k, v in pairs tb}
	f_tblcomp {k, v ... for k, v in pairs tb}
	f_tblcomp {item, true for item in *items}
	f_tblcomp {item(...), true for item in *items}

	f_do do
		func!
	f_do do
		func ...

	f_while while false
		func!
	f_while while false
		func ...

	f_if if false
		func!
	f_if if false
		func ...

	f_unless unless true
		func!
	f_unless unless true
		func ...

	f_switch switch x
		when "abc"
			func!
	f_switch switch x
		when "abc"
			func ...

	f_eop func?!
	f_eop func? ...

	f_colon f!\func
	f_colon f(...)\func

	_ = ->
		list = {1, 2, 3, 4, 5}
		fn = (ok) ->
		  ok, table.unpack list
		ok, ... = fn true
		print ok, ...

		fn_many_args = ->
		  10, nil, 20, nil, 30

		... = fn_many_args!
		print select "#", ...
		print ...

	do
		... = switch x when 1
			with tb
				.x = 123
		else
			tb2
		print ...

	do
		... = 1, 2, if cond
			3, 4, 5
		print ...

	do
		tb, ... =
			name: "abc"
			value: 123
		print ...
	nil

