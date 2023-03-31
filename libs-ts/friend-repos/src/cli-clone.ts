import cloneAll from './clone';

const path = process.argv[2];
if (!path) {
  process.stderr.write(`usage: \`clone-all <path> [--delete-existing]\`\n`);
  process.exit(1);
}

cloneAll(path, process.argv.includes(`--delete-existing`))
  .then(() => process.exit(0))
  .catch(() => process.exit(1));
