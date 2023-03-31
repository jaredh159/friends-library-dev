## Todo

- [ ] convert `getTailwindConfig` fn to a real preset, try to fix `evans/../color.ts`
      without breaking storybook and admin build
- [ ] update/consolidate versions of `tailwindcss`
- [ ] api: update duet to gertie version, w/out codegen
- [ ] api: deal with todos in `converge-todo.md`
- [ ] native: add just scripts to launch ios emulators of various sizes
- [ ] native: transfer android build scripts from old repo package.json
- [ ] native: restore storybook (use old repo files)
- [ ] native: app shouldn't allow non-null assertions
- [ ] native: i'm not sure if splash screen is working for android
- [ ] remove fs-extra package from cli (elsewhere?)
- [ ] look into cover-component prepack/postpack web/node optimizations...
- [ ] examine, update, and unify dependencies
- [ ] evans > astro/next
- [ ] update tailwind
- [ ] update cloud aws-sdk dep
- [ ] bring x-ts-utils into monorepo? (fix esm/export issue)
- [ ] experiment with ts: `exactOptionalPropertyTypes: true`
- [ ] experiment with ts: `esModuleInterop: false`

## Done

- [√] cli cover:watch task for cover-web-app (search `echo node`)
- [√] break apart ci to speed up
- [√] api: pnpm install, get deploy-ing correctly
- [√] remove `nodegit` dep (with `librbk5` dep install in ci.yml)
- [V] rebuild storybook
- [√] convert cover-web-app from parcel to vite
- [√] convert admin from snowpack to vite
- [√] convert cover-web-app from parcel to vite
- [√] after `evans` imported, finish doing `apps/poster` (relies on evans)
