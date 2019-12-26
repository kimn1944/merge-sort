# merge-sort
Optimized merge sort algorithm in MIPS Assembly.

## Implementation
Iterative - Iterative implementation is faster than recursive as it allows us to get rid of the overhead instructions required for function calls.  

Address passing - Instead of passing by value, my algorithm directly works with the addresses at which the numbers are stored. Allows for faster execution.  

Two arrays with a pointer - Original merge sort implementation requires the sorted subarray to be copied back into the main array after each iteration. Having two arrays and an alternating pointer allows to get rid of this unnecessary work.

## Getting Started
These instructions will tell you how to test the algorithm.

### Prerequisites 
To run the file you will need a MIPS simulator. I used MARS simulator by by Pete Sanderson and Kenneth Vollmar at Missouri State University. Here is the link where you can download the required software:
>https://courses.missouristate.edu/KenVollmar/MARS/

### Running the file
After installing the required IDE you can just open the asm file in the environement and start testing. You can choose an integer array of any length. The array length, array and the resulting array variables must be updated accordingly at the top of the asm file. In the tools section of MARS you can enable the instructions calculator to see the dynamic instruction count for each run.
