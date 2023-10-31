#### PROJECT SETTINGS ####
# The name of the executable to be created
BIN_NAME := yue
# Compiler used
CXX ?= g++
# Extension of source files used in the project
SRC_EXT = cpp
# Path to the source directory, relative to the makefile
SRC_PATH = ./src
# Space-separated pkg-config libraries used by this project
LIBS =
# General compiler flags
COMPILE_FLAGS = -std=c++17 -Wall -Wextra -Wno-deprecated-declarations
# Additional release-specific flags
RCOMPILE_FLAGS = -D NDEBUG -O3
# Additional debug-specific flags
DCOMPILE_FLAGS = -D DEBUG
# Add additional include paths
INCLUDES = -I $(SRC_PATH) -I $(SRC_PATH)/3rdParty
# General linker settings
LINK_FLAGS = -lpthread
# Additional release-specific linker settings
RLINK_FLAGS =
# Additional debug-specific linker settings
DLINK_FLAGS =
# Destination directory, like a jail or mounted system
DESTDIR = /
# Install path (bin/ is appended automatically)
INSTALL_PREFIX = usr/local
# Test
TEST_INPUT = ./spec/inputs
TEST_OUTPUT = ./spec/generated
GEN_OUTPUT = ./spec/outputs

PLAT = macos

#### END PROJECT SETTINGS ####

# Optionally you may move the section above to a separate config.mk file, and
# uncomment the line below
# include config.mk

# Generally should not need to edit below this line

# Obtains the OS type, either 'Darwin' (OS X) or 'Linux'
UNAME_S:=$(shell uname -s)

ifeq ($(NO_LUA),true)
	COMPILE_FLAGS += -DYUE_NO_MACRO -DYUE_COMPILER_ONLY
else
ifeq ($(NO_MACRO),true)
	COMPILE_FLAGS += -DYUE_NO_MACRO
endif
	INCLUDES += -I $(SRC_PATH)/3rdParty/lua
	LINK_FLAGS += -L $(SRC_PATH)/3rdParty/lua -llua -ldl
endif
ifeq ($(NO_WATCHER),true)
	COMPILE_FLAGS += -DYUE_NO_WATCHER
endif

# Add platform related linker flag
ifneq ($(UNAME_S),Darwin)
	LINK_FLAGS += -lstdc++fs -Wl,-E
	PLAT = linux
else
	LINK_FLAGS += -framework CoreFoundation -framework CoreServices
endif

# Function used to check variables. Use on the command line:
# make print-VARNAME
# Useful for debugging and adding features
print-%: ; @echo $*=$($*)

# Shell used in this makefile
# bash is used for 'echo -en'
SHELL = /bin/bash
# Clear built-in rules
.SUFFIXES:
# Programs for installation
INSTALL = install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

# Append pkg-config specific libraries if need be
ifneq ($(LIBS),)
	COMPILE_FLAGS += $(shell pkg-config --cflags $(LIBS))
	LINK_FLAGS += $(shell pkg-config --libs $(LIBS))
endif

# Verbose option, to output compile and link commands
export V := false
export CMD_PREFIX := @
ifeq ($(V),true)
	CMD_PREFIX :=
endif

# Combine compiler and linker flags
release: export CXXFLAGS := $(CXXFLAGS) $(COMPILE_FLAGS) $(RCOMPILE_FLAGS)
release: export LDFLAGS := $(LDFLAGS) $(LINK_FLAGS) $(RLINK_FLAGS)
debug: export CXXFLAGS := $(CXXFLAGS) $(COMPILE_FLAGS) $(DCOMPILE_FLAGS)
debug: export LDFLAGS := $(LDFLAGS) $(LINK_FLAGS) $(DLINK_FLAGS)
shared: export CXXFLAGS := $(CXXFLAGS) $(COMPILE_FLAGS) $(RCOMPILE_FLAGS) $(TARGET_FLAGS)

# Build and output paths
release: export BUILD_PATH := build/release
release: export BIN_PATH := bin/release
debug: export BUILD_PATH := build/debug
debug: export BIN_PATH := bin/debug
shared: export BUILD_PATH := build/shared
shared: export BIN_PATH := bin/shared
install: export BIN_PATH := bin/release
wasm: export BIN_PATH := bin/release

# Find all source files in the source directory, sorted by most
# recently modified
ifeq ($(UNAME_S),Darwin)
	SOURCES = $(shell find $(SRC_PATH) -name '*.$(SRC_EXT)' | sort -k 1nr | cut -f2-)
else
	SOURCES = $(shell find $(SRC_PATH) -name '*.$(SRC_EXT)' -printf '%T@\t%p\n' \
						| sort -k 1nr | cut -f2-)
endif

# fallback in case the above fails
rwildcard = $(foreach d, $(wildcard $1*), $(call rwildcard,$d/,$2) \
						$(filter $(subst *,%,$2), $d))
ifeq ($(SOURCES),)
	SOURCES := $(call rwildcard, $(SRC_PATH), *.$(SRC_EXT))
endif

SOURCES := $(filter-out $(SRC_PATH)/yue_wasm.cpp, $(SOURCES))
SOURCES := $(filter-out $(SRC_PATH)/3rdParty/%, $(SOURCES))

ifeq ($(NO_LUA),true)
	SOURCES := $(filter-out $(SRC_PATH)/yuescript/yuescript.cpp, $(SOURCES))
endif

# Set the object file names, with the source directory stripped
# from the path, and the build path prepended in its place
OBJECTS = $(SOURCES:$(SRC_PATH)/%.$(SRC_EXT)=$(BUILD_PATH)/%.o)
# Set the dependency files that will be used to add header dependencies
DEPS = $(OBJECTS:.o=.d)

ifneq ($(NO_WATCHER),true)
	SOURCES += $(SRC_PATH)/3rdParty/efsw/Debug.cpp $(SRC_PATH)/3rdParty/efsw/DirectorySnapshot.cpp $(SRC_PATH)/3rdParty/efsw/DirectorySnapshotDiff.cpp $(SRC_PATH)/3rdParty/efsw/DirWatcherGeneric.cpp $(SRC_PATH)/3rdParty/efsw/FileInfo.cpp $(SRC_PATH)/3rdParty/efsw/FileSystem.cpp $(SRC_PATH)/3rdParty/efsw/FileWatcher.cpp $(SRC_PATH)/3rdParty/efsw/FileWatcherCWrapper.cpp $(SRC_PATH)/3rdParty/efsw/FileWatcherGeneric.cpp $(SRC_PATH)/3rdParty/efsw/FileWatcherImpl.cpp $(SRC_PATH)/3rdParty/efsw/Log.cpp $(SRC_PATH)/3rdParty/efsw/Mutex.cpp $(SRC_PATH)/3rdParty/efsw/String.cpp $(SRC_PATH)/3rdParty/efsw/System.cpp $(SRC_PATH)/3rdParty/efsw/Thread.cpp $(SRC_PATH)/3rdParty/efsw/Watcher.cpp $(SRC_PATH)/3rdParty/efsw/WatcherGeneric.cpp $(SRC_PATH)/3rdParty/efsw/platform/posix/FileSystemImpl.cpp $(SRC_PATH)/3rdParty/efsw/platform/posix/MutexImpl.cpp $(SRC_PATH)/3rdParty/efsw/platform/posix/SystemImpl.cpp $(SRC_PATH)/3rdParty/efsw/platform/posix/ThreadImpl.cpp
endif

# Macros for timing compilation
ifeq ($(UNAME_S),Darwin)
	CUR_TIME = awk 'BEGIN{srand(); print srand()}'
	TIME_FILE = $(dir $@).$(notdir $@)_time
	START_TIME = $(CUR_TIME) > $(TIME_FILE)
	END_TIME = read st < $(TIME_FILE) ; \
		$(RM) $(TIME_FILE) ; \
		st=$$((`$(CUR_TIME)` - $$st)) ; \
		echo $$st
	ifneq ($(NO_WATCHER),true)
		SOURCES += $(SRC_PATH)/3rdParty/efsw/FileWatcherFSEvents.cpp $(SRC_PATH)/3rdParty/efsw/FileWatcherKqueue.cpp $(SRC_PATH)/3rdParty/efsw/WatcherFSEvents.cpp $(SRC_PATH)/3rdParty/efsw/WatcherKqueue.cpp
	endif
else
	TIME_FILE = $(dir $@).$(notdir $@)_time
	START_TIME = date '+%s' > $(TIME_FILE)
	END_TIME = read st < $(TIME_FILE) ; \
		$(RM) $(TIME_FILE) ; \
		st=$$((`date '+%s'` - $$st - 86400)) ; \
		echo `date -u -d @$$st '+%H:%M:%S'`
	ifneq ($(NO_WATCHER),true)
		SOURCES += $(SRC_PATH)/3rdParty/efsw/FileWatcherFSEvents.cpp $(SRC_PATH)/3rdParty/efsw/FileWatcherKqueue.cpp $(SRC_PATH)/3rdParty/efsw/WatcherFSEvents.cpp $(SRC_PATH)/3rdParty/efsw/WatcherKqueue.cpp $(SRC_PATH)/3rdParty/efsw/FileWatcherInotify.cpp $(SRC_PATH)/3rdParty/efsw/WatcherInotify.cpp
	endif
endif

# Version macros
# Comment/remove this section to remove versioning
USE_VERSION := false
# If this isn't a git repo or the repo has no tags, git describe will return non-zero
ifeq ($(shell git describe > /dev/null 2>&1 ; echo $$?), 0)
	USE_VERSION := true
	VERSION := $(shell git describe --tags --long --dirty --always | \
		sed 's/v\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)-\?.*-\([0-9]*\)-\(.*\)/\1 \2 \3 \4 \5/g')
	VERSION_MAJOR := $(word 1, $(VERSION))
	VERSION_MINOR := $(word 2, $(VERSION))
	VERSION_PATCH := $(word 3, $(VERSION))
	VERSION_REVISION := $(word 4, $(VERSION))
	VERSION_HASH := $(word 5, $(VERSION))
	VERSION_STRING := \
		"$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH).$(VERSION_REVISION)-$(VERSION_HASH)"
	override CXXFLAGS := $(CXXFLAGS) \
		-D VERSION_MAJOR=$(VERSION_MAJOR) \
		-D VERSION_MINOR=$(VERSION_MINOR) \
		-D VERSION_PATCH=$(VERSION_PATCH) \
		-D VERSION_REVISION=$(VERSION_REVISION) \
		-D VERSION_HASH=\"$(VERSION_HASH)\"
endif

# Standard, non-optimized release build
.PHONY: release
release: dirs
ifeq ($(USE_VERSION), true)
	@echo "Beginning release build $(VERSION_STRING)"
else
	@echo "Beginning release build"
endif
ifneq ($(NO_LUA),true)
	@$(MAKE) $(PLAT) -C $(SRC_PATH)/3rdParty/lua
endif
	@$(START_TIME)
	@$(MAKE) all --no-print-directory
	@echo -n "Total build time: "
	@$(END_TIME)

.PHONY: wasm
wasm: clean
	@$(MAKE) generic CC='emcc' AR='emar rcu' RANLIB='emranlib' -C $(SRC_PATH)/3rdParty/lua
	@mkdir -p doc/docs/.vuepress/public/js
	@emcc $(SRC_PATH)/yue_wasm.cpp $(SRC_PATH)/yuescript/ast.cpp $(SRC_PATH)/yuescript/yue_ast.cpp $(SRC_PATH)/yuescript/parser.cpp $(SRC_PATH)/yuescript/yue_compiler.cpp $(SRC_PATH)/yuescript/yue_parser.cpp $(SRC_PATH)/yuescript/yuescript.cpp $(SRC_PATH)/3rdParty/lua/liblua.a -O2 -o doc/docs/.vuepress/public/js/yuescript.js -I $(SRC_PATH) -I $(SRC_PATH)/3rdParty/lua -std=c++17 --bind -fexceptions -Wno-deprecated-declarations
	@${MAKE} clean

# Debug build for gdb debugging
.PHONY: debug
debug: dirs
ifeq ($(USE_VERSION), true)
	@echo "Beginning debug build $(VERSION_STRING)"
else
	@echo "Beginning debug build"
endif
ifneq ($(NO_LUA),true)
	@$(MAKE) $(PLAT) -C $(SRC_PATH)/3rdParty/lua
endif
	@$(START_TIME)
	@$(MAKE) all --no-print-directory
	@echo -n "Total build time: "
	@$(END_TIME)

$(BUILD_PATH)/yue.so: $(SRC_PATH)/yuescript/ast.cpp $(SRC_PATH)/yuescript/yue_ast.cpp $(SRC_PATH)/yuescript/yue_compiler.cpp $(SRC_PATH)/yuescript/yue_parser.cpp $(SRC_PATH)/yuescript/yuescript.cpp $(SRC_PATH)/yuescript/parser.cpp
	$(CMD_PREFIX)$(CXX) $(CXXFLAGS) -I $(SRC_PATH) -I $(SRC_PATH)/3rdParty -I $(LUAI) -L $(LUAL) -llua -o $@ -fPIC -shared $?

# Standard, non-optimized release build
.PHONY: shared
shared: dirs
ifeq ($(USE_VERSION), true)
	@echo "Beginning release build $(VERSION_STRING)"
else
	@echo "Beginning release build"
endif
	@$(START_TIME)
	@$(MAKE) $(BUILD_PATH)/yue.so --no-print-directory
	@echo -n "Total build time: "
	@$(END_TIME)
	@mv $(BUILD_PATH)/yue.so $(BIN_PATH)/yue.so

# Create the directories used in the build
.PHONY: dirs
dirs:
	@echo "Creating directories"
	@mkdir -p $(dir $(OBJECTS))
	@mkdir -p $(BIN_PATH)

# Installs to the set path
.PHONY: install
install: release
	@echo "Installing to $(DESTDIR)$(INSTALL_PREFIX)/bin"
	@$(INSTALL_PROGRAM) $(BIN_PATH)/$(BIN_NAME) $(DESTDIR)$(INSTALL_PREFIX)/bin

# Uninstalls the program
.PHONY: uninstall
uninstall:
	@echo "Removing $(DESTDIR)$(INSTALL_PREFIX)/bin/$(BIN_NAME)"
	@$(RM) $(DESTDIR)$(INSTALL_PREFIX)/bin/$(BIN_NAME)

# Removes all build files
.PHONY: clean
clean:
	@$(MAKE) clean -C $(SRC_PATH)/3rdParty/lua
	@echo "Deleting $(BIN_NAME) symlink"
	@$(RM) $(BIN_NAME)
	@echo "Deleting directories"
	@$(RM) -r build
	@$(RM) -r bin
	@$(RM) -r $(TEST_OUTPUT)

# Test Yuescript compiler
.PHONY: test
test: debug
	@mkdir -p $(TEST_OUTPUT)/5.1/test
	@echo "Compiling Yuescript codes..."
	@$(START_TIME)
	@./$(BIN_NAME) $(TEST_INPUT) -t $(TEST_OUTPUT) --tl_enabled
	@./$(BIN_NAME) $(TEST_INPUT)/teal_lang.yue -o $(TEST_OUTPUT)/teal_lang.lua
	@./$(BIN_NAME) $(TEST_INPUT)/loops.yue -o $(TEST_OUTPUT)/5.1/loops.lua --target=5.1
	@./$(BIN_NAME) $(TEST_INPUT)/try_catch.yue -o $(TEST_OUTPUT)/5.1/try_catch.lua --target=5.1
	@./$(BIN_NAME) $(TEST_INPUT)/attrib.yue -o $(TEST_OUTPUT)/5.1/attrib.lua --target=5.1
	@./$(BIN_NAME) $(TEST_INPUT)/test/loops_spec.yue -o $(TEST_OUTPUT)/5.1/test/loops_spec.lua --target=5.1
	@echo -en "Compile time: "
	@$(END_TIME)
	@./$(BIN_NAME) -e "$$(printf "r = io.popen('git diff --no-index $(TEST_OUTPUT) $(GEN_OUTPUT) | head -5')\\\\read '*a'\nif r ~= ''\n print r\n os.exit 1")"
	@$(RM) -r $(TEST_OUTPUT)
	@busted
	@echo "Done!"

# Test Yuescript compiler
.PHONY: gen
gen: release
	@echo "Compiling Yuescript codes..."
	@$(START_TIME)
	@./$(BIN_NAME) $(TEST_INPUT) -t $(GEN_OUTPUT) --tl_enabled
	@./$(BIN_NAME) $(TEST_INPUT)/teal_lang.yue -o $(GEN_OUTPUT)/teal_lang.lua
	@./$(BIN_NAME) $(TEST_INPUT)/loops.yue -o $(GEN_OUTPUT)/5.1/loops.lua --target=5.1
	@./$(BIN_NAME) $(TEST_INPUT)/try_catch.yue -o $(GEN_OUTPUT)/5.1/try_catch.lua --target=5.1
	@./$(BIN_NAME) $(TEST_INPUT)/attrib.yue -o $(GEN_OUTPUT)/5.1/attrib.lua --target=5.1
	@./$(BIN_NAME) $(TEST_INPUT)/test/loops_spec.yue -o $(GEN_OUTPUT)/5.1/test/loops_spec.lua --target=5.1
	@echo -en "Compile time: "
	@$(END_TIME)

# Main rule, checks the executable and symlinks to the output
all: $(BIN_PATH)/$(BIN_NAME)
	@echo "Making symlink: $(BIN_NAME) -> $<"
	@$(RM) $(BIN_NAME)
	@ln -s $(BIN_PATH)/$(BIN_NAME) $(BIN_NAME)

# Link the executable
$(BIN_PATH)/$(BIN_NAME): $(OBJECTS)
	@echo "Linking: $@"
	@$(START_TIME)
	$(CMD_PREFIX)$(CXX) $(OBJECTS) $(LDFLAGS) -o $@
	@echo -en "\t Link time: "
	@$(END_TIME)

# Add dependency files, if they exist
-include $(DEPS)

# Source file rules
# After the first compilation they will be joined with the rules from the
# dependency files to provide header dependencies
$(BUILD_PATH)/%.o: $(SRC_PATH)/%.$(SRC_EXT)
	@echo "Compiling: $< -> $@"
	@$(START_TIME)
	$(CMD_PREFIX)$(CXX) $(CXXFLAGS) $(INCLUDES) -MP -MMD -c $< -o $@
	@echo -en "\t Compile time: "
	@$(END_TIME)
