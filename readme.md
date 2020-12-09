# action-ts-pack

_Github actions written in typescript, with some shared libs and bundling with
`@vercel/ncc`._

## `npm start`

Starts `ncc` in watch mode for one or all sub-actions:

```bash
# develop the `print-jobs` action
$ npm start print-jobs

# tab-complete-able path to dir works too:
$ npm start actions/print-jobs/

# or, do all at once:
$ npm start all
# same as ^
$ npm start
```

## `npm run build`

Create production bundled javascript for one or all sub-actions:

```bash
# build just the `print-jobs` action
$ npm run build print-jobs

# tab-complete-able path to dir works too:
$ npm run build actions/print-jobs/

# or, do all at once:
$ npm run build all
# same as ^
$ npm run build
```
