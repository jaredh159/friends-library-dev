#!/usr/bin/env node
// @ts-check
const fs = require(`fs`);
const { sync: glob } = require(`glob`);
const exec = require(`x-exec`).default;
const { c, log, green } = require(`x-chalk`);

let numSteps = 3;
let step = 1;

const convertDates = process.argv.includes(`--convert-dates-to-string`);
if (convertDates) {
  numSteps += 1;
}

const removeScalars = process.argv.includes(`--remove-custom-scalars`);
if (removeScalars) {
  numSteps += 1;
}

let success = true;

let endpoint = `http://127.0.0.1:8080/graphql`;
const endpointIndex = process.argv.indexOf(`--endpoint`);
if (endpointIndex !== -1) {
  endpoint = process.argv[endpointIndex + 1];
}

log(c`{gray ${step++}/${numSteps}} {magenta Downloading schema...}`);
success = exec.out(
  `apollo client:download-schema --endpoint=${endpoint} ./schema.graphql`,
  process.cwd(),
);

if (!success) {
  log(``);
  process.exit(1);
}

log(c`{gray ${step++}/${numSteps}} {magenta Downloading types...}`);
exec.exit(`rm -rf src/graphql`, process.cwd());
success = exec.out(
  [
    `npx apollo client:codegen`,
    ` --outputFlat`,
    ` --passthroughCustomScalars`,
    ` --localSchemaFile=schema.graphql`,
    ` --target=typescript`,
    ` --tagName=gql`,
    ` src/graphql`,
  ].join(``),
  process.cwd(),
);

if (!success) {
  log(``);
  process.exit(1);
}

log(c`{gray ${step++}/${numSteps}} {magenta Cleaning up...}`);
exec(`rm -f schema.graphql`, process.cwd());
exec(`just prettier`, process.cwd()); // working for evans, see justfile
exec(`pnpm eslint . -- --fix`, `${process.cwd()}/src/graphql`);

if (convertDates) {
  log(c`{gray ${step++}/${numSteps}} {magenta Converting dates to string...}`);
  convertDatesToString();
}

if (removeScalars) {
  log(c`{gray ${step++}/${numSteps}} {magenta Removing custom scalars...}`);
  convertCustomScalars();
}

green(`\nCodegen complete!\n`);
process.exit(0);

function convertDatesToString() {
  for (const file of generatedFiles()) {
    const content = fs.readFileSync(file, `utf-8`);
    fs.writeFileSync(file, content.replace(/: Date( \| null)?;/gm, `: string$1;`));
  }
}

function convertCustomScalars() {
  for (const file of generatedFiles()) {
    const content = fs.readFileSync(file, `utf-8`);
    fs.writeFileSync(
      file,
      content
        .replace(/: UUID( \| null)?;/gm, `: string$1;`)
        .replace(/: Int64( \| null)?;/gm, `: number$1;`),
    );
  }
}

function generatedFiles() {
  const files = glob(`${process.cwd()}/src/graphql/*.ts`);
  if (files.length === 0) {
    process.stderr.write(`No graphql files found for post-processing\n`);
    process.stderr.write(`Did you run the script from outside the project root?\n`);
    process.exit(1);
  }
  return files;
}
