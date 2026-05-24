# Repository Guidelines

PropMgmt-Agent is an AI-powered property management assistant built with Astro 6, React 19, TypeScript 5, Supabase, and deployed on Cloudflare Workers.

## Hard Rules

- SSR only — `output: "server"` in `@astro.config.mjs`. Every API route must export `const prerender = false`.
- Server secrets use `astro:env/server` — never import secrets client-side or hardcode them.
- Auth uses `@supabase/ssr` with cookie-based sessions — do not use `@supabase/auth-helpers` or client-side token storage.
- Use `cn()` from `@src/lib/utils` for conditional classes — never concatenate Tailwind classes manually.
- React is only for interactive islands — static content uses Astro components.
- No Next.js directives (`"use client"`, `"use server"`).

## Project Structure

- `src/components/` — Astro and React components; UI primitives in `ui/` (shadcn/ui, "new-york" style)
- `src/components/hooks/` — extracted React hooks
- `src/lib/` and `src/lib/services/` — shared helpers and service logic
- `src/pages/` — file-based routing (Astro pages and API routes)
- `src/types.ts` — shared TypeScript types
- `supabase/migrations/` — SQL migrations (`YYYYMMDDHHmmss_short_description.sql`), each with granular RLS policies
- `supabase/config.toml` — local Supabase stack config
- Path alias: `@/*` maps to `./src/*`

## Build, Test, and Development

- `npm run dev` — start Astro dev server
- `npm run build` — production build (runs `astro sync` first in CI)
- `npm run lint` — ESLint check; `npm run lint:fix` to auto-fix
- `npm run format` — Prettier (120 char width, Astro + Tailwind plugins)

Node version: 22.14.0 (see `@.nvmrc`). Copy `@.env.example` to `.env` for local dev, `.dev.vars` for Cloudflare.

## Coding Style

- TypeScript strict mode (`@tsconfig.json` extends `astro/tsconfigs/strict`)
- ESLint 9 with `typescript-eslint` strict + stylistic rules; React Compiler plugin enforced as error
- Husky + lint-staged run lint on pre-commit for TS, Astro, JSON, CSS files
- API routes export uppercase handlers (`GET`, `POST`) with zod request validation

## CI Gate

GitHub Actions (`@.github/workflows/ci.yml`): lint, `astro sync`, build. No test suite configured yet.

## Commit Conventions

Use imperative mood with descriptive scope (e.g. `Add property dashboard layout`).

For deeper conventions and architectural details, see `@CLAUDE.md`.
