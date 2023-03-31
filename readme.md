## Friends Library Monorepo

### system dependencies required

- `node@18`
- `pnpm`
- `just`
- `swift@5.7`

### first install

after clone, cd into dir, then...

```bash
# install dependencies
pnpm install
# create some dirs that the cli depends on
mkdir -p en es audios apps/cli/src/cmd/audios/derived
# run the self-check script
just check
```

the following shell aliases are recommended:

```bash
alias fl="cd <repo-root>/apps/cli && pnpm ts-node src/app.ts ${@}"
alias fell="cd <repo-root>/apps/fell && pnpm ts-node src/app.ts ${@}"
```
