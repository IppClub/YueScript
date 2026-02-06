import { readFileSync } from 'fs';
import {
  dirname,
  resolve,
} from 'path';
import { fileURLToPath } from 'url';
import { defineConfig } from 'vitepress';

import darkPlus from '@shikijs/themes/dark-plus';
import lightPlus from '@shikijs/themes/light-plus';

const __dirname = dirname(fileURLToPath(import.meta.url))
const yuescriptGrammarPath = resolve(__dirname, 'grammars/yuescript.tmLanguage.json')
const yuescriptGrammar = JSON.parse(readFileSync(yuescriptGrammarPath, 'utf-8'))
const yuescriptLanguage = {
  ...yuescriptGrammar,
  name: 'yuescript',
  scopeName: 'source.yuescript',
  aliases: ['yue'],
}

// Generate sidebar configuration function
function createSidebar(basePath: string, zh: boolean) {
  return [
    {
      text: zh ? '起步' : 'Getting Started',
      items: [
        { text: zh ? '介绍' : 'Introduction', link: `${basePath}/getting-started/introduction` },
        { text: zh ? '安装' : 'Installation', link: `${basePath}/getting-started/installation` },
        { text: zh ? '使用方法' : 'Usage', link: `${basePath}/getting-started/usage` },
      ]
    },
    {
      text: zh ? '语言基础' : 'Language Basics',
      collapsed: true,
      items: [
        { text: zh ? '空白' : 'Whitespace', link: `${basePath}/language-basics/whitespace` },
        { text: zh ? '注释' : 'Comment', link: `${basePath}/language-basics/comment` },
        { text: zh ? '字面量' : 'Literals', link: `${basePath}/language-basics/literals` },
        { text: zh ? '操作符' : 'Operator', link: `${basePath}/language-basics/operator` },
        { text: zh ? '属性' : 'Attributes', link: `${basePath}/language-basics/attributes` },
      ]
    },
    {
      text: zh ? '赋值' : 'Assignment',
      collapsed: true,
      items: [
        { text: zh ? '赋值' : 'Assignment', link: `${basePath}/assignment/assignment` },
        { text: zh ? '解构赋值' : 'Destructuring Assignment', link: `${basePath}/assignment/destructuring-assignment` },
        { text: zh ? 'if 赋值' : 'If Assignment', link: `${basePath}/assignment/if-assignment` },
        { text: zh ? '可变参数赋值' : 'Varargs Assignment', link: `${basePath}/assignment/varargs-assignment` },
        { text: zh ? '使用 using 语句' : 'The Using Clause', link: `${basePath}/assignment/the-using-clause-controlling-destructive-assignment` },
      ]
    },
    {
      text: zh ? '函数' : 'Functions',
      collapsed: true,
      items: [
        { text: zh ? '函数字面量' : 'Function Literals', link: `${basePath}/functions/function-literals` },
        { text: zh ? '反向回调' : 'Backcalls', link: `${basePath}/functions/backcalls` },
        { text: zh ? '函数存根' : 'Function Stubs', link: `${basePath}/functions/function-stubs` },
      ]
    },
    {
      text: zh ? '控制流' : 'Control Flow',
      collapsed: true,
      items: [
        { text: zh ? '条件语句' : 'Conditionals', link: `${basePath}/control-flow/conditionals` },
        { text: zh ? 'for 循环' : 'For Loop', link: `${basePath}/control-flow/for-loop` },
        { text: zh ? 'while 循环' : 'While Loop', link: `${basePath}/control-flow/while-loop` },
        { text: zh ? 'continue 语句' : 'Continue Statement', link: `${basePath}/control-flow/continue` },
        { text: zh ? 'switch 语句' : 'Switch', link: `${basePath}/control-flow/switch` },
      ]
    },
    {
      text: zh ? '数据结构' : 'Data Structures',
      collapsed: true,
      items: [
        { text: zh ? '表格字面量' : 'Table Literals', link: `${basePath}/data-structures/table-literals` },
        { text: zh ? '推导式' : 'Comprehensions', link: `${basePath}/data-structures/comprehensions` },
      ]
    },
    {
      text: zh ? '面向对象' : 'Objects',
      collapsed: true,
      items: [
        { text: zh ? '面向对象编程' : 'Object Oriented Programming', link: `${basePath}/objects/object-oriented-programming` },
        { text: zh ? 'with 语句' : 'With Statement', link: `${basePath}/objects/with-statement` },
      ]
    },
    {
      text: zh ? '高级特性' : 'Advanced Features',
      collapsed: true,
      items: [
        { text: zh ? '宏' : 'Macro', link: `${basePath}/advanced/macro` },
        { text: zh ? '模块' : 'Module', link: `${basePath}/advanced/module` },
        { text: zh ? '代码行修饰符' : 'Line Decorators', link: `${basePath}/advanced/line-decorators` },
        { text: zh ? 'do 语句' : 'Do', link: `${basePath}/advanced/do` },
        { text: zh ? '错误处理' : 'Try', link: `${basePath}/advanced/try` },
      ]
    },
    {
      text: zh ? '参考' : 'Reference',
      collapsed: true,
      items: [
        { text: zh ? '月之脚本语言库' : 'The YueScript Library', link: `${basePath}/reference/the-yuescript-library` },
        { text: zh ? 'MIT 许可证' : 'License: MIT', link: `${basePath}/reference/license-mit` },
      ]
    },
  ]
}

export default defineConfig({
  title: 'YueScript',
  description: 'A language that compiles to Lua',
  base: '/',
  head: [
    ['meta', { name: 'theme-color', content: '#b4ac8f' }],
    ['meta', { name: 'apple-mobile-web-app-capable', content: 'yes' }],
    ['meta', { name: 'apple-mobile-web-app-status-bar-style', content: 'black' }],
    ['meta', { property: 'og:title', content: 'YueScript' }],
    ['meta', { property: 'og:description', content: 'A language that compiles to Lua' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:image', content: '/image/yuescript.png' }],
    ['meta', { property: 'og:image:secure_url', content: '/image/yuescript.png' }],
    ['meta', { property: 'og:image:type', content: 'image/png' }],
    ['meta', { property: 'og:image:width', content: '1200' }],
    ['meta', { property: 'og:image:height', content: '1200' }],
    ['link', { rel: 'icon', href: '/image/favicon/favicon-16x16.png', sizes: '16x16', type: 'image/png' }],
    ['link', { rel: 'icon', href: '/image/favicon/favicon-32x32.png', sizes: '32x32', type: 'image/png' }],
    ['link', { rel: 'apple-touch-icon', href: '/image/favicon/apple-touch-icon.png', sizes: '180x180', type: 'image/png' }],
    ['link', { rel: 'android-chrome', href: '/image/favicon/android-chrome-192x192.png', sizes: '192x192', type: 'image/png' }],
    ['link', { rel: 'android-chrome', href: '/image/favicon/android-chrome-512x512.png', sizes: '512x512', type: 'image/png' }],
    ['script', {}, 'window.global = window;'],
    [
      'script',
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
})();`
    ]
  ],
  vite: {
    publicDir: resolve(__dirname, 'public'),
  },
  markdown: {
    languages: [
      yuescriptLanguage,
    ],
    theme: {
      light: lightPlus,
      dark: darkPlus,
    },
  },
  locales: {
    root: {
      label: 'English',
      lang: 'en-US',
      description: 'A language that compiles to Lua',
      themeConfig: {
        nav: [
          { text: 'Documentation', link: '/doc/' },
          { text: 'Try yue!', link: '/try/' },
          { text: 'GitHub', link: 'https://github.com/IppClub/Yuescript' }
        ],
        sidebar: createSidebar('/doc', false),
      }
    },
    zh: {
      label: '简体中文',
      lang: 'zh-CN',
      description: '一门编译到 Lua 的语言',
      themeConfig: {
        nav: [
          { text: '文档', link: '/zh/doc/' },
          { text: '试一试!', link: '/zh/try/' },
          { text: 'GitHub', link: 'https://github.com/IppClub/Yuescript' }
        ],
        sidebar: createSidebar('/zh/doc', true),
      }
    }
  },
  themeConfig: {
    search: {
      provider: 'local'
    }
  }
})
