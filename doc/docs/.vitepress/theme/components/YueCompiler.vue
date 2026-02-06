<template>
  <div style="width: 100%; height: auto;">
    <div class="parent">
      <div class="editor-section">
        <div class="childTitle">YueScript {{ info }}</div>
        <div class="editor-container">
          <div ref="codeEditor" class="code-editor"></div>
        </div>
      </div>
      <div class="editor-section">
        <div class="childTitle">Lua</div>
        <div class="editor-container">
          <pre class="code-output language-lua"><code v-html="highlightedLua"></code></pre>
        </div>
      </div>
    </div>
    <div v-if="!compileronly">
      <button class="button" @click="runCode()">Run!</button>
      <textarea class="resultArea" readonly>{{ result }}</textarea>
    </div>
  </div>
</template>

<script>
import pkg from 'prismjs/components/prism-core.js'
const { highlight, languages } = pkg
import 'prismjs/components/prism-moonscript'
import 'prismjs/components/prism-lua'
import { EditorState, Compartment } from '@codemirror/state'
import { EditorView, keymap, lineNumbers } from '@codemirror/view'
import {
  indentUnit,
  StreamLanguage,
  syntaxHighlighting,
  HighlightStyle
} from '@codemirror/language'
import { tags } from '@lezer/highlight'
import { history, indentWithTab } from '@codemirror/commands'
import { defaultKeymap, historyKeymap } from '@codemirror/commands'
import { simpleMode } from '@codemirror/legacy-modes/mode/simple-mode'

/* shikijs/themes/light-plus: editor.background #FFFFFF, editor.foreground #000000 */
const lightPlusTheme = EditorView.theme(
  {
    '&': {
      height: '100%',
      backgroundColor: '#FFFFFF',
      color: '#000000',
      fontSize: '14px'
    },
    '&.cm-focused': {
      outline: 'none'
    },
    '.cm-content': {
      fontFamily:
        "ui-monospace, 'Menlo', 'Monaco', 'Consolas', 'Liberation Mono', 'Courier New', monospace",
      lineHeight: '1.375'
    },
    '.cm-gutters': {
      backgroundColor: '#FFFFFF',
      color: '#6e6e6e',
      borderRight: 'none'
    },
    '.cm-activeLine': {
      backgroundColor: 'transparent'
    },
    '.cm-activeLineGutter': {
      backgroundColor: 'transparent'
    },
    '.cm-selectionBackground': {
      backgroundColor: '#add6ff'
    },
    '&.cm-focused .cm-selectionBackground': {
      backgroundColor: '#add6ff'
    },
    '.cm-cursor': {
      borderLeftColor: '#000000'
    },
    '.cm-matchingBracket': {
      backgroundColor: '#c9def5'
    }
  },
  { dark: false }
)

/* shikijs/themes/dark-plus: editor.background #1E1E1E, editor.foreground #D4D4D4 */
const darkPlusTheme = EditorView.theme(
  {
    '&': {
      height: '100%',
      backgroundColor: '#1E1E1E',
      color: '#D4D4D4',
      fontSize: '14px'
    },
    '&.cm-focused': {
      outline: 'none'
    },
    '.cm-content': {
      fontFamily:
        "ui-monospace, 'Menlo', 'Monaco', 'Consolas', 'Liberation Mono', 'Courier New', monospace",
      lineHeight: '1.375'
    },
    '.cm-gutters': {
      backgroundColor: '#1E1E1E',
      color: '#858585',
      borderRight: 'none'
    },
    '.cm-activeLine': {
      backgroundColor: 'transparent'
    },
    '.cm-activeLineGutter': {
      backgroundColor: 'transparent'
    },
    '.cm-selectionBackground': {
      backgroundColor: '#264f78'
    },
    '&.cm-focused .cm-selectionBackground': {
      backgroundColor: '#264f78'
    },
    '.cm-cursor': {
      borderLeftColor: '#aeafad'
    },
    '.cm-matchingBracket': {
      backgroundColor: '#3a3d41'
    }
  },
  { dark: true }
)

/* shikijs/themes/light-plus tokenColors */
const lightPlusHighlightStyle = HighlightStyle.define([
  { tag: tags.comment, color: '#008000' },
  { tag: tags.keyword, color: '#AF00DB' },
  { tag: [tags.operator, tags.punctuation], color: '#000000' },
  { tag: [tags.string, tags.special(tags.string)], color: '#a31515' },
  { tag: tags.regexp, color: '#811f3f' },
  { tag: [tags.number, tags.bool, tags.null], color: '#098658' },
  { tag: tags.function(tags.variableName), color: '#795e26' },
  { tag: tags.typeName, color: '#267f99' },
  { tag: tags.className, color: '#267f99' },
  { tag: tags.propertyName, color: '#001080' },
  { tag: tags.tagName, color: '#800000' },
  { tag: tags.attributeName, color: '#e50000' },
  { tag: tags.meta, color: '#666666' },
  { tag: tags.invalid, color: '#cd3131' },
  // Additional tags for YueScript - ensure all token types have styles
  { tag: tags.variableName, color: '#001080' },
  { tag: tags.constant(tags.name), color: '#098658' },
  { tag: tags.constant(tags.variableName), color: '#098658' },
  { tag: tags.constant, color: '#098658' },
  { tag: tags.definition(tags.variableName), color: '#001080' },
  { tag: tags.modifier, color: '#AF00DB' },
  { tag: tags.namespace, color: '#267f99' },
  { tag: tags.labelName, color: '#795e26' },
  { tag: tags.character, color: '#098658' },
  { tag: tags.literal, color: '#098658' },
  { tag: tags.bracket, color: '#000000' },
  { tag: tags.squareBracket, color: '#000000' },
  { tag: tags.paren, color: '#000000' },
  { tag: tags.brace, color: '#000000' }
], { fallback: true })

/* shikijs/themes/dark-plus tokenColors */
const darkPlusHighlightStyle = HighlightStyle.define([
  { tag: tags.comment, color: '#6a9955' },
  { tag: tags.keyword, color: '#C586C0' },
  { tag: [tags.operator, tags.punctuation], color: '#d4d4d4' },
  { tag: [tags.string, tags.special(tags.string)], color: '#ce9178' },
  { tag: tags.regexp, color: '#d16969' },
  { tag: [tags.number, tags.bool, tags.null], color: '#b5cea8' },
  { tag: tags.function(tags.variableName), color: '#dcdcaa' },
  { tag: tags.typeName, color: '#4ec9b0' },
  { tag: tags.className, color: '#4ec9b0' },
  { tag: tags.propertyName, color: '#9cdcfe' },
  { tag: tags.tagName, color: '#569cd6' },
  { tag: tags.attributeName, color: '#9cdcfe' },
  { tag: tags.meta, color: '#d4d4d4' },
  { tag: tags.invalid, color: '#f44747' },
  // Additional tags for YueScript - ensure all token types have styles
  { tag: tags.variableName, color: '#9cdcfe' },
  { tag: tags.constant(tags.name), color: '#b5cea8' },
  { tag: tags.constant(tags.variableName), color: '#b5cea8' },
  { tag: tags.constant, color: '#b5cea8' },
  { tag: tags.definition(tags.variableName), color: '#9cdcfe' },
  { tag: tags.modifier, color: '#C586C0' },
  { tag: tags.namespace, color: '#4ec9b0' },
  { tag: tags.labelName, color: '#dcdcaa' },
  { tag: tags.character, color: '#b5cea8' },
  { tag: tags.literal, color: '#b5cea8' },
  { tag: tags.bracket, color: '#d4d4d4' },
  { tag: tags.squareBracket, color: '#d4d4d4' },
  { tag: tags.paren, color: '#d4d4d4' },
  { tag: tags.brace, color: '#d4d4d4' }
], { fallback: true })

export default {
  props: {
    compileronly: {
      type: Boolean,
      default: false
    },
    displayonly: {
      type: Boolean,
      default: false
    },
    text: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      info: 'Loading',
      readonly: true,
      code: '',
      compiled: '',
      result: '',
      windowWidth: 0,
      editorView: null,
      readOnlyCompartment: null,
      themeCompartment: null,
      highlightCompartment: null,
      themeObserver: null
    }
  },
  computed: {
    isMobileLayout() {
      return this.windowWidth <= 768
    },
    highlightedLua() {
      return highlight(this.compiled || '', languages.lua)
    }
  },
  mounted() {
    this.windowWidth = window.innerWidth
    window.addEventListener('resize', this.handleResize)
    this.observeTheme()

    const initialCode = this.text !== '' ? this.text : ''
    this.code = initialCode
    this.codeChanged(initialCode)
    this.initEditor(initialCode)
    this.$nextTick(() => {
      this.focusEditorToEnd()
    })

    const check = ((self) => {
      return () => {
        if (window.yue) {
          self.info = window.yue.version()
          self.readonly = false
          this.refreshEditorReadOnly()
        } else {
          setTimeout(check, 100)
        }
      }
    })(this)
    check()
  },
  beforeUnmount() {
    window.removeEventListener('resize', this.handleResize)
    if (this.editorView) {
      this.editorView.destroy()
      this.editorView = null
    }
    if (this.themeObserver) {
      this.themeObserver.disconnect()
      this.themeObserver = null
    }
  },
  methods: {
    focusEditorToEnd() {
      if (!this.editorView) {
        return
      }
      const docLength = this.editorView.state.doc.length
      this.editorView.dispatch({
        selection: { anchor: docLength },
        scrollIntoView: true
      })
      this.editorView.focus()
    },
    handleResize() {
      this.windowWidth = window.innerWidth
    },
    isDarkTheme() {
      return document.documentElement.classList.contains('dark')
    },
    observeTheme() {
      if (this.themeObserver) {
        return
      }
      this.themeObserver = new MutationObserver(() => {
        this.refreshEditorTheme()
      })
      this.themeObserver.observe(document.documentElement, {
        attributes: true,
        attributeFilter: ['class']
      })
    },
    initEditor(initialCode) {
      if (!this.$refs.codeEditor) {
        return
      }

      const yuescriptMode = simpleMode({
        start: [
          // Shebang
          { regex: /^#!.*/, token: 'comment' },
          // Multiline string: [=[...]=] with any number of =
          { regex: /\[(=*)\[/, token: 'string', push: 'luaString' },
          // Block comment: --[[...]] (but not ---)
          { regex: /--\[\[/, token: 'comment', push: 'commentBlock' },
          // Line comment: -- (but not ---)
          { regex: /--(?!-).*/, token: 'comment' },
          // Double quoted string with interpolation #{...}
          { regex: /"/, token: 'string', push: 'doubleString' },
          // Single quoted string
          { regex: /'/, token: 'string', push: 'singleString' },
          // Tag: ::name::
          { regex: /(::)\s*[a-zA-Z_][a-zA-Z0-9_]*\s*(::)/, token: 'tagName' },
          // Class definition: class Name extends Base
          { regex: /\bclass\b\s+(@?[a-zA-Z$_][\w.]*)?(?:\s+\bextends\b\s+(@?[a-zA-Z$._][\w.]*))?/, token: 'keyword' },
          // Function definition: name: => or name := => or name(params): =>
          { regex: /(@?[a-zA-Z$_]\??[\w$:.]*\s*[:=]\s*(?:\([^)]*\))?\s*[=-]>)/, token: 'function' },
          // Destructured assignment: { ... } := or { ... } =
          { regex: /\{\s*[^}]*\}\s*[:=]/, token: 'keyword' },
          // Keywords (must come before operators to catch 'and', 'or', 'in', 'not')
          { regex: /\b(?:import|as|from|export|macro|local|global|close|const|class|extends|using)\b(?![:\w])/, token: 'keyword' },
          // Control keywords
          { regex: /\b(?:if|then|else|elseif|until|unless|switch|when|with|do|for|while|repeat|return|continue|break|try|catch|goto)\b(?![:\w])/, token: 'keyword' },
          { regex: /\b(?:or|and|in|not)\b(?![:\w])/, token: 'keyword' },
          // Boolean and nil
          { regex: /\b(?:true|false|nil)\b(?![:\w])/, token: 'number' },
          // Invalid: function/end
          { regex: /\b(?:function|end)\b(?![:\w])/, token: 'invalid' },
          // Invalid: self (deprecated)
          { regex: /\bself\b(?![:\w])/, token: 'invalid' },
          // super keyword
          { regex: /\bsuper\b(?![:\w])/, token: 'variable' },
          // Invalid variables: $$, $@, @@@, standalone $
          { regex: /\$\$+/, token: 'invalid' },
          { regex: /@@@+/, token: 'invalid' },
          { regex: /\$(?!\w)/, token: 'invalid' },
          // Special operators: <mode>, <>, <"string">, <'string'>, <word> (invalid)
          { regex: /<\b(?:mode|name|add|sub|mul|div|mod|pow|unm|idiv|band|bor|bxor|bnot|shl|shr|concat|len|eq|lt|le|index|newindex|call|metatable|gc|close|tostring|pairs|ipairs)\b>/, token: 'constant' },
          { regex: /<>/, token: 'constant' },
          { regex: /<"[^"]*">/, token: 'constant' },
          { regex: /<'[^']*'>/, token: 'constant' },
          { regex: /<\w+>/, token: 'invalid' },
          // Operators (and/or removed since they're keywords, ?? must not match ???)
          { regex: /(\+|\-|\*|\/|%|\^|\/\/|\||\&|>>|<<|\.\.)=?/, token: 'operator' },
          { regex: /\?\?(?!\?)/, token: 'operator' },
          { regex: /\[\]\s*=/, token: 'operator' },
          { regex: /==|~=|!=|>|>=|<|<=/, token: 'operator' },
          { regex: /#|~|\?|!/, token: 'operator' },
          { regex: /\|>|=|:=|:(?!:)|,|\b_\b/, token: 'operator' },
          { regex: /\.\.\.(?!\.)/, token: 'constant' },
          // Invalid: 4+ dots
          { regex: /\.{4,}/, token: 'invalid' },
          // Class name (capitalized) - must come after keywords
          { regex: /\b[A-Z]\w*\b/, token: 'typeName' },
          // Special variables: $variable (preprocessor), @variable (member), @@variable (static)
          { regex: /\$\b[a-zA-Z_]\w*\b/, token: 'variable-2' },
          { regex: /@@(?:(?:\b[a-zA-Z_]\w*)?((?:\.|::|\\)\b[a-zA-Z_]\w*\b)*)?/, token: 'variable-2' },
          { regex: /@(?:(?:\b[a-zA-Z_]\w*)?((?:\.|::|\\)\b[a-zA-Z_]\w*\b)*)?/, token: 'variable-2' },
          // Magic methods: __class, __base, etc.
          { regex: /\b__(?:class|base|init|inherited|mode|name|add|sub|mul|div|mod|pow|unm|idiv|band|bor|bxor|bnot|shl|shr|concat|len|eq|lt|le|index|newindex|call|metatable|gc|close|tostring|pairs|ipairs)\b/, token: 'function' },
          // Numbers: decimal, hex, with underscores
          { regex: /\b([\d_]+(\.[\d_]+)?|\.[\d_]+)(e[+\-]?[\d_]+)?\b/i, token: 'number' },
          { regex: /\b0x([0-9a-fA-F]([0-9a-fA-F_]*[0-9a-fA-F])?(\.[0-9a-fA-F]([0-9a-fA-F_]*[0-9a-fA-F])?)?|\.[0-9a-fA-F]([0-9a-fA-F_]*[0-9a-fA-F])?)\b/i, token: 'number' },
          // Invalid number
          { regex: /\b\d(?:\w|\.|:|::|\\)+\b/, token: 'invalid' },
          // Built-in constants
          { regex: /\b(?:_ENV|_G|_VERSION|arg)\b(?![:\w])/, token: 'constant' },
          // Built-in functions - comprehensive list
          { regex: /\b(?:_G(?:\\.|:|::|\\))*(?:lpeg|lpeglabel)(?:(?:\\.|::|\\)(?:B|C|Carg|Cb|Cc|Cf|Cg|Cmt|Cp|Cs|Ct|P|R|S|T|V|locale|match|pcode|ptree|setmaxstack|type|utfR|version))?\b/, token: 'function' },
          { regex: /\b(?:_G(?:\\.|:|::|\\))*(?:re|relabel)(?:(?:\\.|::|\\)(?:calcline|compile|find|gsub|match|updatelocale))?\b/, token: 'function' },
          { regex: /\b(?:_G(?:\\.|:|::|\\))*coroutine(?:(?:\\.|::|\\)(?:close|create|isyieldable|resume|running|status|wrap|yield))?\b/, token: 'function' },
          { regex: /\b(?:_G(?:\\.|:|::|\\))*debug(?:(?:\\.|::|\\)(?:debug|gethook|getinfo|getlocal|getmetatable|getregistry|getupvalue|getuservalue|setcstacklimit|sethook|setlocal|setmetatable|setupvalue|setuservalue|traceback|upvalueid|upvaluejoin))?\b/, token: 'function' },
          { regex: /\b(?:_G(?:\\.|:|::|\\))*io(?:(?:\\.|::|\\)(?:close|flush|input|lines|open|output|popen|read|stderr|stdin|stdout|tmpfile|type|write))?\b/, token: 'function' },
          { regex: /\b(?:_G(?:\\.|:|::|\\))*math(?:(?:\\.|::|\\)(?:abs|acos|asin|atan|atan2|ceil|cos|cosh|deg|exp|floor|fmod|frexp|huge|ldexp|log|log10|max|maxinteger|min|mininteger|modf|pi|pow|rad|random|randomseed|sin|sinh|sqrt|tan|tanh|tointeger|type|ult))?\b/, token: 'function' },
          { regex: /\b(?:_G(?:\\.|:|::|\\))*os(?:(?:\\.|::|\\)(?:clock|date|difftime|execute|exit|getenv|remove|rename|setlocale|time|tmpname))?\b/, token: 'function' },
          { regex: /\b(?:_G(?:\\.|:|::|\\))*package(?:(?:\\.|::|\\)(?:config|cpath|loaded|loadlib|path|preload|searchers|searchpath))?\b/, token: 'function' },
          { regex: /\b(?:_G(?:\\.|:|::|\\))*string(?:(?:\\.|::|\\)(?:byte|char|dump|find|format|gmatch|gsub|len|lower|match|pack|packsize|rep|reverse|sub|unpack|upper))?\b/, token: 'function' },
          { regex: /\b(?:_G(?:\\.|:|::|\\))*table(?:(?:\\.|::|\\)(?:concat|insert|move|pack|remove|sort|unpack))?\b/, token: 'function' },
          { regex: /\b(?:_G(?:\\.|:|::|\\))*utf8(?:(?:\\.|::|\\)(?:char|charpattern|codepoint|codes|len|offset))?\b/, token: 'function' },
          { regex: /\b(?:_G(?:\\.|:|::|\\))*yue(?:(?:\\.|::|\\)(?:check|dofile|file_exist|find_modulepath|format|insert_loader|is_ast|loadfile|loadstring|macro_env|options|p|pcall|read_file|to_ast|to_lua|traceback|version|yue_compiled))?\b/, token: 'function' },
          { regex: /\b(?:_G(?:\\.|:|::|\\))*(?:assert|collectgarbage|dofile|error|getmetatable|ipairs|lfs|load|loadfile|next|pairs|pcall|print|rawequal|rawget|rawlen|rawset|require|select|setmetatable|tonumber|tostring|type|warn|xpcall)\b/, token: 'function' },
          // pl.* library functions (penlight)
          { regex: /\b(?:_G(?:\\.|:|::|\\))*pl\.(?:Date|List|Map|MultiMap|OrderedMap|Set|app|array2d|class|compat|comprehension|config|data|dir|file|func|input|lapp|lexer|luabalanced|operator|path|permute|pretty|seq|sip|strict|stringio|stringx|tablex|template|test|text|types|url|utils|xml)(?:(?:\\.|::|\\)\w+)?\b/, token: 'function' },
          // Arrow functions: (params) => or <= name
          { regex: /\([^)]*\)\s*[=-]>/, token: 'operator' },
          { regex: /\([^)]*\)?\s*<[=-]\s*(?=[a-zA-Z_])/, token: 'operator' },
          // new keyword before arrow function
          { regex: /\bnew\b(?=:\s*\([^)]*\)?\s*[=-]>)/, token: 'variable' },
          // Brackets and delimiters
          { regex: /[()\[\]{}]/, token: 'bracket' },
          { regex: /\.|::|\\/, token: 'operator' },
          // Variable names (with dot notation support)
          { regex: /[a-zA-Z_$][\w$]*(?:(?:\.|::|\\)[a-zA-Z_$][\w$]*)*/, token: 'variable' }
        ],
        commentBlock: [
          { regex: /.*?\]\]/, token: 'comment', pop: true },
          { regex: /@\w*/, token: 'typeName' },
          { regex: /.*/, token: 'comment' }
        ],
        luaString: [
          // Match closing ]=] where number of = matches opening
          // This is a simplified version - matches ]=] with 0 or more =
          { regex: /\](=*)\]/, token: 'string', pop: true },
          { regex: /.*/, token: 'string' }
        ],
        doubleString: [
          { regex: /"/, token: 'string', pop: true },
          { regex: /\\[abfnrtvz\\'"]/, token: 'constant' },
          { regex: /\\\d{1,3}/, token: 'constant' },
          { regex: /\\x[0-9a-fA-F]{2}/, token: 'constant' },
          { regex: /\\u\{[0-9a-fA-F]+\}/, token: 'constant' },
          { regex: /\\\./, token: 'invalid' },
          { regex: /#\{/, token: 'operator', push: 'interpolation' },
          { regex: /%[%aAcdeEfgiopsuxX]/, token: 'constant' },
          { regex: /[^"\\#%]+/, token: 'string' }
        ],
        singleString: [
          { regex: /'/, token: 'string', pop: true },
          { regex: /\\[abfnrtvz\\']/, token: 'string' },
          { regex: /\\\d{1,3}/, token: 'string' },
          { regex: /\\x[0-9a-fA-F]{2}/, token: 'string' },
          { regex: /\\u\{[0-9a-fA-F]+\}/, token: 'string' },
          { regex: /\\\./, token: 'invalid' },
          { regex: /%[%aAcdeEfgiopsuxX]/, token: 'constant' },
          { regex: /[^'\\%]+/, token: 'string' }
        ],
        interpolation: [
          { regex: /\}/, token: 'operator', pop: true },
          { regex: /\{/, token: 'operator', push: 'interpolation' },
          { regex: /"(?:[^\\"]|\\.)*"?/, token: 'string' },
          { regex: /'(?:[^\\']|\\.)*'?/, token: 'string' },
          { regex: /\b(?:import|as|from|export|macro|local|global|close|const|class|extends|using|if|then|else|elseif|until|unless|switch|when|with|do|for|while|repeat|return|continue|break|try|catch|goto|or|and|in|not|true|false|nil)\b/, token: 'keyword' },
          { regex: /\b[A-Z]\w*\b/, token: 'typeName' },
          { regex: /[a-zA-Z_$][\w$]*/, token: 'variable' },
          { regex: /(?:\d+\.?\d*|\.\d+)(?:e[+-]?\d+)?/i, token: 'number' },
          { regex: /[+\-/*=<>!]=?|[~^|&%]/, token: 'operator' },
          { regex: /[()\[\]{}]/, token: 'bracket' },
          { regex: /[^}]/, token: 'variable' }
        ],
        languageData: {
          name: 'yuescript'
        }
      })

      this.readOnlyCompartment = new Compartment()
      this.themeCompartment = new Compartment()
      this.highlightCompartment = new Compartment()
      const updateListener = EditorView.updateListener.of((update) => {
        if (!update.docChanged) {
          return
        }
        const nextCode = update.state.doc.toString()
        this.code = nextCode
        this.codeChanged(nextCode)
      })

      const isDark = this.isDarkTheme()

      const state = EditorState.create({
        doc: initialCode,
        extensions: [
          lineNumbers(),
          history(),
          keymap.of([...defaultKeymap, ...historyKeymap, indentWithTab]),
          StreamLanguage.define(yuescriptMode),
          indentUnit.of('  '),
          this.readOnlyCompartment.of(EditorState.readOnly.of(this.readonly)),
          this.highlightCompartment.of(
            syntaxHighlighting(
              isDark ? darkPlusHighlightStyle : lightPlusHighlightStyle,
              { fallback: true }
            )
          ),
          updateListener,
          this.themeCompartment.of(isDark ? darkPlusTheme : lightPlusTheme)
        ]
      })

      this.editorView = new EditorView({
        state,
        parent: this.$refs.codeEditor
      })
    },
    refreshEditorTheme() {
      if (!this.editorView || !this.themeCompartment || !this.highlightCompartment) {
        return
      }
      const isDark = this.isDarkTheme()
      this.editorView.dispatch({
        effects: [
          this.themeCompartment.reconfigure(
            isDark ? darkPlusTheme : lightPlusTheme
          ),
          this.highlightCompartment.reconfigure(
            syntaxHighlighting(
              isDark ? darkPlusHighlightStyle : lightPlusHighlightStyle,
              { fallback: true }
            )
          )
        ]
      })
    },
    refreshEditorReadOnly() {
      if (!this.editorView || !this.readOnlyCompartment) {
        return
      }
      this.editorView.dispatch({
        effects: this.readOnlyCompartment.reconfigure(
          EditorState.readOnly.of(this.readonly)
        )
      })
    },
    runCode() {
      if (window.yue && this.compiled !== '') {
        let res = ''
        try {
          res = window.yue.exec(this.code)
        } catch (err) {
          res = err
        }
        this.result = res
      }
    },
    codeChanged(text) {
      if (window.yue) {
        let res = [
          '',
          'compiler error, and please help opening an issue for this. Thanks a lot!'
        ]
        try {
          res = window.yue.tolua(text, true, !this.displayonly, true)
          if (res[0] !== '') {
            this.compiled = res[0]
          } else {
            this.compiled = res[1]
          }
        } catch (error) {
          this.compiled = res[1]
        }
      }
    }
  }
}
</script>

<style scoped>
.resultArea {
  float: left;
  margin-right: 1em;
  overflow: scroll;
  overflow-wrap: break-word;
  width: calc(100% - 120px);
  height: 55px;
  border-color: #b7ae8f;
  border-radius: 4px;
  border-width: 1px;
  border-style: solid;
  padding: 10px;
  outline: none;
  resize: none;
  margin-top: 5px;
}

.parent {
  display: flex;
  flex-wrap: wrap;
  width: 100%;
  background: var(--vp-c-bg-alt);
}

.editor-section {
  width: 50%;
  box-sizing: border-box;
  background: var(--vp-c-bg-alt);
}

.editor-section:first-child {
  border-right: 1px solid var(--vp-c-divider);
}

.editor-container {
  height: 55vh;
}

.childTitle {
  width: 100%;
  font-size: 1.2em;
  color: var(--vp-c-text-2);
  font-weight: bold;
  text-align: center;
  padding: 0.2em;
  height: 2.5em;
  display: flex;
  align-items: center;
  justify-content: center;
}

.button {
  float: right;
  border: none;
  display: inline-block;
  font-size: 1.2rem;
  color: #fff;
  background-color: #b7ae8f;
  text-decoration: none;
  padding: 0.8rem 1.6rem;
  border-radius: 4px;
  transition: background-color 0.1s ease;
  box-sizing: border-box;
  border-bottom: 1px solid #aaa07b;
  margin-top: 10px;
  margin-right: 5px;
}

.button:hover {
  background-color: #beb69a;
}

.button:focus,
.button:active:focus,
.button.active:focus,
.button.focus,
.button:active.focus {
  outline: none;
}

.code-editor {
  height: 100%;
}

.code-editor :deep(.cm-scroller) {
  overscroll-behavior: contain;
}

.code-editor :deep(.cm-content) {
  padding-top: 15px;
  padding-left: 10px;
}

.code-output {
  margin: 0;
  height: 100%;
  overflow: auto;
  padding: 12px;
  font-size: 15px;
}

@media screen and (max-width: 768px) {
  .parent {
    flex-direction: column;
  }

  .editor-section {
    width: 100%;
  }

  .editor-container {
    height: 30vh;
  }
}
</style>
