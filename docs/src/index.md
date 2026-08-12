```@meta
CurrentModule = TinyHugeNumbers
```

# TinyHugeNumbers

The `TinyHugeNumbers` package exports `tiny` and `huge` objects to represent tiny and huge numbers. These objects aren't really numbers — they are *sentinels* that promote to a concrete floating-point value before being used, which keeps computations free of unnecessary type promotions.

Supported operations are arithmetic (`+`, `-`, `*`, `/`), comparisons (`<`, `<=`, `>`, `>=`, `==`, including between `tiny` and `huge` themselves), `clamp`, and promotion/conversion to any `AbstractFloat`. Generic `Real` fallbacks such as `abs`, `sqrt`, `log`, `exp`, the trigonometric functions, `^`, `zero`, `one`, and `float` are **not** defined directly on `tiny`/`huge` — convert to a concrete float first (e.g. `sqrt(tiny(Float64))`). For more info see Julia's documentation about promotion.

```@docs
tiny 
huge
```
