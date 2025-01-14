var documenterSearchIndex = {"docs":
[{"location":"","page":"Documentation","title":"Documentation","text":"CurrentModule = TinyHugeNumbers","category":"page"},{"location":"#TinyHugeNumbers","page":"Documentation","title":"TinyHugeNumbers","text":"","category":"section"},{"location":"","page":"Documentation","title":"Documentation","text":"The TinyHugeNumbers package exports tiny and huge objects to represent tiny and huge numbers. These objects aren't really numbers and behave differently depending on the context. They do support any operation that is defined for Real numbers. For more info see Julia's documentation about promotion.","category":"page"},{"location":"","page":"Documentation","title":"Documentation","text":"tiny \nhuge","category":"page"},{"location":"#TinyHugeNumbers.tiny","page":"Documentation","title":"TinyHugeNumbers.tiny","text":"tiny\n\ntiny represents a (wow!) tiny number that can be used in a various computations without unnecessary type promotions.\n\ntiny is defined as:\n\n1.0f-6 for Float32\n1e-12 for Float64\nbig\"1e-24\" for BigFloat\n10 * eps(F) for an arbitrary type F <: AbstractFloat\n\nExample\n\njulia> tiny\ntiny\n\njulia> 1 + tiny\n1.000000000001\n\njulia> tiny + 1\n1.000000000001\n\njulia> 1f0 + tiny\n1.000001f0\n\njulia> big\"1.0\" + tiny\n1.000000000000000000000001\n\njulia> big\"1\" + tiny\n1.000000000000000000000001\n\nSee also: huge\n\n\n\n\n\n","category":"constant"},{"location":"#TinyHugeNumbers.huge","page":"Documentation","title":"TinyHugeNumbers.huge","text":"huge\n\nhuge represents a (wow!) huge number that can be used in a various computations without unnecessary type promotions.\n\nhuge is defined as:\n\n1.0f+6 for Float32\n1e+12 for Float64\nbig\"1e+24\" for BigFloat\ninv(tiny(F)) for an arbitrary type F <: AbstractFloat\n\nExample\n\njulia> huge\nhuge\n\njulia> 1 + huge\n1.000000000001e12\n\njulia> huge + 1\n1.000000000001e12\n\njulia> 1f0 + huge\n1.000001f6\n\njulia> big\"1.0\" + huge\n1.000000000000000000000001e+24\n\njulia> big\"1\" + huge\n1.000000000000000000000001e+24\n\nSee also: tiny\n\n\n\n\n\n","category":"constant"}]
}