import { readdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";

import { defineConfig } from "astro/config";

import starlight from "@astrojs/starlight";
import vue from "@astrojs/vue";

import { locales } from "./src/locales.mjs";

// The sidebar config runs before Astro loads content collections.
const allInOneLabels = Object.fromEntries(
  Object.values(locales).map(({ lang }) => [
    lang,
    JSON.parse(
      readFileSync(
        new URL(`./src/content/i18n/${lang}.json`, import.meta.url),
        "utf8",
      ),
    )["yue.allInOne"],
  ]),
);

const grammar = JSON.parse(
  readFileSync(
    new URL("./src/grammars/yuescript.tmLanguage.json", import.meta.url),
    "utf8",
  ),
);
// Keep links to VitePress's HTML files working after switching to clean routes.
const redirects = Object.fromEntries(
  readdirSync(new URL("./src/content/docs/", import.meta.url), {
    recursive: true,
  })
    .filter((file) => /\.mdx?$/.test(file) && !/(^|\/)index\.mdx?$/.test(file))
    .map((file) => {
      const slug = file.replace(/\.mdx?$/, "");
      return [`/${slug}.html`, `/${slug}/`];
    }),
);

export default defineConfig({
  site: "https://yuescript.org",
  base: process.env.DOCS_BASE ?? "/",
  trailingSlash: "always",
  redirects,
  integrations: [
    {
      name: "legacy-html-redirects",
      hooks: {
        "astro:build:done": ({ dir }) => {
          // Astro's directory format puts redirect files in *.html/index.html.
          // VitePress links need a file at the original *.html URL.
          for (const route of Object.keys(redirects)) {
            const output = new URL(route.slice(1), dir);
            const html = readFileSync(
              new URL(`${route.slice(1)}/index.html`, dir),
            );
            rmSync(output, { recursive: true });
            writeFileSync(output, html);
          }
        },
      },
    },
    vue(),
    starlight({
      disable404Route: true,
      title: "YueScript",
      logo: { src: "./public/image/yuescript.svg", alt: "" },
      description: "A delightful language that compiles to Lua",
      favicon: "/favicon.ico",
      locales,
      customCss: ["./src/styles/custom.css"],
      social: [
        {
          icon: "github",
          label: "GitHub",
          href: "https://github.com/IppClub/YueScript",
        },
        {
          icon: "discord",
          label: "Discord",
          href: "https://discord.gg/cRJ2VAm2NV",
        },
      ],
      sidebar: [
        {
          slug: "doc",
        },
        {
          slug: "try",
        },
        {
          label: "Getting Started",
          translations: {
            "id-ID": "Memulai",
            "de-DE": "Erste Schritte",
            "pt-BR": "Primeiros passos",
            "zh-CN": "起步",
          },
          items: [
            {
              slug: "doc/getting-started/introduction",
            },
            {
              slug: "doc/getting-started/installation",
            },
            {
              slug: "doc/getting-started/usage",
            },
          ],
        },
        {
          label: "Language Basics",
          translations: {
            "id-ID": "Dasar-dasar Bahasa",
            "de-DE": "Sprachgrundlagen",
            "pt-BR": "Fundamentos da linguagem",
            "zh-CN": "语言基础",
          },
          collapsed: true,
          items: [
            {
              slug: "doc/language-basics/whitespace",
            },
            {
              slug: "doc/language-basics/comment",
            },
            {
              slug: "doc/language-basics/literals",
            },
            {
              slug: "doc/language-basics/operator",
            },
            {
              slug: "doc/language-basics/attributes",
            },
            {
              slug: "doc/language-basics/module",
            },
          ],
        },
        {
          label: "Assignment",
          translations: {
            "id-ID": "Penugasan",
            "de-DE": "Zuweisung",
            "pt-BR": "Atribuição",
            "zh-CN": "赋值",
          },
          collapsed: true,
          items: [
            {
              slug: "doc/assignment/assignment",
            },
            {
              slug: "doc/assignment/destructuring-assignment",
            },
            {
              slug: "doc/assignment/if-assignment",
            },
            {
              slug: "doc/assignment/varargs-assignment",
            },
            {
              slug: "doc/assignment/the-using-clause-controlling-destructive-assignment",
            },
          ],
        },
        {
          label: "Functions",
          translations: {
            "id-ID": "Fungsi",
            "de-DE": "Funktionen",
            "pt-BR": "Funções",
            "zh-CN": "函数",
          },
          collapsed: true,
          items: [
            {
              slug: "doc/functions/function-literals",
            },
            {
              slug: "doc/functions/backcalls",
            },
            {
              slug: "doc/functions/function-stubs",
            },
          ],
        },
        {
          label: "Control Flow",
          translations: {
            "id-ID": "Alur Kontrol",
            "de-DE": "Kontrollfluss",
            "pt-BR": "Controle de fluxo",
            "zh-CN": "控制流",
          },
          collapsed: true,
          items: [
            {
              slug: "doc/control-flow/conditionals",
            },
            {
              slug: "doc/control-flow/for-loop",
            },
            {
              slug: "doc/control-flow/while-loop",
            },
            {
              slug: "doc/control-flow/continue",
            },
            {
              slug: "doc/control-flow/goto",
            },
            {
              slug: "doc/control-flow/switch",
            },
          ],
        },
        {
          label: "Data Structures",
          translations: {
            "id-ID": "Struktur Data",
            "de-DE": "Datenstrukturen",
            "pt-BR": "Estruturas de dados",
            "zh-CN": "数据结构",
          },
          collapsed: true,
          items: [
            {
              slug: "doc/data-structures/table-literals",
            },
            {
              slug: "doc/data-structures/comprehensions",
            },
          ],
        },
        {
          label: "Objects",
          translations: {
            "id-ID": "Objek",
            "de-DE": "Objekte",
            "pt-BR": "Objetos",
            "zh-CN": "面向对象",
          },
          collapsed: true,
          items: [
            {
              slug: "doc/objects/object-oriented-programming",
            },
            {
              slug: "doc/objects/with-statement",
            },
          ],
        },
        {
          label: "Advanced Features",
          translations: {
            "id-ID": "Fitur Lanjutan",
            "de-DE": "Erweiterte Funktionen",
            "pt-BR": "Recursos avançados",
            "zh-CN": "高级特性",
          },
          collapsed: true,
          items: [
            {
              slug: "doc/advanced/macro",
            },
            {
              slug: "doc/advanced/line-decorators",
            },
            {
              slug: "doc/advanced/do",
            },
            {
              slug: "doc/advanced/try",
            },
            {
              slug: "doc/advanced/the-yuescript-library",
            },
          ],
        },
        {
          label: "Extras",
          translations: {
            "id-ID": "Ekstra",
            "de-DE": "Extras",
            "pt-BR": "Extras",
            "zh-CN": "其他",
          },
          collapsed: true,
          items: [
            {
              slug: "doc/extras/mascot",
            },
            {
              slug: "doc/extras/license-mit",
            },
          ],
        },
        {
          label: allInOneLabels["en-US"],
          translations: allInOneLabels,
          link: "/all-in-one/",
        },
      ],
      expressiveCode: {
        shiki: { langs: [{ ...grammar, name: "yuescript", aliases: ["yue"] }] },
      },
      components: {
        Head: "./src/components/Head.astro",
        MarkdownContent: "./src/components/MarkdownContent.astro",
        Footer: "./src/components/CompilerFooter.astro",
        SocialIcons: "@astrojs/starlight/components/SocialIcons.astro",
      },
    }),
  ],
});
