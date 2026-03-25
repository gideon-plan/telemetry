# Choice/Life Adoption Plan: otel

## Summary

- **Error type**: `OtelError` defined in lattice.nim -- move to `context.nim`
- **Files to modify**: 3 + re-export module
- **Result sites**: 9
- **Life**: Not applicable

## Steps

1. Delete `src/otel/lattice.nim`
2. Move `OtelError* = object of CatchableError` to `src/otel/context.nim`
3. Add `requires "basis >= 0.1.0"` to nimble
4. In every file importing lattice:
   - Replace `import.*lattice` with `import basis/code/choice`
   - Replace `Result[T, E].good(v)` with `good(v)`
   - Replace `Result[T, E].bad(e[])` with `bad[T]("otel", e.msg)`
   - Replace `Result[T, E].bad(OtelError(msg: "x"))` with `bad[T]("otel", "x")`
   - Replace return type `Result[T, OtelError]` with `Choice[T]`
5. Update re-export: `export lattice` -> `export choice`
6. Update tests
