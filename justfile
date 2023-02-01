_default:
  @just --choose

test:
	@pnpm exec nx run-many --parallel=10 --target=test

typecheck:
	@pnpm exec nx run-many --parallel=10 --target=typecheck

check:
  @just lint typecheck format-check test

lint:
	@pnpm exec nx run-many --parallel=10 --target=lint

lint-fix:
	@pnpm exec nx run-many --parallel=10 --target=lint:fix

format:
  @pnpm exec nx run-many --parallel=10 --target=format

format-check:
  @pnpm exec nx run-many --parallel=10 --target=format:check

nx-reset:
	@pnpm exec nx reset

clean: nx-reset
  @echo "more steps soon..."

