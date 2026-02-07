# 错误处理

&emsp;&emsp;用于统一进行 Lua 错误处理的便捷语法。

```yuescript
try
  func 1, 2, 3
catch err
  print yue.traceback err

success, result = try
  func 1, 2, 3
catch err
  yue.traceback err

try func 1, 2, 3
catch err
  print yue.traceback err

success, result = try func 1, 2, 3

try
  print "尝试中"
  func 1, 2, 3

-- 使用if赋值模式
if success, result := try func 1, 2, 3
catch err
    print yue.traceback err
  print result
```

<YueDisplay>

```yue
try
  func 1, 2, 3
catch err
  print yue.traceback err

success, result = try
  func 1, 2, 3
catch err
  yue.traceback err

try func 1, 2, 3
catch err
  print yue.traceback err

success, result = try func 1, 2, 3

try
  print "尝试中"
  func 1, 2, 3

-- 使用if赋值模式
if success, result := try func 1, 2, 3
catch err
    print yue.traceback err
  print result
```

</YueDisplay>

## 错误处理简化

&emsp;&emsp;`try?` 是 `try` 的功能简化语法，它不再返回 `try` 语句的布尔状态，并在成功时直接返回 `try` 代码块的结果，失败时返回 `nil` 值而非错误对象。

```yuescript
a, b, c = try? func!

-- 与空值合并运算符一起使用
a = (try? func!) ?? "default"

-- 作为函数参数
f try? func!

-- 带 catch 块的 try!
f try?
  print 123
  func!
catch e
  print e
  e
```

<YueDisplay>

```yue
a, b, c = try? func!

-- 与空值合并运算符一起使用
a = (try? func!) ?? "default"

-- 作为函数参数
f try? func!

-- 带 catch 块的 try!
f try?
  print 123
  func!
catch e
  print e
  e
```

</YueDisplay>
