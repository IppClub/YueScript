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
const moonscriptGrammarPath = resolve(__dirname, 'grammars/moonscript.tmLanguage.json')
const moonscriptGrammar = JSON.parse(readFileSync(moonscriptGrammarPath, 'utf-8'))
const moonscriptLanguage = {
  ...moonscriptGrammar,
  name: 'moonscript',
  scopeName: 'source.moonscript',
  aliases: ['yue', 'yuescript', 'moon'],
}

// Generate sidebar configuration function
function createSidebar(basePath: string, zh: boolean) {
  return [
    {
      text: zh ? '介绍' : 'Introduction',
      link: `${basePath}/introduction`,
    },
    {
      text: zh ? '安装' : 'Installation',
      link: `${basePath}/installation`,
    },
    {
      text: zh ? '使用方法' : 'Usage',
      link: `${basePath}/usage`,
    },
    {
      text: zh ? '宏' : 'Macro',
      link: `${basePath}/macro`,
    },
    {
      text: zh ? '操作符' : 'Operator',
      link: `${basePath}/operator`,
    },
    {
      text: zh ? '模块' : 'Module',
      link: `${basePath}/module`,
    },
    {
      text: zh ? '赋值' : 'Assignment',
      link: `${basePath}/assignment`,
    },
    {
      text: zh ? '解构赋值' : 'Destructuring Assignment',
      link: `${basePath}/destructuring-assignment`,
    },
    {
      text: zh ? 'if 赋值' : 'If Assignment',
      link: `${basePath}/if-assignment`,
    },
    {
      text: zh ? '可变参数赋值' : 'Varargs Assignment',
      link: `${basePath}/varargs-assignment`,
    },
    {
      text: zh ? '空白' : 'Whitespace',
      link: `${basePath}/whitespace`,
    },
    {
      text: zh ? '注释' : 'Comment',
      link: `${basePath}/comment`,
    },
    {
      text: zh ? '错误处理' : 'Try',
      link: `${basePath}/try`,
    },
    {
      text: zh ? '属性' : 'Attributes',
      link: `${basePath}/attributes`,
    },
    {
      text: zh ? '字面量' : 'Literals',
      link: `${basePath}/literals`,
    },
    {
      text: zh ? '函数字面量' : 'Function Literals',
      link: `${basePath}/function-literals`,
    },
    {
      text: zh ? '反向回调' : 'Backcalls',
      link: `${basePath}/backcalls`,
    },
    {
      text: zh ? '表格字面量' : 'Table Literals',
      link: `${basePath}/table-literals`,
    },
    {
      text: zh ? '推导式' : 'Comprehensions',
      link: `${basePath}/comprehensions`,
    },
    {
      text: zh ? 'for 循环' : 'For Loop',
      link: `${basePath}/for-loop`,
    },
    {
      text: zh ? 'while 循环' : 'While Loop',
      link: `${basePath}/while-loop`,
    },
    {
      text: zh ? 'continue 语句' : 'Continue Statement',
      link: `${basePath}/continue`,
    },
    {
      text: zh ? '条件语句' : 'Conditionals',
      link: `${basePath}/conditionals`,
    },
    {
      text: zh ? '代码行修饰符' : 'Line Decorators',
      link: `${basePath}/line-decorators`,
    },
    {
      text: zh ? 'switch 语句' : 'Switch',
      link: `${basePath}/switch`,
    },
    {
      text: zh ? '面向对象编程' : 'Object Oriented Programming',
      link: `${basePath}/object-oriented-programming`,
    },
    {
      text: zh ? 'with 语句' : 'With Statement',
      link: `${basePath}/with-statement`,
    },
    {
      text: zh ? 'do 语句' : 'Do',
      link: `${basePath}/do`,
    },
    {
      text: zh ? '函数存根' : 'Function Stubs',
      link: `${basePath}/function-stubs`,
    },
    {
      text: zh ? '使用 using 语句：防止破坏性赋值' : 'The Using Clause; Controlling Destructive Assignment',
      link: `${basePath}/the-using-clause-controlling-destructive-assignment`,
    },
    {
      text: zh ? '月之脚本语言库' : 'The YueScript Library',
      link: `${basePath}/the-yuescript-library`,
    },
    {
      text: zh ? 'MIT 许可证' : 'License: MIT',
      link: `${basePath}/license-mit`,
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
      moonscriptLanguage,
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
          { text: 'Document', link: '/doc/' },
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
