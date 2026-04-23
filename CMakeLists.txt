cmake_minimum_required(VERSION 3.10)
project(yue CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(LUA_LIBDIR ${LUA_INCDIR}/../lib ${LUA_INCDIR}/../../lib)
set(LUA_INCLUDE_DIR "${LUA_INCDIR}")

# Get Lua executable name to detect LuaJIT
get_filename_component(LUA_EXEC_NAME ${LUA} NAME)

# Detect Lua version by executing the binary and checking _VERSION
execute_process(
	COMMAND ${LUA} -e "print(_VERSION)"
	OUTPUT_VARIABLE LUA_VERSION_STRING
	OUTPUT_STRIP_TRAILING_WHITESPACE
	ERROR_QUIET
)

message(STATUS "Lua version string: ${LUA_VERSION_STRING}")
message(STATUS "Lua executable: ${LUA_EXEC_NAME}")

# Parse Lua version from _VERSION output or detect LuaJIT by executable name
if (LUA_EXEC_NAME MATCHES "luajit")
	find_library(LUA_LIBRARIES
		NAMES luajit libluajit
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_VERSION_STRING MATCHES "Lua 5.5")
	find_library(LUA_LIBRARIES
		NAMES lua55 lua5.5 liblua55 liblua5.5 lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_VERSION_STRING MATCHES "Lua 5.4")
	find_library(LUA_LIBRARIES
		NAMES lua54 lua5.4 liblua54 liblua5.4 lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_VERSION_STRING MATCHES "Lua 5.3")
	find_library(LUA_LIBRARIES
		NAMES lua53 lua5.3 liblua53 liblua5.3 lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_VERSION_STRING MATCHES "Lua 5.2")
	find_library(LUA_LIBRARIES
		NAMES lua52 lua5.2 liblua52 liblua5.2 lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_VERSION_STRING MATCHES "Lua 5.1")
	find_library(LUA_LIBRARIES
		NAMES lua51 lua5.1 liblua51 liblua5.1 lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
else ()
	find_library(LUA_LIBRARIES
		NAMES lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
endif()

if (LUA_LIBRARIES MATCHES "LUA_LIBRARIES-NOTFOUND")
	find_package(Lua)
	if (LUA_FOUND)
		set(LUA_LIBRARIES "${LUA_LIBRARY}")
	endif()
else ()
	message(STATUS "Lua: using information from luarocks")
endif()

message(STATUS "Lua: " ${LUA})
message(STATUS "Lua include: " ${LUA_INCLUDE_DIR})
message(STATUS "Lua library: ${LUA_LIBRARIES}")

enable_language(C CXX)
include_directories(src src/3rdParty ${LUA_INCLUDE_DIR})
if (MSVC)
	add_definitions(/O2 /DYUE_UTF8_IMPL /Zc:__cplusplus)
else ()
	add_definitions(-O3 -fPIC -DYUE_UTF8_IMPL)
endif ()

# Detect Android Termux environment
# Termux typically has ANDROID_ROOT environment variable set and PREFIX points to Termux directory
set(IS_TERMUX FALSE)
if (DEFINED ENV{ANDROID_ROOT})
	# Check if PREFIX environment variable points to Termux directory
	if (DEFINED ENV{PREFIX})
		if ("$ENV{PREFIX}" MATCHES "com.termux")
			set(IS_TERMUX TRUE)
			message(STATUS "Detected Android Termux environment (via PREFIX: $ENV{PREFIX})")
		endif()
	endif()
	# Alternative check: verify if Termux installation path exists
	if (NOT IS_TERMUX AND EXISTS "/data/data/com.termux/files/usr")
		set(IS_TERMUX TRUE)
		message(STATUS "Detected Android Termux environment (via filesystem check)")
	endif()
endif()

add_library(libyue MODULE
	src/yuescript/ast.cpp
	src/yuescript/parser.cpp
	src/yuescript/yue_ast.cpp
	src/yuescript/yue_parser.cpp
	src/yuescript/yue_compiler.cpp
	src/yuescript/yuescript.cpp
)
set_target_properties(libyue PROPERTIES PREFIX "")
set_target_properties(libyue PROPERTIES OUTPUT_NAME "yue")
target_link_libraries(libyue ${LUA_LIBRARIES})

# Add YUE_NO_WATCHER macro for Termux environment
if (IS_TERMUX)
	target_compile_definitions(libyue PRIVATE YUE_NO_WATCHER)
endif()

if (MSVC)
	target_compile_definitions(libyue PRIVATE YUE_BUILD_AS_DLL)
endif ()

add_executable(yue
	src/yuescript/ast.cpp
	src/yuescript/parser.cpp
	src/yuescript/yue_ast.cpp
	src/yuescript/yue_parser.cpp
	src/yuescript/yue_compiler.cpp
	src/yuescript/yuescript.cpp
	src/yue.cpp
	src/3rdParty/colib/ljson.c
)

# Add efsw sources only if not in Termux environment
if (NOT IS_TERMUX)
	target_sources(yue PRIVATE
		src/3rdParty/efsw/Debug.cpp
		src/3rdParty/efsw/DirectorySnapshot.cpp
		src/3rdParty/efsw/DirectorySnapshotDiff.cpp
		src/3rdParty/efsw/DirWatcherGeneric.cpp
		src/3rdParty/efsw/FileInfo.cpp
		src/3rdParty/efsw/FileSystem.cpp
		src/3rdParty/efsw/FileWatcher.cpp
		src/3rdParty/efsw/FileWatcherCWrapper.cpp
		src/3rdParty/efsw/FileWatcherGeneric.cpp
		src/3rdParty/efsw/FileWatcherImpl.cpp
		src/3rdParty/efsw/Log.cpp
		src/3rdParty/efsw/Mutex.cpp
		src/3rdParty/efsw/String.cpp
		src/3rdParty/efsw/System.cpp
		src/3rdParty/efsw/Thread.cpp
		src/3rdParty/efsw/Watcher.cpp
		src/3rdParty/efsw/WatcherGeneric.cpp
	)

	if (WIN32)
		target_sources(yue PRIVATE
			src/3rdParty/efsw/platform/win/FileSystemImpl.cpp
			src/3rdParty/efsw/platform/win/MutexImpl.cpp
			src/3rdParty/efsw/platform/win/SystemImpl.cpp
			src/3rdParty/efsw/platform/win/ThreadImpl.cpp
		)
	else ()
		target_sources(yue PRIVATE
			src/3rdParty/efsw/platform/posix/FileSystemImpl.cpp
			src/3rdParty/efsw/platform/posix/MutexImpl.cpp
			src/3rdParty/efsw/platform/posix/SystemImpl.cpp
			src/3rdParty/efsw/platform/posix/ThreadImpl.cpp
		)
	endif()

	if (APPLE)
		target_sources(yue PRIVATE
			src/3rdParty/efsw/FileWatcherFSEvents.cpp
			src/3rdParty/efsw/FileWatcherKqueue.cpp
			src/3rdParty/efsw/WatcherFSEvents.cpp
			src/3rdParty/efsw/WatcherKqueue.cpp
		)

		if (NOT CMAKE_SYSTEM_VERSION GREATER 9)
			target_compile_definitions(yue PRIVATE EFSW_FSEVENTS_NOT_SUPPORTED)
		endif()
	elseif (WIN32)
		target_sources(yue PRIVATE
			src/3rdParty/efsw/FileWatcherWin32.cpp
			src/3rdParty/efsw/WatcherWin32.cpp
		)
	elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
		target_sources(yue PRIVATE
			src/3rdParty/efsw/FileWatcherInotify.cpp
			src/3rdParty/efsw/WatcherInotify.cpp
		)

		if (NOT EXISTS "/usr/include/sys/inotify.h" AND NOT EXISTS "/usr/local/include/sys/inotify.h")
			target_compile_definitions(yue PRIVATE EFSW_INOTIFY_NOSYS)
		endif()
	elseif (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
		target_sources(yue PRIVATE
			src/3rdParty/efsw/FileWatcherKqueue.cpp
			src/3rdParty/efsw/WatcherKqueue.cpp
		)
	endif()
else()
	message(STATUS "Termux environment detected: excluding efsw file watcher sources")
endif()

if (MSVC)
	target_compile_definitions(yue PRIVATE _SCL_SECURE_NO_WARNINGS)
else ()
	target_compile_options(yue PRIVATE -Wall -Wno-long-long -fPIC)
	set_source_files_properties(src/3rdParty/colib/ljson.c PROPERTIES COMPILE_FLAGS "-std=c99")
endif()

# Add YUE_NO_WATCHER macro for Termux environment
if (IS_TERMUX)
	target_compile_definitions(yue PRIVATE YUE_NO_WATCHER)
endif()

if (${CMAKE_BUILD_TYPE} MATCHES "Debug")
	target_compile_definitions(yue PRIVATE DEBUG)
elseif (${CMAKE_BUILD_TYPE} MATCHES "Release")
	target_compile_definitions(yue PRIVATE NDEBUG)
endif()

find_package(Threads REQUIRED)
if (APPLE)
	set(MAC_LIBS "-framework CoreFoundation" "-framework CoreServices")
	target_link_libraries(yue PRIVATE ${LUA_LIBRARIES} ${MAC_LIBS} Threads::Threads)
elseif (NOT (${CMAKE_SYSTEM_NAME} MATCHES "Haiku") AND NOT WIN32)
	target_link_libraries(yue PRIVATE ${LUA_LIBRARIES} Threads::Threads)
else ()
	target_link_libraries(yue PRIVATE ${LUA_LIBRARIES})
endif()

if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
	target_link_options(yue PRIVATE -ldl)
endif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

install(CODE "")
