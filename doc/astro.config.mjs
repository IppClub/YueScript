import { readdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";

import { defineConfig } from "astro/config";

import starlight from "@astrojs/starlight";
import vue from "@astrojs/vue";
import ogImages, { element, Renderer } from "@alfanjauhari/astro-og-images";

import { locales } from "./src/locales.mjs";

const ogRenderer = new Renderer();
for (const [name, font] of [
  [
    "Noto Serif",
    "@fontsource/noto-serif/files/noto-serif-latin-700-normal.woff2",
  ],
  [
    "Noto Serif",
    "@fontsource/noto-serif/files/noto-serif-latin-ext-700-normal.woff2",
  ],
  [
    "Noto Serif SC",
    "@fontsource/noto-serif-sc/files/noto-serif-sc-chinese-simplified-700-normal.woff2",
  ],
  ["Noto Sans", "@fontsource/noto-sans/files/noto-sans-latin-400-normal.woff2"],
  [
    "Noto Sans",
    "@fontsource/noto-sans/files/noto-sans-latin-ext-400-normal.woff2",
  ],
  [
    "Noto Sans SC",
    "@fontsource/noto-sans-sc/files/noto-sans-sc-chinese-simplified-400-normal.woff2",
  ],
]) {
  await ogRenderer.registerFont({
    name,
    data: readFileSync(new URL(import.meta.resolve(font))),
  });
}
const ogMascot = `data:image/png;base64,${readFileSync(
  new URL(
    "./public/image/mascot/electrichearts_20260211A_yuescript_xiaoyu.png",
    import.meta.url,
  ),
).toString("base64")}`;
const ogLogo = `data:image/svg+xml;base64,${Buffer.from(
  readFileSync(
    new URL("./public/image/yuescript.svg", import.meta.url),
    "utf8",
  ).replaceAll("fill:#b4ac8f", "fill:#ffffff"),
).toString("base64")}`;

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
    ogImages({
      format: "png",
      width: 1200,
      height: 630,
      renderer: ogRenderer,
      emoji: "from-font",
      render: ({ title, description }) =>
        element(
          "div",
          {
            tw: "flex h-full w-full flex-col bg-[#0b0e14] p-16 text-[#f1f5f9]",
            style: { fontFamily: "Noto Serif, Noto Serif SC", fontWeight: 700 },
          },
          element(
            "div",
            {
              tw: "flex items-center gap-3 text-[32px] leading-[1.2] text-[#d4ceb8]",
            },
            element("img", { src: ogLogo, width: 40, height: 34 }),
            "YueScript",
          ),
          element(
            "div",
            { tw: "flex flex-1 items-center gap-12" },
            element(
              "div",
              { tw: "flex flex-1 flex-col gap-6" },
              element(
                "div",
                {
                  tw: "leading-[1.2] text-[#d4ceb8]",
                  style: { fontSize: title.length > 60 ? 48 : 64 },
                },
                title,
              ),
              description &&
                element(
                  "div",
                  {
                    tw: "text-[26px] leading-[1.4] text-[#e2e8f0]",
                    style: {
                      fontFamily: "Noto Sans, Noto Sans SC",
                      fontWeight: 400,
                    },
                  },
                  description,
                ),
            ),
            element("img", { src: ogMascot, width: 250, height: 350 }),
          ),
          element("div", { tw: "text-[22px] text-[#f9c749]" }, "yuescript.org"),
        ),
    }),
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
