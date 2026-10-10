<template>
  <div class="not-content yue-compiler">
    <div class="parent">
      <div class="editor-section">
        <div class="childTitle">
          <span translate="no">YueScript</span>&nbsp;<span role="status">{{
            info
          }}</span>
        </div>
        <div class="editor-container">
          <div ref="codeEditor" class="code-editor"></div>
        </div>
      </div>
      <div class="editor-section">
        <div class="childTitle" translate="no">Lua</div>
        <div class="editor-container">
          <div ref="luaOutput" class="code-editor"></div>
        </div>
      </div>
    </div>
    <p :class="compileError ? 'compiler-status' : 'sr-only'" role="status">
      {{ compilationStatus }}
    </p>
    <div v-if="!compileronly" class="compiler-actions">
      <output
        class="resultArea"
        name="program-output"
        :aria-label="messages.programOutput"
        role="status"
        tabindex="0"
        >{{ result }}</output
      >
      <button
        type="button"
        class="button"
        :disabled="readonly"
        @click="runCode()"
      >
        {{ messages.run }}
      </button>
    </div>
  </div>
</template>

<script>
import { defaultKeymap, history, historyKeymap } from "@codemirror/commands";
import {
  HighlightStyle,
  indentUnit,
  StreamLanguage,
  syntaxHighlighting,
} from "@codemirror/language";
import { lua } from "@codemirror/legacy-modes/mode/lua";
import { simpleMode } from "@codemirror/legacy-modes/mode/simple-mode";
import { Compartment, EditorState } from "@codemirror/state";
import { EditorView, keymap, lineNumbers } from "@codemirror/view";
import { tags } from "@lezer/highlight";

const TRY_PAGE_DRAFT_KEY = "yuescript.try.code";
const TRY_PAGE_DRAFT_SAVE_DELAY = 1000;

function createEditorTheme({
  bg,
  fg,
  gutterColor,
  selectionBg,
  cursorColor,
  matchingBracketBg,
  dark,
}) {
  return EditorView.theme(
    {
      "&": {
        height: "100%",
        backgroundColor: bg,
        color: fg,
        fontSize: "14px",
      },
      "&.cm-focused": { outline: "none" },
      ".cm-content": {
        fontFamily:
          "ui-monospace, 'Menlo', 'Monaco', 'Consolas', 'Liberation Mono', 'Courier New', monospace",
        lineHeight: "1.375",
      },
      ".cm-gutters": {
        backgroundColor: bg,
        color: gutterColor,
        borderRight: "none",
      },
      ".cm-activeLine": { backgroundColor: "transparent" },
      ".cm-activeLineGutter": { backgroundColor: "transparent" },
      ".cm-selectionBackground": { backgroundColor: selectionBg },
      "&.cm-focused .cm-selectionBackground": { backgroundColor: selectionBg },
      ".cm-cursor": { borderLeftColor: cursorColor },
      ".cm-matchingBracket": { backgroundColor: matchingBracketBg },
    },
    { dark },
  );
}

const lightPlusTheme = createEditorTheme({
  bg: "#FFFFFF",
  fg: "#000000",
  gutterColor: "#6e6e6e",
  selectionBg: "#add6ff",
  cursorColor: "#000000",
  matchingBracketBg: "#c9def5",
  dark: false,
});

const darkPlusTheme = createEditorTheme({
  bg: "#1E1E1E",
  fg: "#D4D4D4",
  gutterColor: "#858585",
  selectionBg: "#264f78",
  cursorColor: "#aeafad",
  matchingBracketBg: "#3a3d41",
  dark: true,
});

function createHighlightStyle(c) {
  return HighlightStyle.define(
    [
      { tag: tags.comment, color: c.comment },
      { tag: tags.keyword, color: c.keyword },
      { tag: [tags.operator, tags.punctuation], color: c.punctuation },
      { tag: [tags.string, tags.special(tags.string)], color: c.string },
      { tag: tags.regexp, color: c.regexp },
      { tag: [tags.number, tags.bool, tags.null], color: c.number },
      { tag: tags.function(tags.variableName), color: c.function },
      { tag: tags.typeName, color: c.type },
      { tag: tags.className, color: c.type },
      { tag: tags.propertyName, color: c.property },
      { tag: tags.tagName, color: c.tag },
      { tag: tags.attributeName, color: c.attribute },
      { tag: tags.meta, color: c.meta },
      { tag: tags.invalid, color: c.invalid },
      { tag: tags.variableName, color: c.property },
      { tag: tags.constant(tags.name), color: c.number },
      { tag: tags.constant(tags.variableName), color: c.number },
      { tag: tags.definition(tags.variableName), color: c.property },
      { tag: tags.modifier, color: c.keyword },
      { tag: tags.namespace, color: c.type },
      { tag: tags.labelName, color: c.function },
      { tag: tags.character, color: c.number },
      { tag: tags.literal, color: c.number },
      { tag: tags.bracket, color: c.punctuation },
      { tag: tags.squareBracket, color: c.punctuation },
      { tag: tags.paren, color: c.punctuation },
      { tag: tags.brace, color: c.punctuation },
    ],
    { fallback: true },
  );
}

const lightPlusHighlightStyle = createHighlightStyle({
  comment: "#008000",
  keyword: "#AF00DB",
  punctuation: "#000000",
  string: "#a31515",
  regexp: "#811f3f",
  number: "#098658",
  function: "#795e26",
  type: "#267f99",
  property: "#001080",
  tag: "#800000",
  attribute: "#e50000",
  meta: "#666666",
  invalid: "#cd3131",
});

const darkPlusHighlightStyle = createHighlightStyle({
  comment: "#6a9955",
  keyword: "#C586C0",
  punctuation: "#d4d4d4",
  string: "#ce9178",
  regexp: "#d16969",
  number: "#b5cea8",
  function: "#dcdcaa",
  type: "#4ec9b0",
  property: "#9cdcfe",
  tag: "#569cd6",
  attribute: "#9cdcfe",
  meta: "#d4d4d4",
  invalid: "#f44747",
});

export default {
  props: {
    messages: {
      type: Object,
      required: true,
    },
    compileronly: {
      type: Boolean,
      default: false,
    },
    displayonly: {
      type: Boolean,
      default: false,
    },
    text: {
      type: String,
      default: "",
    },
  },
  data() {
    return {
      info: this.messages.loading,
      readonly: true,
      code: "",
      compiled: "",
      compileError: false,
      compilationStatus: "",
      result: "",
      editorView: null,
      luaView: null,
      readOnlyCompartment: null,
      themeCompartment: null,
      highlightCompartment: null,
      themeObserver: null,
      _onYueReady: null,
      draftSaveTimer: null,
    };
  },
  computed: {
    shouldPersistDraft() {
      return !this.compileronly && !this.displayonly && this.text === "";
    },
  },
  watch: {
    compiled(text) {
      if (this.luaView) {
        this.luaView.dispatch({
          changes: {
            from: 0,
            to: this.luaView.state.doc.length,
            insert: text.replace(/\n$/, ""),
          },
        });
      }
    },
  },
  mounted() {
    window.addEventListener("beforeunload", this.saveDraftNow);
    this.observeTheme();

    const initialCode = this.loadDraftCode();
    this.code = initialCode;
    this.codeChanged(initialCode);
    this.initEditor(initialCode);

    const onYueReady = () => {
      if (window.yue) {
        this.info = window.yue.version();
        this.readonly = false;
        this.codeChanged(this.code);
        this.refreshEditorReadOnly();
      }
    };
    if (window.yue) {
      onYueReady();
    } else {
      this._onYueReady = onYueReady;
      window.addEventListener("yue:ready", onYueReady, { once: true });
    }
  },
  beforeUnmount() {
    this.saveDraftNow();
    window.removeEventListener("beforeunload", this.saveDraftNow);
    if (this._onYueReady) {
      window.removeEventListener("yue:ready", this._onYueReady);
      this._onYueReady = null;
    }
    if (this.draftSaveTimer) {
      clearTimeout(this.draftSaveTimer);
      this.draftSaveTimer = null;
    }
    if (this.editorView) {
      this.editorView.destroy();
      this.editorView = null;
    }
    if (this.luaView) {
      this.luaView.destroy();
      this.luaView = null;
    }
    if (this.themeObserver) {
      this.themeObserver.disconnect();
      this.themeObserver = null;
    }
  },
  methods: {
    loadDraftCode() {
      if (!this.shouldPersistDraft) {
        return this.text;
      }
      try {
        const draft = window.localStorage.getItem(TRY_PAGE_DRAFT_KEY);
        return draft === null ? this.text : draft;
      } catch (error) {
        return this.text;
      }
    },
    scheduleDraftSave(text) {
      if (!this.shouldPersistDraft) {
        return;
      }
      if (this.draftSaveTimer) {
        clearTimeout(this.draftSaveTimer);
      }
      this.draftSaveTimer = window.setTimeout(() => {
        this.draftSaveTimer = null;
        this.saveDraft(text);
      }, TRY_PAGE_DRAFT_SAVE_DELAY);
    },
    saveDraftNow(event) {
      if (!this.shouldPersistDraft) {
        return;
      }
      if (this.draftSaveTimer) {
        clearTimeout(this.draftSaveTimer);
        this.draftSaveTimer = null;
      }
      const saved = this.saveDraft(this.code);
      if (!saved && this.code !== this.text && event) {
        event.preventDefault();
        event.returnValue = "";
      }
    },
    saveDraft(text) {
      try {
        window.localStorage.setItem(TRY_PAGE_DRAFT_KEY, text);
        return true;
      } catch (error) {
        // Ignore unavailable or full localStorage; compiling should still work.
        return false;
      }
    },
    focusEditorToEnd() {
      if (!this.editorView) {
        return;
      }
      const docLength = this.editorView.state.doc.length;
      this.editorView.dispatch({
        selection: { anchor: docLength },
        scrollIntoView: true,
      });
      this.editorView.focus();
    },
    isDarkTheme() {
      return document.documentElement.dataset.theme === "dark";
    },
    observeTheme() {
      if (this.themeObserver) {
        return;
      }
      this.themeObserver = new MutationObserver(() => {
        this.refreshEditorTheme();
      });
      this.themeObserver.observe(document.documentElement, {
        attributes: true,
        attributeFilter: ["data-theme"],
      });
    },
    initEditor(initialCode) {
      if (!this.$refs.codeEditor) {
        return;
      }

      const yuescriptMode = simpleMode({
        start: [
          // Shebang
          { regex: /^#!.*/, token: "comment" },
          // Multiline string: [=[...]=] with any number of =
          { regex: /\[(=*)\[/, token: "string", push: "luaString" },
          // Block comment: --[[...]] (but not ---)
          { regex: /--\[\[/, token: "comment", push: "commentBlock" },
          // Line comment: -- (but not ---)
          { regex: /--(?!-).*/, token: "comment" },
          // Double quoted string with interpolation #{...}
          { regex: /"/, token: "string", push: "doubleString" },
          // Single quoted string
          { regex: /'/, token: "string", push: "singleString" },
          // Tag: ::name::
          { regex: /(::)\s*[a-zA-Z_][a-zA-Z0-9_]*\s*(::)/, token: "tagName" },
          // Class definition: class Name extends Base
          {
            regex:
              /\bclass\b\s+(@?[a-zA-Z$_][\w.]*)?(?:\s+\bextends\b\s+(@?[a-zA-Z$._][\w.]*))?/,
            token: "keyword",
          },
          // Function definition: name: => or name := => or name(params): =>
          {
            regex: /(@?[a-zA-Z$_]\??[\w$:.]*\s*[:=]\s*(?:\([^)]*\))?\s*[=-]>)/,
            token: "function",
          },
          // Destructured assignment: { ... } := or { ... } =
          { regex: /\{\s*[^}]*\}\s*[:=]/, token: "keyword" },
          // Keywords (must come before operators to catch 'and', 'or', 'in', 'not')
          {
            regex:
              /\b(?:import|as|from|export|macro|local|global|close|const|class|extends|using)\b(?![:\w])/,
            token: "keyword",
          },
          // Control keywords
          {
            regex:
              /\b(?:if|then|else|elseif|until|unless|switch|when|with|do|for|while|repeat|return|continue|break|try|catch|goto)\b(?![:\w])/,
            token: "keyword",
          },
          { regex: /\b(?:or|and|in|not)\b(?![:\w])/, token: "keyword" },
          // Boolean and nil
          { regex: /\b(?:true|false|nil)\b(?![:\w])/, token: "number" },
          // Invalid: function/end
          { regex: /\b(?:function|end)\b(?![:\w])/, token: "invalid" },
          // Invalid: self (deprecated)
          { regex: /\bself\b(?![:\w])/, token: "invalid" },
          // super keyword
          { regex: /\bsuper\b(?![:\w])/, token: "variable" },
          // Invalid variables: $$, $@, @@@, standalone $
          { regex: /\$\$+/, token: "invalid" },
          { regex: /@@@+/, token: "invalid" },
          { regex: /\$(?!\w)/, token: "invalid" },
          // Special operators: <mode>, <>, <"string">, <'string'>, <word> (invalid)
          {
            regex:
              /<\b(?:mode|name|add|sub|mul|div|mod|pow|unm|idiv|band|bor|bxor|bnot|shl|shr|concat|len|eq|lt|le|index|newindex|call|metatable|gc|close|tostring|pairs|ipairs)\b>/,
            token: "constant",
          },
          { regex: /<>/, token: "constant" },
          { regex: /<"[^"]*">/, token: "constant" },
          { regex: /<'[^']*'>/, token: "constant" },
          { regex: /<\w+>/, token: "invalid" },
          // Operators (and/or removed since they're keywords, ?? must not match ???)
          {
            regex: /(\+|\-|\*|\/|%|\^|\/\/|\||\&|>>|<<|\.\.)=?/,
            token: "operator",
          },
          { regex: /\?\?(?!\?)/, token: "operator" },
          { regex: /\[\]\s*=/, token: "operator" },
          { regex: /==|~=|!=|>|>=|<|<=/, token: "operator" },
          { regex: /#|~|\?|!/, token: "operator" },
          { regex: /\|>|=|:=|:(?!:)|,|\b_\b/, token: "operator" },
          { regex: /\.\.\.(?!\.)/, token: "constant" },
          // Invalid: 4+ dots
          { regex: /\.{4,}/, token: "invalid" },
          // Class name (capitalized) - must come after keywords
          { regex: /\b[A-Z]\w*\b/, token: "typeName" },
          // Special variables: $variable (preprocessor), @variable (member), @@variable (static)
          { regex: /\$\b[a-zA-Z_]\w*\b/, token: "variable-2" },
          {
            regex: /@@(?:(?:\b[a-zA-Z_]\w*)?((?:\.|::|\\)\b[a-zA-Z_]\w*\b)*)?/,
            token: "variable-2",
          },
          {
            regex: /@(?:(?:\b[a-zA-Z_]\w*)?((?:\.|::|\\)\b[a-zA-Z_]\w*\b)*)?/,
            token: "variable-2",
          },
          // Magic methods: __class, __base, etc.
          {
            regex:
              /\b__(?:class|base|init|inherited|mode|name|add|sub|mul|div|mod|pow|unm|idiv|band|bor|bxor|bnot|shl|shr|concat|len|eq|lt|le|index|newindex|call|metatable|gc|close|tostring|pairs|ipairs)\b/,
            token: "function",
          },
          // Numbers: decimal, hex, with underscores
          {
            regex: /\b([\d_]+(\.[\d_]+)?|\.[\d_]+)(e[+\-]?[\d_]+)?\b/i,
            token: "number",
          },
          {
            regex:
              /\b0x([0-9a-fA-F]([0-9a-fA-F_]*[0-9a-fA-F])?(\.[0-9a-fA-F]([0-9a-fA-F_]*[0-9a-fA-F])?)?|\.[0-9a-fA-F]([0-9a-fA-F_]*[0-9a-fA-F])?)\b/i,
            token: "number",
          },
          // Invalid number
          { regex: /\b\d(?:\w|\.|:|::|\\)+\b/, token: "invalid" },
          // Built-in constants
          { regex: /\b(?:_ENV|_G|_VERSION|arg)\b(?![:\w])/, token: "constant" },
          // Built-in functions - comprehensive list
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*(?:lpeg|lpeglabel)(?:(?:\\.|::|\\)(?:B|C|Carg|Cb|Cc|Cf|Cg|Cmt|Cp|Cs|Ct|P|R|S|T|V|locale|match|pcode|ptree|setmaxstack|type|utfR|version))?\b/,
            token: "function",
          },
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*(?:re|relabel)(?:(?:\\.|::|\\)(?:calcline|compile|find|gsub|match|updatelocale))?\b/,
            token: "function",
          },
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*coroutine(?:(?:\\.|::|\\)(?:close|create|isyieldable|resume|running|status|wrap|yield))?\b/,
            token: "function",
          },
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*debug(?:(?:\\.|::|\\)(?:debug|gethook|getinfo|getlocal|getmetatable|getregistry|getupvalue|getuservalue|setcstacklimit|sethook|setlocal|setmetatable|setupvalue|setuservalue|traceback|upvalueid|upvaluejoin))?\b/,
            token: "function",
          },
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*io(?:(?:\\.|::|\\)(?:close|flush|input|lines|open|output|popen|read|stderr|stdin|stdout|tmpfile|type|write))?\b/,
            token: "function",
          },
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*math(?:(?:\\.|::|\\)(?:abs|acos|asin|atan|atan2|ceil|cos|cosh|deg|exp|floor|fmod|frexp|huge|ldexp|log|log10|max|maxinteger|min|mininteger|modf|pi|pow|rad|random|randomseed|sin|sinh|sqrt|tan|tanh|tointeger|type|ult))?\b/,
            token: "function",
          },
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*os(?:(?:\\.|::|\\)(?:clock|date|difftime|execute|exit|getenv|remove|rename|setlocale|time|tmpname))?\b/,
            token: "function",
          },
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*package(?:(?:\\.|::|\\)(?:config|cpath|loaded|loadlib|path|preload|searchers|searchpath))?\b/,
            token: "function",
          },
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*string(?:(?:\\.|::|\\)(?:byte|char|dump|find|format|gmatch|gsub|len|lower|match|pack|packsize|rep|reverse|sub|unpack|upper))?\b/,
            token: "function",
          },
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*table(?:(?:\\.|::|\\)(?:concat|insert|move|pack|remove|sort|unpack))?\b/,
            token: "function",
          },
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*utf8(?:(?:\\.|::|\\)(?:char|charpattern|codepoint|codes|len|offset))?\b/,
            token: "function",
          },
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*yue(?:(?:\\.|::|\\)(?:check|dofile|file_exist|find_modulepath|format|insert_loader|is_ast|loadfile|loadstring|macro_env|options|p|pcall|read_file|to_ast|to_lua|traceback|version|yue_compiled))?\b/,
            token: "function",
          },
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*(?:assert|collectgarbage|dofile|error|getmetatable|ipairs|lfs|load|loadfile|next|pairs|pcall|print|rawequal|rawget|rawlen|rawset|require|select|setmetatable|tonumber|tostring|type|warn|xpcall)\b/,
            token: "function",
          },
          // pl.* library functions (penlight)
          {
            regex:
              /\b(?:_G(?:\\.|:|::|\\))*pl\.(?:Date|List|Map|MultiMap|OrderedMap|Set|app|array2d|class|compat|comprehension|config|data|dir|file|func|input|lapp|lexer|luabalanced|operator|path|permute|pretty|seq|sip|strict|stringio|stringx|tablex|template|test|text|types|url|utils|xml)(?:(?:\\.|::|\\)\w+)?\b/,
            token: "function",
          },
          // Arrow functions: (params) => or <= name
          { regex: /\([^)]*\)\s*[=-]>/, token: "operator" },
          { regex: /\([^)]*\)?\s*<[=-]\s*(?=[a-zA-Z_])/, token: "operator" },
          // new keyword before arrow function
          { regex: /\bnew\b(?=:\s*\([^)]*\)?\s*[=-]>)/, token: "variable" },
          // Brackets and delimiters
          { regex: /[()\[\]{}]/, token: "bracket" },
          { regex: /\.|::|\\/, token: "operator" },
          // Variable names (with dot notation support)
          {
            regex: /[a-zA-Z_$][\w$]*(?:(?:\.|::|\\)[a-zA-Z_$][\w$]*)*/,
            token: "variable",
          },
        ],
        commentBlock: [
          { regex: /.*?\]\]/, token: "comment", pop: true },
          { regex: /@\w*/, token: "typeName" },
          { regex: /.*/, token: "comment" },
        ],
        luaString: [
          // Match closing ]=] where number of = matches opening
          // This is a simplified version - matches ]=] with 0 or more =
          { regex: /\](=*)\]/, token: "string", pop: true },
          { regex: /.*/, token: "string" },
        ],
        doubleString: [
          { regex: /"/, token: "string", pop: true },
          { regex: /\\[abfnrtvz\\'"]/, token: "constant" },
          { regex: /\\\d{1,3}/, token: "constant" },
          { regex: /\\x[0-9a-fA-F]{2}/, token: "constant" },
          { regex: /\\u\{[0-9a-fA-F]+\}/, token: "constant" },
          { regex: /\\\./, token: "invalid" },
          { regex: /#\{/, token: "operator", push: "interpolation" },
          { regex: /%[%aAcdeEfgiopsuxX]/, token: "constant" },
          { regex: /[^"\\#%]+/, token: "string" },
        ],
        singleString: [
          { regex: /'/, token: "string", pop: true },
          { regex: /\\[abfnrtvz\\']/, token: "string" },
          { regex: /\\\d{1,3}/, token: "string" },
          { regex: /\\x[0-9a-fA-F]{2}/, token: "string" },
          { regex: /\\u\{[0-9a-fA-F]+\}/, token: "string" },
          { regex: /\\\./, token: "invalid" },
          { regex: /%[%aAcdeEfgiopsuxX]/, token: "constant" },
          { regex: /[^'\\%]+/, token: "string" },
        ],
        interpolation: [
          { regex: /\}/, token: "operator", pop: true },
          { regex: /\{/, token: "operator", push: "interpolation" },
          { regex: /"(?:[^\\"]|\\.)*"?/, token: "string" },
          { regex: /'(?:[^\\']|\\.)*'?/, token: "string" },
          {
            regex:
              /\b(?:import|as|from|export|macro|local|global|close|const|class|extends|using|if|then|else|elseif|until|unless|switch|when|with|do|for|while|repeat|return|continue|break|try|catch|goto|or|and|in|not|true|false|nil)\b/,
            token: "keyword",
          },
          { regex: /\b[A-Z]\w*\b/, token: "typeName" },
          { regex: /[a-zA-Z_$][\w$]*/, token: "variable" },
          { regex: /(?:\d+\.?\d*|\.\d+)(?:e[+-]?\d+)?/i, token: "number" },
          { regex: /[+\-/*=<>!]=?|[~^|&%]/, token: "operator" },
          { regex: /[()\[\]{}]/, token: "bracket" },
          { regex: /[^}]/, token: "variable" },
        ],
        languageData: {
          name: "yuescript",
        },
      });

      this.readOnlyCompartment = new Compartment();
      this.themeCompartment = new Compartment();
      this.highlightCompartment = new Compartment();
      const updateListener = EditorView.updateListener.of((update) => {
        if (!update.docChanged) {
          return;
        }
        const nextCode = update.state.doc.toString();
        this.code = nextCode;
        this.scheduleDraftSave(nextCode);
        this.codeChanged(nextCode);
      });

      const isDark = this.isDarkTheme();

      const state = EditorState.create({
        doc: initialCode,
        extensions: [
          lineNumbers(),
          history(),
          keymap.of([...defaultKeymap, ...historyKeymap]),
          StreamLanguage.define({
            ...yuescriptMode,
            tokenTable: {
              function: tags.function(tags.variableName),
              constant: tags.constant(tags.variableName),
            },
          }),
          EditorView.contentAttributes.of({
            "aria-label": this.messages.source,
          }),
          indentUnit.of("  "),
          this.readOnlyCompartment.of(EditorState.readOnly.of(this.readonly)),
          this.highlightCompartment.of(
            syntaxHighlighting(
              isDark ? darkPlusHighlightStyle : lightPlusHighlightStyle,
              { fallback: true },
            ),
          ),
          updateListener,
          this.themeCompartment.of(isDark ? darkPlusTheme : lightPlusTheme),
        ],
      });

      this.editorView = new EditorView({
        state,
        parent: this.$refs.codeEditor,
      });
      this.luaView = new EditorView({
        parent: this.$refs.luaOutput,
        state: EditorState.create({
          doc: this.compiled.replace(/\n$/, ""),
          extensions: [
            StreamLanguage.define(lua),
            EditorState.readOnly.of(true),
            EditorView.editable.of(false),
            EditorView.contentAttributes.of({
              "aria-label": this.messages.luaOutput,
              tabindex: "0",
            }),
            this.themeCompartment.of(isDark ? darkPlusTheme : lightPlusTheme),
            this.highlightCompartment.of(
              syntaxHighlighting(
                isDark ? darkPlusHighlightStyle : lightPlusHighlightStyle,
              ),
            ),
          ],
        }),
      });
    },
    refreshEditorTheme() {
      if (
        !this.editorView ||
        !this.themeCompartment ||
        !this.highlightCompartment
      ) {
        return;
      }
      const isDark = this.isDarkTheme();
      for (const view of [this.editorView, this.luaView])
        view?.dispatch({
          effects: [
            this.themeCompartment.reconfigure(
              isDark ? darkPlusTheme : lightPlusTheme,
            ),
            this.highlightCompartment.reconfigure(
              syntaxHighlighting(
                isDark ? darkPlusHighlightStyle : lightPlusHighlightStyle,
                { fallback: true },
              ),
            ),
          ],
        });
    },
    refreshEditorReadOnly() {
      if (!this.editorView || !this.readOnlyCompartment) {
        return;
      }
      this.editorView.dispatch({
        effects: this.readOnlyCompartment.reconfigure(
          EditorState.readOnly.of(this.readonly),
        ),
      });
    },
    runCode() {
      if (window.yue && this.compiled !== "") {
        let res = "";
        try {
          res = window.yue.exec(this.code);
        } catch (err) {
          res = String(err);
        }
        this.result = res || this.messages.finished;
      }
    },
    codeChanged(text) {
      if (window.yue) {
        let res = ["", this.messages.failed];
        try {
          res = window.yue.tolua(text, true, !this.displayonly, true);
          this.compileError = res[0] === "" && res[1] !== "";
          this.compilationStatus =
            this.compileError ? res[1] : this.messages.complete;
          if (res[0] !== "") {
            this.compiled = res[0];
          } else {
            this.compiled = res[1];
          }
        } catch (error) {
          this.compiled = res[1];
          this.compileError = true;
          this.compilationStatus = res[1];
        }
      }
    },
  },
};
</script>

<style scoped>
.yue-compiler {
  width: 100%;
}

.compiler-actions {
  display: flex;
  align-items: stretch;
  gap: 1rem;
  margin-top: 10px;
}

.resultArea {
  flex: 1;
  min-width: 0;
  margin: 0;
  box-sizing: border-box;
  display: block;
  overflow: auto;
  white-space: pre-wrap;
  overflow-wrap: break-word;
  height: 55px;
  border-color: var(--sl-color-hairline);
  background: var(--sl-color-bg);
  color: var(--sl-color-text);
  border-radius: 4px;
  border-width: 1px;
  border-style: solid;
  padding: 10px;
  font-family: var(--sl-font-mono, monospace);
  font-size: 13px;
}

:root:not([data-input-modality="pointer"]) .resultArea:focus-visible {
  outline: 2px solid var(--sl-color-text-accent);
  outline-offset: 2px;
}

:root[data-input-modality="pointer"] .resultArea:focus-visible {
  outline: none;
}

.parent {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 21rem), 1fr));
  gap: 1px;
  width: 100%;
  background: var(--sl-color-hairline);
}

.editor-section {
  display: flex;
  flex-direction: column;
  min-width: 0;
  box-sizing: border-box;
  background: var(--sl-color-bg-nav);
}

.editor-container {
  height: clamp(16rem, 20dvh + 25vw, 55dvh);
  flex-shrink: 0;
}

.childTitle {
  width: 100%;
  font-size: 1.1em;
  font-family: "Noto Serif", "Noto Serif SC", serif;
  color: var(--sl-color-white);
  font-weight: bold;
  text-align: center;
  padding: 0.2em;
  min-height: 2.5em;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  letter-spacing: -0.02em;
  flex-wrap: wrap;
  overflow-wrap: anywhere;
}

.button {
  flex-shrink: 0;
  margin: 0;
  border: none;
  display: inline-block;
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--color-on-brand);
  background-color: var(--vp-c-brand-1, #b4ac8f);
  text-decoration: none;
  padding: 0.6rem 1.4rem;
  border-radius: 4px;
  transition: background-color 0.1s ease;
  box-sizing: border-box;
  border-bottom: 1px solid #9c9371;
  cursor: pointer;
}

.button:hover:enabled {
  background-color: var(--color-brand-hover);
  color: #fdfbf7 !important;
}

.button:disabled {
  opacity: 0.6;
  cursor: wait;
}

.compiler-status {
  margin-block: 0.75rem 0;
  font-size: 0.875rem;
  overflow-wrap: anywhere;
}

.code-editor {
  height: 100%;
}

.code-editor :deep(.cm-scroller) {
  overscroll-behavior: contain;
}

/* Paint above CodeMirror's scrolling layer, including its sticky gutters. */
.code-editor :deep(.cm-editor.cm-focused)::after {
  content: "";
  position: absolute;
  inset: 0;
  border: 2px solid var(--sl-color-text-accent);
  pointer-events: none;
  z-index: 1;
}

.code-editor :deep(.cm-content) {
  padding-top: 15px;
  /* Match the space previously provided by Lua's final blank line. */
  padding-bottom: 1lh;
  padding-left: 10px;
}

@media (prefers-reduced-motion: reduce) {
  .button {
    transition: none;
  }
}
</style>
