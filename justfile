@_default:
  just --choose

@typecheck:
	pnpm exec nx run-many --parallel=10 --target=typecheck
