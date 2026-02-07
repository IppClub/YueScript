import { readFileSync } from "fs";
import { dirname, resolve } from "path";
import { fileURLToPath } from "url";
import { defineConfig } from "vitepress";

import darkPlus from "@shikijs/themes/dark-plus";
import lightPlus from "@shikijs/themes/light-plus";

const __dirname = dirname(fileURLToPath(import.meta.url));
const yuescriptGrammarPath = resolve(
  __dirname,
  "grammars/yuescript.tmLanguage.json",
);
const yuescriptGrammar = JSON.parse(
  readFileSync(yuescriptGrammarPath, "utf-8"),
);
const yuescriptLanguage = {
  ...yuescriptGrammar,
  name: "yuescript",
  scopeName: "source.yuescript",
  aliases: ["yue"],
};

const sidebarText = {
  de: {
    introduction: "Einführung",
    installation: "Installation",
    usage: "Verwendung",
    macro: "Makro",
    operator: "Operatoren",
    module: "Modul",
    assignment: "Zuweisung",
    destructuringAssignment: "Destrukturierende Zuweisung",
    ifAssignment: "If-Zuweisung",
    varargsAssignment: "Varargs-Zuweisung",
    whitespace: "Leerraum",
    comment: "Kommentare",
    try: "Try/Catch",
    attributes: "Attribute",
    literals: "Literale",
    functionLiterals: "Funktionsliterale",
    backcalls: "Backcalls",
    tableLiterals: "Tabellenliterale",
    comprehensions: "Comprehensions",
    forLoop: "For-Schleife",
    whileLoop: "While-Schleife",
    continueStatement: "Continue-Anweisung",
    conditionals: "Bedingungen",
    lineDecorators: "Zeilen-Dekoratoren",
    switch: "Switch",
    objectOrientedProgramming: "Objektorientierte Programmierung",
    withStatement: "With-Anweisung",
    do: "Do",
    functionStubs: "Funktions-Stubs",
    usingClause: "Die Using-Klausel; Kontrolle destruktiver Zuweisung",
    yuescriptLibrary: "Die YueScript-Bibliothek",
    licenseMit: "Lizenz: MIT",
  },
  en: {
    introduction: "Introduction",
    installation: "Installation",
    usage: "Usage",
    macro: "Macro",
    operator: "Operator",
    module: "Module",
    assignment: "Assignment",
    destructuringAssignment: "Destructuring Assignment",
    ifAssignment: "If Assignment",
    varargsAssignment: "Varargs Assignment",
    whitespace: "Whitespace",
    comment: "Comment",
    try: "Try",
    attributes: "Attributes",
    literals: "Literals",
    functionLiterals: "Function Literals",
    backcalls: "Backcalls",
    tableLiterals: "Table Literals",
    comprehensions: "Comprehensions",
    forLoop: "For Loop",
    whileLoop: "While Loop",
    continueStatement: "Continue Statement",
    conditionals: "Conditionals",
    lineDecorators: "Line Decorators",
    switch: "Switch",
    objectOrientedProgramming: "Object Oriented Programming",
    withStatement: "With Statement",
    do: "Do",
    functionStubs: "Function Stubs",
    usingClause: "The Using Clause; Controlling Destructive Assignment",
    yuescriptLibrary: "The YueScript Library",
    licenseMit: "License: MIT",
  },
  idId: {
    introduction: "Pendahuluan",
    installation: "Instalasi",
    usage: "Penggunaan",
    macro: "Makro",
    operator: "Operator",
    module: "Modul",
    assignment: "Penugasan",
    destructuringAssignment: "Penugasan Destrukturisasi",
    ifAssignment: "Penugasan If",
    varargsAssignment: "Penugasan Varargs",
    whitespace: "Spasi Kosong",
    comment: "Komentar",
    try: "Coba",
    attributes: "Atribut",
    literals: "Literal",
    functionLiterals: "Literal Fungsi",
    backcalls: "Pemanggilan Mundur",
    tableLiterals: "Literal Tabel",
    comprehensions: "Kompresi",
    forLoop: "Perulangan For",
    whileLoop: "Perulangan While",
    continueStatement: "Pernyataan Lanjutkan",
    conditionals: "Percabangan",
    lineDecorators: "Dekorator Baris",
    switch: "Switch",
    objectOrientedProgramming: "Pemrograman Berorientasi Objek",
    withStatement: "Pernyataan With",
    do: "Do",
    functionStubs: "Fungsi Sementara",
    usingClause: "Klausa Using; Mengontrol Penugasan Destruktif",
    yuescriptLibrary: "Pustaka YueScript",
    licenseMit: "Lisensi: MIT",
  },
  ptBr: {
    introduction: "Introdução",
    installation: "Instalação",
    usage: "Uso",
    macro: "Macro",
    operator: "Operadores",
    module: "Módulo",
    assignment: "Atribuição",
    destructuringAssignment: "Atribuição com desestruturação",
    ifAssignment: "Atribuição com if",
    varargsAssignment: "Atribuição de varargs",
    whitespace: "Espaços em branco",
    comment: "Comentários",
    try: "Try/Catch",
    attributes: "Atributos",
    literals: "Literais",
    functionLiterals: "Literais de função",
    backcalls: "Backcalls",
    tableLiterals: "Literais de tabela",
    comprehensions: "Compreensões",
    forLoop: "Laço for",
    whileLoop: "Laço while",
    continueStatement: "Instrução continue",
    conditionals: "Condicionais",
    lineDecorators: "Decoradores de linha",
    switch: "Switch",
    objectOrientedProgramming: "Programação orientada a objetos",
    withStatement: "Instrução with",
    do: "Do",
    functionStubs: "Stubs de função",
    usingClause: "Cláusula using; controlando atribuição destrutiva",
    yuescriptLibrary: "A biblioteca do YueScript",
    licenseMit: "Licença: MIT",
  },
  zh: {
    introduction: "介绍",
    installation: "安装",
    usage: "使用方法",
    macro: "宏",
    operator: "操作符",
    module: "模块",
    assignment: "赋值",
    destructuringAssignment: "解构赋值",
    ifAssignment: "if 赋值",
    varargsAssignment: "可变参数赋值",
    whitespace: "空白",
    comment: "注释",
    try: "错误处理",
    attributes: "属性",
    literals: "字面量",
    functionLiterals: "函数字面量",
    backcalls: "反向回调",
    tableLiterals: "表格字面量",
    comprehensions: "推导式",
    forLoop: "for 循环",
    whileLoop: "while 循环",
    continueStatement: "continue 语句",
    conditionals: "条件语句",
    lineDecorators: "代码行修饰符",
    switch: "switch 语句",
    objectOrientedProgramming: "面向对象编程",
    withStatement: "with 语句",
    do: "do 语句",
    functionStubs: "函数存根",
    usingClause: "使用 using 语句：防止破坏性赋值",
    yuescriptLibrary: "月之脚本语言库",
    licenseMit: "MIT 许可证",
  },
} as const;

type SidebarLocale = keyof typeof sidebarText;

type SidebarGroupText = {
  gettingStarted: string;
  languageBasics: string;
  assignment: string;
  functions: string;
  controlFlow: string;
  dataStructures: string;
  objects: string;
  advancedFeatures: string;
  reference: string;
};

const sidebarGroups: Record<SidebarLocale, SidebarGroupText> = {
  de: {
    gettingStarted: "Erste Schritte",
    languageBasics: "Sprachgrundlagen",
    assignment: "Zuweisung",
    functions: "Funktionen",
    controlFlow: "Kontrollfluss",
    dataStructures: "Datenstrukturen",
    objects: "Objekte",
    advancedFeatures: "Erweiterte Funktionen",
    reference: "Referenz",
  },
  en: {
    gettingStarted: "Getting Started",
    languageBasics: "Language Basics",
    assignment: "Assignment",
    functions: "Functions",
    controlFlow: "Control Flow",
    dataStructures: "Data Structures",
    objects: "Objects",
    advancedFeatures: "Advanced Features",
    reference: "Reference",
  },
  idId: {
    gettingStarted: "Memulai",
    languageBasics: "Dasar-dasar Bahasa",
    assignment: "Penugasan",
    functions: "Fungsi",
    controlFlow: "Alur Kontrol",
    dataStructures: "Struktur Data",
    objects: "Objek",
    advancedFeatures: "Fitur Lanjutan",
    reference: "Referensi",
  },
  ptBr: {
    gettingStarted: "Primeiros passos",
    languageBasics: "Fundamentos da linguagem",
    assignment: "Atribuição",
    functions: "Funções",
    controlFlow: "Controle de fluxo",
    dataStructures: "Estruturas de dados",
    objects: "Objetos",
    advancedFeatures: "Recursos avançados",
    reference: "Referência",
  },
  zh: {
    gettingStarted: "起步",
    languageBasics: "语言基础",
    assignment: "赋值",
    functions: "函数",
    controlFlow: "控制流",
    dataStructures: "数据结构",
    objects: "面向对象",
    advancedFeatures: "高级特性",
    reference: "参考",
  },
};

function createSidebar(basePath: string, locale: SidebarLocale) {
  const text = sidebarText[locale];
  const group = sidebarGroups[locale];
  return [
    {
      text: group.gettingStarted,
      items: [
        {
          text: text.introduction,
          link: `${basePath}/getting-started/introduction`,
        },
        {
          text: text.installation,
          link: `${basePath}/getting-started/installation`,
        },
        { text: text.usage, link: `${basePath}/getting-started/usage` },
      ],
    },
    {
      text: group.languageBasics,
      collapsed: true,
      items: [
        {
          text: text.whitespace,
          link: `${basePath}/language-basics/whitespace`,
        },
        { text: text.comment, link: `${basePath}/language-basics/comment` },
        { text: text.literals, link: `${basePath}/language-basics/literals` },
        { text: text.operator, link: `${basePath}/language-basics/operator` },
        {
          text: text.attributes,
          link: `${basePath}/language-basics/attributes`,
        },
      ],
    },
    {
      text: group.assignment,
      collapsed: true,
      items: [
        { text: text.assignment, link: `${basePath}/assignment/assignment` },
        {
          text: text.destructuringAssignment,
          link: `${basePath}/assignment/destructuring-assignment`,
        },
        {
          text: text.ifAssignment,
          link: `${basePath}/assignment/if-assignment`,
        },
        {
          text: text.varargsAssignment,
          link: `${basePath}/assignment/varargs-assignment`,
        },
        {
          text: text.usingClause,
          link: `${basePath}/assignment/the-using-clause-controlling-destructive-assignment`,
        },
      ],
    },
    {
      text: group.functions,
      collapsed: true,
      items: [
        {
          text: text.functionLiterals,
          link: `${basePath}/functions/function-literals`,
        },
        { text: text.backcalls, link: `${basePath}/functions/backcalls` },
        {
          text: text.functionStubs,
          link: `${basePath}/functions/function-stubs`,
        },
      ],
    },
    {
      text: group.controlFlow,
      collapsed: true,
      items: [
        {
          text: text.conditionals,
          link: `${basePath}/control-flow/conditionals`,
        },
        { text: text.forLoop, link: `${basePath}/control-flow/for-loop` },
        { text: text.whileLoop, link: `${basePath}/control-flow/while-loop` },
        {
          text: text.continueStatement,
          link: `${basePath}/control-flow/continue`,
        },
        { text: text.switch, link: `${basePath}/control-flow/switch` },
      ],
    },
    {
      text: group.dataStructures,
      collapsed: true,
      items: [
        {
          text: text.tableLiterals,
          link: `${basePath}/data-structures/table-literals`,
        },
        {
          text: text.comprehensions,
          link: `${basePath}/data-structures/comprehensions`,
        },
      ],
    },
    {
      text: group.objects,
      collapsed: true,
      items: [
        {
          text: text.objectOrientedProgramming,
          link: `${basePath}/objects/object-oriented-programming`,
        },
        {
          text: text.withStatement,
          link: `${basePath}/objects/with-statement`,
        },
      ],
    },
    {
      text: group.advancedFeatures,
      collapsed: true,
      items: [
        { text: text.macro, link: `${basePath}/advanced/macro` },
        { text: text.module, link: `${basePath}/advanced/module` },
        {
          text: text.lineDecorators,
          link: `${basePath}/advanced/line-decorators`,
        },
        { text: text.do, link: `${basePath}/advanced/do` },
        { text: text.try, link: `${basePath}/advanced/try` },
      ],
    },
    {
      text: group.reference,
      collapsed: true,
      items: [
        {
          text: text.yuescriptLibrary,
          link: `${basePath}/reference/the-yuescript-library`,
        },
        { text: text.licenseMit, link: `${basePath}/reference/license-mit` },
      ],
    },
  ];
}

export default defineConfig({
  title: "YueScript",
  description: "A language that compiles to Lua",
  base: "/",
  head: [
    ["meta", { name: "theme-color", content: "#b4ac8f" }],
    ["meta", { name: "apple-mobile-web-app-capable", content: "yes" }],
    [
      "meta",
      { name: "apple-mobile-web-app-status-bar-style", content: "black" },
    ],
    ["meta", { property: "og:title", content: "YueScript" }],
    [
      "meta",
      {
        property: "og:description",
        content: "A language that compiles to Lua",
      },
    ],
    ["meta", { property: "og:type", content: "website" }],
    ["meta", { property: "og:image", content: "/image/yuescript.png" }],
    [
      "meta",
      { property: "og:image:secure_url", content: "/image/yuescript.png" },
    ],
    ["meta", { property: "og:image:type", content: "image/png" }],
    ["meta", { property: "og:image:width", content: "1200" }],
    ["meta", { property: "og:image:height", content: "1200" }],
    [
      "link",
      {
        rel: "icon",
        href: "/image/favicon/favicon-16x16.png",
        sizes: "16x16",
        type: "image/png",
      },
    ],
    [
      "link",
      {
        rel: "icon",
        href: "/image/favicon/favicon-32x32.png",
        sizes: "32x32",
        type: "image/png",
      },
    ],
    [
      "link",
      {
        rel: "apple-touch-icon",
        href: "/image/favicon/apple-touch-icon.png",
        sizes: "180x180",
        type: "image/png",
      },
    ],
    [
      "link",
      {
        rel: "android-chrome",
        href: "/image/favicon/android-chrome-192x192.png",
        sizes: "192x192",
        type: "image/png",
      },
    ],
    [
      "link",
      {
        rel: "android-chrome",
        href: "/image/favicon/android-chrome-512x512.png",
        sizes: "512x512",
        type: "image/png",
      },
    ],
    ["script", {}, "window.global = window;"],
    [
      "script",
      {},
      `var Module = {
  onRuntimeInitialized: function() {
    window.yue = Module;
    window.dispatchEvent(new Event('yue:ready'));
  }
};
(function() {
  function loadStub() {
    window.yue = {
      version: function() { return '(build with: make wasm)'; },
      tolua: function() { return ['', 'Build yuescript wasm with: make wasm']; },
      exec: function() { return ''; }
    };
    window.dispatchEvent(new Event('yue:ready'));
  }
  var s = document.createElement('script');
  s.src = '/js/yuescript.js';
  s.async = true;
  document.head.appendChild(s);
})();`,
    ],
  ],
  vite: {
    publicDir: resolve(__dirname, "public"),
  },
  markdown: {
    languages: [yuescriptLanguage],
    theme: {
      light: lightPlus,
      dark: darkPlus,
    },
  },
  locales: {
    root: {
      label: "English",
      lang: "en-US",
      description: "A language that compiles to Lua",
      themeConfig: {
        nav: [
          { text: "Documentation", link: "/doc/" },
          { text: "Try yue!", link: "/try/" },
          { text: "GitHub", link: "https://github.com/IppClub/Yuescript" },
        ],
        sidebar: createSidebar("/doc", "en"),
      },
    },
    "id-id": {
      label: "Bahasa Indonesia",
      lang: "id-ID",
      description: "Bahasa yang dikompilasi ke Lua",
      themeConfig: {
        nav: [
          { text: "Dokumentasi", link: "/id-id/doc/" },
          { text: "Coba Yue!", link: "/id-id/try/" },
          { text: "GitHub", link: "https://github.com/IppClub/Yuescript" },
        ],
        sidebar: createSidebar("/id-id/doc", "idId"),
      },
    },
    de: {
      label: "Deutsch",
      lang: "de-DE",
      description: "Eine Sprache, die zu Lua kompiliert",
      themeConfig: {
        nav: [
          { text: "Dokumentation", link: "/de/doc/" },
          { text: "Yue ausprobieren!", link: "/de/try/" },
          { text: "GitHub", link: "https://github.com/IppClub/Yuescript" },
        ],
        sidebar: createSidebar("/de/doc", "de"),
      },
    },
    "pt-br": {
      label: "Português (Brasil)",
      lang: "pt-BR",
      description: "Uma linguagem que compila para Lua",
      themeConfig: {
        nav: [
          { text: "Documentação", link: "/pt-br/doc/" },
          { text: "Experimente Yue!", link: "/pt-br/try/" },
          { text: "GitHub", link: "https://github.com/IppClub/Yuescript" },
        ],
        sidebar: createSidebar("/pt-br/doc", "ptBr"),
      },
    },
    zh: {
      label: "简体中文",
      lang: "zh-CN",
      description: "一门编译到 Lua 的语言",
      themeConfig: {
        nav: [
          { text: "文档", link: "/zh/doc/" },
          { text: "试一试!", link: "/zh/try/" },
          { text: "GitHub", link: "https://github.com/IppClub/Yuescript" },
        ],
        sidebar: createSidebar("/zh/doc", "zh"),
      },
    },
  },
  themeConfig: {
    search: {
      provider: "local",
    },
  },
});
