# 函数存根

&emsp;&emsp;在编程中，将对象的方法作为函数类型的值进行传递是一种常见做法，尤其是在将实例方法作为回调函数传递给其他函数的情形中。当目标函数需要将该对象作为其第一个参数时，我们需要找到一种方式将对象和函数绑定在一起，以便能够正确地调用该函数。

&emsp;&emsp;函数存根（stub）语法提供了一种便捷的方法来创建一个新的闭包函数，这个函数将对象和原函数绑定在一起。这样，当调用这个新创建的函数时，它会在正确的对象上下文中执行原有的函数。

&emsp;&emsp;这种语法类似于使用 \ 操作符调用实例方法的方式，区别在于，这里不需要在 \ 操作符后面附加参数列表。

```yuescript
my_object = {
  value: 1000
  write: => print "值为:", @value
}

run_callback = (func) ->
  print "运行回调..."
  func!

-- 这样写不起作用：
-- 函数没有引用my_object
run_callback my_object.write

-- 函数存根语法
-- 让我们把对象捆绑到一个新函数中
run_callback my_object\write
```
<YueDisplay>

```yue
my_object = {
  value: 1000
  write: => print "值为:", @value
}

run_callback = (func) ->
  print "运行回调..."
  func!

-- 这样写不起作用：
-- 函数没有引用my_object
run_callback my_object.write

-- 函数存根语法
-- 让我们把对象捆绑到一个新函数中
run_callback my_object\write
```

</YueDisplay>
