# YueScript

> YueScript Documentation

## Development

```bash
pnpm install
pnpm run dev
pnpm run check
pnpm run build
pnpm run test:docs
pnpm run preview
```

Documentation lives in `src/content/docs/`. Each Markdown or MDX file creates
its existing route. Each language has an aggregate page, at `/all-in-one/` for
English and `/<locale>/all-in-one/` for translations. Each page renders that
language's collection, excluding splash home pages, in `sidebar.order` order,
with the entry ID as a tie-breaker.
Each section and heading has a unique anchor.

The site uses [Starlight](https://starlight.astro.build/)'s default theme.
Navigation and locale settings are in `astro.config.mjs`. Set `DOCS_BASE` when
deploying beneath a subpath. Production files are written to `dist/`.
Body text and controls use Fontsource Noto Sans and Noto Sans SC; headings use Noto Serif.

[`@alfanjauhari/astro-og-images`](https://github.com/alfanjauhari/alfanjauhari.com/tree/main/packages/astro-og-images)
generates a 1200 × 630 PNG preview beside each page during the build. The shared
head component adds Open Graph and Twitter image metadata. Previews use the page
title and description, the logo, and Xiaoyu. Titles use Noto Serif, and descriptions
use Noto Sans. Both families include Chinese fonts.
The pnpm patch keeps image path checks and 404 image URLs compatible with `DOCS_BASE`.

Run `make wasm` from the repository root to build the browser compiler into
`public/js/`. Without those generated files, the compiler shows the build command.
