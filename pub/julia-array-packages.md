# Julia array packages

* NamedDims: names for each dimension so things like: A[y=1, x=2] work
* IndexedDim: indexed elements for each axis, so things like A[Date(2018,10,1)]  works
* LabelledArrays: Names for elements, so that A[1]=a.first  can work (like NamedTuples are to Tuples, where can acess by name or index)
* AxisArrays: conceptually like NamedDims + IndexedDims but always need to do both, and nothing I want to do can be written cleanly.
* AxisRanges.jl: a bit like IndexedDims, but A[i] always means indexing i::Int (as for every AbstractArray) while A(d) means lookup (whether range has eltype d::Date, or d::Int). And doesn’t assert that the ranges must be anything beyond `AbstractVector`s, rather than (IIRC) tying to AcceleratedArrays. Similarly uses NamedDims for names, composition not inheritance.
* DimensionalData.jl: closer to a straight replacement for AxisArrays, more abstract types to allow inheritance? Dimensions similarly have a type, not just a Symbol alla NamedDims/NamedTuple. (Also actually in use, I believe!)
* NamedArrays.jl: old but in use, provides both names & ranges, and allows lookup by n[:A => "one"] etc. Uses OrderdDict for ranges. IIRC various things not type-stable.
