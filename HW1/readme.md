HW1
===
# 2022_CS Digital IC Design - HW1 report
###### tags: `2022_CS Digital IC Design`

## The architecture of 8-bit ALU
![](https://i.imgur.com/h2WbG6s.png)

The 8-bit ALU can be constructed by cascading eight 1-bit ALU modules. The SLT operation is implemented with subtraction operation. If the subtraction result is minus, the `set` port of the 1-bit ALU for MSB should output 1. The `less` port of the 1-bit ALU for LSB will then take the `set` signal from MSB and pass it to result. The subtraction operation may cause overflow. To ensure that the SLT operation is correct, an overflow detection circuit should be implemented. **The `set` signal from MSB will be adjusted according to the `overflow` signal before it is transmitted to the `less` port of the 1-bit ALU for LSB.** The `less` port of the 1-bit ALUs besides from LSB should be hardwired to 0.
* `set`：*ALU_MSB* is 1.
* `less`：*ALU_result* is minus.
* `overflow`：*ALU_MSB carry in* XOR *ALU_MSB carry out*.
### What is the combinational circuit between `set`, `overflow` and `less`?
For example, there is a 4-bits adder：
1. positive overflow

![](https://i.imgur.com/xzfcXqj.png)

2. negative overflow

![](https://i.imgur.com/Wn0Yxlq.png)

3. positive non-overflow

![](https://i.imgur.com/rpFDvey.png)

4. negative non-overflow

![](https://i.imgur.com/aCHLYtw.png)


Truth table：
|set|overflow|less|
|:--:|:--:|:--:|
|0|0|0|
|0|1|1|
|1|0|1|
|1|1|0|

According to the truth table, the result is `less = set ^ overflow`.
