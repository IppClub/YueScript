cmake_minimum_required(VERSION 3.13)
project(yue LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(LUA_LIBDIR ${LUA_INCDIR}/../lib ${LUA_INCDIR}/../../lib)
set(LUA_INCLUDE_DIR "${LUA_INCDIR}")

get_filename_component(LUA_EXEC_NAME ${LUA} NAME)
if (LUA_EXEC_NAME STREQUAL "luajit")
	find_library(LUA_LIBRARIES
		NAMES luajit libluajit
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_EXEC_NAME MATCHES "lua5\.4" OR LUA_EXEC_NAME MATCHES "lua54")
	find_library(LUA_LIBRARIES
		NAMES lua54 lua5.4 liblua54 liblua5.4 lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_EXEC_NAME MATCHES "lua5\.3" OR LUA_EXEC_NAME MATCHES "lua53")
	find_library(LUA_LIBRARIES
		NAMES lua53 lua5.3 liblua53 liblua5.3 lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_EXEC_NAME MATCHES "lua5\.2" OR LUA_EXEC_NAME MATCHES "lua52")
	find_library(LUA_LIBRARIES
		NAMES lua52 lua5.2 liblua52 liblua5.2 lua liblua
		PATHS ${LUA_LIBDIR}
		NO_DEFAULT_PATH)
elseif (LUA_EXEC_NAME MATCHES "lua5\.1" OR LUA_EXEC_NAME MATCHES "lua51")
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

set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)

include_directories(src src/3rdParty ${LUA_INCLUDE_DIR})

if (APPLE)
	add_compile_options(-Wno-deprecated-declarations)
endif ()

add_library(yue-common STATIC
	src/yuescript/ast.cpp
	src/yuescript/parser.cpp
	src/yuescript/yue_ast.cpp
	src/yuescript/yue_parser.cpp
	src/yuescript/yue_compiler.cpp
)

target_link_libraries(yue-common PUBLIC ${LUA_LIBRARIES})

add_library(libyue MODULE 
	src/yuescript/yuescript.cpp
)
set_target_properties(libyue PROPERTIES PREFIX "")
set_target_properties(libyue PROPERTIES OUTPUT_NAME "yue")
target_link_libraries(libyue PRIVATE yue-common)

add_subdirectory(src/3rdParty/efsw)

add_executable(yue
	src/yuescript/yuescript.cpp
	src/yue.cpp
)

target_link_libraries(yue PRIVATE efsw-static yue-common)

if (${CMAKE_BUILD_TYPE} MATCHES "Debug")
	target_compile_definitions(yue PRIVATE DEBUG)
elseif (${CMAKE_BUILD_TYPE} MATCHES "Release")
	target_compile_definitions(yue PRIVATE NDEBUG)
endif()
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
	target_link_options(yue PRIVATE -lstdc++fs -ldl)
endif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

install(CODE "")
