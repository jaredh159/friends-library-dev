_default:
  @just --choose

# app dev

admin:
  @pnpm --filter admin start

# code quality

check:
  @just nx-run-many lint,format-check,typecheck,test,build,compile

test:
  @just nx-run-many test

compile:
  @pnpm nx-run-many compile

#  @just run compile in @friends-library/theme

build:
	@just nx-run-many build

typecheck:
	@just nx-run-many typecheck

lint:
	@just nx-run-many lint

lint-fix:
	@just nx-run-many lint:fix

format:
  @just nx-run-many format

format-check:
  @just nx-run-many format:check

nx-reset:
	@pnpm exec nx reset

clean: nx-reset
  @rm -rf apps/admin/node_modules/.vite

# helpers

[private]
nx-run-many targets:
  @pnpm exec nx run-many --parallel=10 --targets={{targets}}
