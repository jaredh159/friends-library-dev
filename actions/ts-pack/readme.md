# action-ts-pack

_Github actions written in typescript, with some shared libs and bundling with
`@vercel/ncc`._

## `npm start`

Starts `ncc` in watch mode for one or all sub-actions:

```bash
# develop the `api-status` action
$ pnpm start api-status

# tab-complete-able path to dir works too:
$ pnpm start actions/api-status/

# or, do all at once:
$ pnpm start all
# same as ^
$ pnpm start
```

## `pnpm bundle`

Create production bundled javascript for one or all sub-actions:

```bash
# bundle just the `api-status` action
$ pnpm bundle api-status

# tab-complete-able path to dir works too:
$ pnpm bundle actions/api-status/

# or, do all at once:
$ pnpm bundle all
# same as ^
$ pnpm bundle
```
