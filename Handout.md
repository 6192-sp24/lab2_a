# Warming-up: making a counter concurrent

In `LabCounter.bsv` we give a simple implementation (`mkCounter`) of a counter using only registers.

This module has three methods: `inc, cur`, and `set` (incrementing the counter, observing the current value, and setting the counter to a specific value).

The simple implementation we give allows some amount of concurrency (calling multiple methods within the same cycle) with the following constraints:
```
cur < inc 
cur < set
inc C set
```

We are unhappy with this behavior, and would like to get a different concurrent behavior, where the `cur` method would be able to observe the new values (incremented/setted) produced within the same cycle.

Your task is to fill-in (using Ehr) the module `mkCounterEhr`, to get the following concurrent behaviors:
```
set < inc
inc < cur
set < cur
```
So we want to be able to get the logical order `set< inc< cur` within one cycle. You can use as many EHR ports as needed.

You can test your code with:
```
make
./Labcounter
```


# Completion buffer

We now want to build a completion buffer, like the one presented in Lecture 5.

### Review

A completion buffer first issues a token to the user, reserving a slot in the buffer. Using this token, the user can then store a result associated with this token. The user can then request a result from the buffer, which will emit results in the same order tokens were issued (FIFO order), freeing the token/result from the buffer.

For more details on internal implementation, refer to the Lecture 5 slides.

## A first version without worrying about concurrency

Using vectors of 8 registers, e.g. `Vector#(8, Reg#(Bit#(32))) buffer_data <- replicateM(mkReg(0));` and a simialr set of registers for valid bits, implement a completion buffer without worrying about concurrency in the file
`CBuffer.bsv`

You can test your code with:
```
make
./CBuffer
```

## An improvement where we can call multiple methods in the same cycle

Using `Ehr`s, port your previous implementation to allow the three methods to be called within the same cycle in the file `CBufferEhr.bsv`. You should target the following concurrent behaviors:

```
getToken < Put 
getToken < getResult 
put < getResult
```  

This should be doable with 2 port EHRs.

You can test your code with:
```
make
./CBufferEhr
```

