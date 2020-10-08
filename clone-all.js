#!/usr/bin/env node
const cloneAll = require(`./dist/clone`).default;

const path = process.argv[2];
if (!path) {
  console.error(`missing path param -- \`clone-all <path>\ [--delete-existing]\``);
  process.exit(1);
}

cloneAll(path, process.argv.includes(`--delete-existing`))
  .then(() => process.exit(0))
  .catch(() => process.exit(1));
