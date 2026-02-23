import DefaultTheme from "vitepress/theme";
import type { Theme } from "vitepress";
import { h } from "vue";
import { useData, withBase } from "vitepress";
import "./custom.css";

// @ts-ignore
import CompilerModal from "./components/CompilerModal.vue";
// @ts-ignore
import HomeFooter from "./components/HomeFooter.vue";
// @ts-ignore
import YueCompiler from "./components/YueCompiler.vue";
// @ts-ignore
import YueDisplay from "./components/YueDisplay.vue";

const theme: Theme = {
  extends: DefaultTheme,
  Layout: () => {
    const { frontmatter } = useData();

    return h(DefaultTheme.Layout, null, {
      "layout-bottom": () => [h(HomeFooter), h(CompilerModal)],
      "home-hero-image": () => {
        const fm = frontmatter.value;
        if (fm?.hero?.image?.src) {
          const img = h("img", {
            src: withBase(fm.hero.image.src),
            alt: fm.hero.image.alt || "",
            class: "VPImage",
            style: "max-width: 100%; max-height: 100%; object-fit: contain;",
          });

          if (fm.hero.image.link) {
            return h(
              "a",
              {
                href: withBase(fm.hero.image.link),
                class: "image-src",
                style:
                  "display: flex; justify-content: center; align-items: center;",
              },
              [img],
            );
          }

          return h(
            "div",
            {
              class: "image-src",
              style:
                "display: flex; justify-content: center; align-items: center;",
            },
            [img],
          );
        }
        return null;
      },
    });
  },
  enhanceApp({ app }) {
    app.component("CompilerModal", CompilerModal);
    app.component("YueCompiler", YueCompiler);
    app.component("YueDisplay", YueDisplay);
  },
};

export default theme;
