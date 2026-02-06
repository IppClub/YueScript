# 安装

## Lua 模块

&emsp;安装 [luarocks](https://luarocks.org)，一个 Lua 模块的包管理器。然后作为 Lua 模块和可执行文件安装它：

```shell
luarocks install yuescript
```

&emsp;或者你可以自己构建 `yue.so` 文件：

```shell
make shared LUAI=/usr/local/include/lua LUAL=/usr/local/lib/lua
```

&emsp;然后从路径 **bin/shared/yue.so** 获取二进制文件。

## 构建二进制工具

&emsp;克隆项目仓库，然后构建并安装可执行文件：

```shell
make install
```

&emsp;构建不带宏功能的月之脚本编译工具：

```shell
make install NO_MACRO=true
```

&emsp;构建不带内置Lua二进制文件的月之脚本编译工具：

```shell
make install NO_LUA=true
```

## 下载预编译的二进制程序

&emsp;你可以下载预编译的二进制程序，包括兼容不同 Lua 版本的二进制可执行文件和库文件。

&emsp;在[这里](https://github.com/IppClub/YueScript/releases)下载预编译的二进制程序。
