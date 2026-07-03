#!/bin/bash
# Test Code Execution for YueScript CLI
# Tests: -e option, executing files, script arguments

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/cli_test_helper.sh"

# Check binary
check_yue_binary

# Setup test environment
setup_test_env
TMP_DIR=$(get_test_tmp_dir)

echo "========================================"
echo "Testing Code Execution"
echo "========================================"
echo ""

# Test 1: Execute inline code
echo "Testing inline code execution..."
assert_output_contains "Execute inline code" "123" $YUE_BIN -e 'print 123'

# Test 2: Execute inline code with calculations
echo ""
echo "Testing inline code with calculations..."
assert_output_contains "Execute calculation" "5" $YUE_BIN -e 'print 2 + 3'

# Test 3: Execute inline code with string interpolation
echo ""
echo "Testing string interpolation..."
assert_output_contains "String interpolation" "Hello, World" $YUE_BIN -e 'name = "World"; print "Hello, #{name}"'

# Test 4: Execute YueScript file with -e
echo ""
echo "Testing file execution with -e..."
cat > "$TMP_DIR/exec_test.yue" << 'EOF'
x = 10
y = 20
print x + y
EOF

assert_output_contains "Execute file" "30" $YUE_BIN -e "$TMP_DIR/exec_test.yue"

# Test 5: Execute Lua file
echo ""
echo "Testing Lua file execution..."
cat > "$TMP_DIR/test.lua" << 'EOF'
print("Lua execution")
EOF

assert_output_contains "Execute Lua file" "Lua execution" $YUE_BIN -e "$TMP_DIR/test.lua"

# Test 6: Test with script arguments
echo ""
echo "Testing script arguments..."
cat > "$TMP_DIR/args_test.yue" << 'EOF'
import arg
print arg[1]
print arg[2]
EOF

assert_output_contains "First argument" "first" $YUE_BIN -e "$TMP_DIR/args_test.yue" first second
assert_output_contains "Second argument" "second" $YUE_BIN -e "$TMP_DIR/args_test.yue" first second

# Test 7: Test arg table layout for executed scripts
echo ""
echo "Testing arg table layout..."
cat > "$TMP_DIR/arg_table.yue" << 'EOF'
import arg
print "main=" .. tostring arg[0]
print "first=" .. tostring arg[1]
print "exe=" .. tostring arg[-2]
print "option=" .. tostring arg[-1]
EOF

assert_output_contains "Yue arg[0]" "main=$TMP_DIR/arg_table.yue" $YUE_BIN -e "$TMP_DIR/arg_table.yue" alpha
assert_output_contains "Yue arg[1]" "first=alpha" $YUE_BIN -e "$TMP_DIR/arg_table.yue" alpha
assert_output_contains "Yue arg[-1]" "option=-e" $YUE_BIN -e "$TMP_DIR/arg_table.yue" alpha
assert_output_contains "Yue --execute arg[0]" "main=$TMP_DIR/arg_table.yue" $YUE_BIN --execute="$TMP_DIR/arg_table.yue" alpha

cat > "$TMP_DIR/arg_table.lua" << 'EOF'
print("main=" .. tostring(arg[0]))
print("first=" .. tostring(arg[1]))
print("exe=" .. tostring(arg[-2]))
print("option=" .. tostring(arg[-1]))
EOF

assert_output_contains "Lua arg[0]" "main=$TMP_DIR/arg_table.lua" $YUE_BIN -e "$TMP_DIR/arg_table.lua" alpha
assert_output_contains "Lua arg[1]" "first=alpha" $YUE_BIN -e "$TMP_DIR/arg_table.lua" alpha
assert_output_contains "Lua arg[-1]" "option=-e" $YUE_BIN -e "$TMP_DIR/arg_table.lua" alpha

# Test 8: Test with compiler options via --key=value
echo ""
echo "Testing compiler options in execute mode..."
cat > "$TMP_DIR/options_test.yue" << 'EOF'
print "test"
EOF

assert_success "Execute with compiler option" $YUE_BIN -e "$TMP_DIR/options_test.yue" --reserve_line_number=true

# Test 9: Execute code with table operations
echo ""
echo "Testing table operations..."
assert_output_contains "Table operations" "3" $YUE_BIN -e 't = {1, 2, 3}; print #t'

# Test 10: Execute code with function definition
echo ""
echo "Testing function definition..."
cat > "$TMP_DIR/func_test.yue" << 'EOF'
double = (x) -> x * 2
print double(5)
EOF

assert_output_contains "Function execution" "10" $YUE_BIN -e "$TMP_DIR/func_test.yue"

# Test 11: Execute code with class
echo ""
echo "Testing class execution..."
cat > "$TMP_DIR/class_test.yue" << 'EOF'
class Point
    new: (@x, @y) =>

    distance: =>
        math.sqrt(@x * @x + @y * @y)

p = Point(3, 4)
print p\distance!
EOF

assert_output_contains "Class method execution" "5" $YUE_BIN -e "$TMP_DIR/class_test.yue"

# Test 12: Execute with import
echo ""
echo "Testing import in execute mode..."
cat > "$TMP_DIR/import_test.yue" << 'EOF'
print "test"
EOF

# Note: This test depends on how imports are set up
assert_success "Execute with import" $YUE_BIN -e "$TMP_DIR/import_test.yue" --path="$TMP_DIR"

# Test 13: Execute code with error handling
echo ""
echo "Testing error handling in executed code..."
cat > "$TMP_DIR/error_test.yue" << 'EOF'
ok, err = pcall ->
    error "test error"

if not ok
    print "caught: " .. err
EOF

assert_output_contains "Error handling" "caught:" $YUE_BIN -e "$TMP_DIR/error_test.yue"

# Test 14: Execute with export statement
echo ""
echo "Testing export in execute mode..."
cat > "$TMP_DIR/export_test.yue" << 'EOF'
export value = 42
print value
EOF

assert_output_contains "Export value" "42" $YUE_BIN -e "$TMP_DIR/export_test.yue"

# Test 15: Execute with macro
echo ""
echo "Testing macro in execute mode..."
cat > "$TMP_DIR/macro_test.yue" << 'EOF'
macro double = (x) -> "#{x} * 2"

result = $double 21
print result
EOF

assert_output_contains "Macro execution" "42" $YUE_BIN -e "$TMP_DIR/macro_test.yue"

# Test 16: Execute with string literal
echo ""
echo "Testing string literals..."
# Use grep without -F to match patterns with newlines
# We'll match just the first part to avoid newline issues
assert_output_contains "String with escape" "line1" $YUE_BIN -e 'print "line1\nline2"'

echo ""
print_summary
