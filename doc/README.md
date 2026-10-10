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

Run `make wasm` from the repository root to build the browser compiler into
`public/js/`. Without those generated files, the compiler shows the build command.
