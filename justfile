_default:
  @just --choose

test:
	@pnpm exec nx run-many --parallel=10 --target=test

typecheck:
	@pnpm exec nx run-many --parallel=10 --target=typecheck

lint:
	@pnpm exec nx run-many --parallel=10 --target=lint

lint-fix:
	@pnpm exec nx run-many --parallel=10 --target=lint:fix

nx-reset:
	@pnpm exec nx reset

clean: nx-reset
  @echo "more steps soon..."

