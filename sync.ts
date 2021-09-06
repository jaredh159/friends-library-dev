import { gray, green, magenta } from 'x-chalk';
import exec from 'x-exec';

magenta(`\nStarting db sync process\n`);
exec.exit(`rm -f ./sync.sql.gz ./sync.sql`);
gray(`  • Dumping remote database...`);
// -Z 9 enables maximum compression for pg_dump
exec.exit(`ssh fql "pg_dump flp --file sync.sql.gz -Z 9"`);
gray(`  • Downloading gzipped dump...`);
exec.exit(`scp fql:~/sync.sql.gz .`);
gray(`  • Deleting remote dump file...`);
exec.exit(`ssh fql "rm sync.sql.gz"`);
gray(`  • Unzipping local dump file...`);
exec.exit(`gunzip ./sync.sql.gz`);
gray(`  • Killing any running instances of Postico...`);
exec(`killall postico`);
gray(`  • Dropping and re-creating local flp database...`);
exec.exit(`dropdb flp`);
exec.exit(`createdb flp`);
gray(`  • Importing records...`);
exec.exit(`psql -d flp -f ./sync.sql`);
gray(`  • Cleaning up...`);
exec.exit(`rm -f ./sync.sql.gz ./sync.sql`);
green(`\nSync complete!\n`);
