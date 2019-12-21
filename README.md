# merge-sort
Optimized merge sort algorithm in MIPS Assembly.

## Implementation
* Iterative
...Iterative implementation is faster than recursive as it allows us to get rid of the overhead instructions required for function calls.

* Address passing
...Instead of passing by value, my algorithm directly works with the addresses at which the numbers are stored. Allows for faster execution.

* Two arrays with a pointer
...Original merge sort implementation requires the sorted subarray to be copied back into the main array after each iteration. Having two arrays and an alternating pointer allows to get rid of this unnecessary work.
