import { z } from "astro/zod";
import { defineCollection } from "astro:content";
import { docsLoader, i18nLoader } from "@astrojs/starlight/loaders";
import { docsSchema, i18nSchema } from "@astrojs/starlight/schema";

export const collections = {
  docs: defineCollection({ loader: docsLoader(), schema: docsSchema() }),
  i18n: defineCollection({
    loader: i18nLoader(),
    schema: i18nSchema({
      extend: z.object({
        "404.text": z.string().optional(),
        "yue.allInOne": z.string().optional(),
        "yue.try": z.string().optional(),
        "yue.404.home": z.string().optional(),
        "yue.compiler.title": z.string().optional(),
        "yue.compiler.close": z.string().optional(),
        "yue.compiler.loading": z.string().optional(),
        "yue.compiler.loadError": z.string().optional(),
        "yue.compiler.modalLoadError": z.string().optional(),
        "yue.compiler.buildRuntime": z.string().optional(),
        "yue.compiler.compile": z.string().optional(),
        "yue.compiler.run": z.string().optional(),
        "yue.compiler.programOutput": z.string().optional(),
        "yue.compiler.source": z.string().optional(),
        "yue.compiler.luaOutput": z.string().optional(),
        "yue.compiler.finished": z.string().optional(),
        "yue.compiler.complete": z.string().optional(),
        "yue.compiler.failed": z.string().optional(),
      }),
    }),
  }),
};
