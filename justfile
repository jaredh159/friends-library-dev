@_default:
  just --choose

@test:
	pnpm exec nx run-many --parallel=10 --target=test

@typecheck:
	pnpm exec nx run-many --parallel=10 --target=typecheck
