---
title: 逻辑门与二进制
date: 2023-04-18
categories:
- [计算机知识, 基础部分]
tags:
- 学习笔记
- 布尔逻辑与逻辑门
- 二进制
---

Computers evolved from electromechanical devices, that often had decimal（十进制） representations of numbers, to electronic computers with transistors（晶体管） that can turn the flow of electricity on or off.  

## Bool

With just two states of electricity, we can represent important information. We call this representation Binary --which literally means "of two states".  

Only two states may be not a lot of to work with, but they're exactly what you need for representing the values "true" and "false".  

In computer, an "on" state, when electricity is flowing, represents **true**. The "off" state, no electricity flowing, represents **false**.  

We can also write binary as 1's and 0's instead of true's and false's -they are just different expressions of the same signal.  

### Why Use Binary

It is actually possible to ue transistors for more than just turning electrical current on and off, and allow for different levels of current.  

Some early electronic computers were ternary（三进制）, that's three states, and even quinary（五进制）, using 5 states.  

The problem is, the more intermediate states there are, the harder it is to keep them all separate -- if your smartphone battery starts running low or there's electrical noise because someone's running a microwave nearby, the signals can get mixed up. And this problem only gets worse with transistors changing states millions of times per second.  

Therefore, placing two signals as far apart as possible -using just 'on and off' - gives us the most distinct signal to minimize these issues.  

Another reason computers use binary is that an entire branch of mathematics already existed that dealt exclusively ith true and false values. And it had figured out all of the necessary rules and operations for manipulating them. It's called Boolean Algebra（布尔代数）.  

George Boole, from which Boolean Algebra later got its name, was a self-taught English mathematician in the 1800s. Boole's approach allowed truth to be systematically and formally proven, through logic equations which he introduced in his first book, "The Mathematical Analysis of Logic" in 1847.  

In "regular" algebra, the values of variables are numbers, and operations on those numbers are things like addition and multiplication. But in Boolean Algebra, the values of variables are true and false, and the operations are logical.  

### Fundamental Operations in Boolean Algebra

#### NOT

| Input | Output |
| :----: | :----: |
| TRUE | FALSE |
| FALSE | TRUE |

We can easily build boolean logic out of transistors. Transistors are really just little electrically controlled switches. They have three wires: two electrodes and one control wire.  

![Transistor](https://article.anvelpro.xyz/IMAGES/2023/Computer-Basics/transistor.png)  

When you apply electricity to the control wire, it lets current flow through from one electrode, through the transistor, to the other electrode.  

You can think of the control wire as an input, and the wire coming from the bottom electrode as the output.  

![bool](https://article.anvelpro.xyz/IMAGES/2023/Computer-Basics/bool.png)  

With a single transistor, we have one input and one output.  
If we turn the input on, the output is also on because the current can flow through it.  
If we turn the input off, the output is also off and the current can no longer pass through.  

In boolean terms, when the input is true, the output is true. And when the input is false, the output is also false. Which again we can show on a *logic table（真值表）*.  

| Input | Output |
| :----: | :----: |
| TRUE | TRUE |
| FALSE | FALSE |

We can modify this circuit just a little bit to create a NOT.  
Instead of having the output wire at the end of the transistor, we can move it before. If we turn the input on, the transistor allows current to pass through it to the "ground", and the output wire won't receive that current - so it will be off.  

![NOT](https://article.anvelpro.xyz/IMAGES/2023/Computer-Basics/NOT.png)  

In this case, if the input is on, output is off.  

When we turn off the transistor, through, current is prevented from flowing down it to the ground. Instead, current flows through the output wire.  

So the input will be off and the output will be on.  

We call the circuit NOT gate.  

#### AND

The AND Boolean operation takes two inputs, but still has a single output.  
In this case the output is only true if both inputs are true.  

Logic table:  

| Input A | Input B | Output |
| :----: | :----: | :----: |
| TRUE | TRUE | TRUE |
| TRUE | FALSE | FALSE |
| FALSE | TRUE | FALSE |
| FALSE | FALSE | FALSE |

To build an AND gate, we need two transistors connected together（两个晶体管串联）.

![AND](https://article.anvelpro.xyz/IMAGES/2023/Computer-Basics/AND.png)  

#### OR

| Input A | Input B | Output |  
| :----: | :----: | :----: |  
| TRUE | TRUE | TRUE |  
| TRUE | FALSE | TRUE |  
| FALSE | TRUE | TRUE |  
| FALSE | FALSE | FALSE |  

Building an OR gate from transistors needs a few extra wires. Instead of having two transistors in series, we have them in parallel（并联）.  

![OR](https://article.anvelpro.xyz/IMAGES/2023/Computer-Basics/OR.png)  

#### XOR

| Input A | Input B | Output |
| :----: | :----: | :----: |
| TRUE | TRUE | FALSE |
| TRUE | FALSE | TRUE |
| FALSE | TRUE | TRUE |
| FALSE | FALSE | FALSE |

XOR is like a regular OR, but with one difference: is both inputs are true, the XOR is false.  
The only time an XOR is true is when one input is true and the other input is false.  

Circuit Diagram:  

![XOR](https://article.anvelpro.xyz/IMAGES/2023/Computer-Basics/XOR.png)  

#### Circuit Symbol

![NOT](https://article.anvelpro.xyz/IMAGES/2023/Computer-Basics/NOT1.png)  

![AND](https://article.anvelpro.xyz/IMAGES/2023/Computer-Basics/AND1.png)  

![OR](https://article.anvelpro.xyz/IMAGES/2023/Computer-Basics/OR1.png)  

![XOR](https://article.anvelpro.xyz/IMAGES/2023/Computer-Basics/XOR1.png)  

When computer engineers are designing processors, they rarely ork at the transistor level, and instead work with much larger blocks, like logic gates, and even larger components made up of logic gates.  

## Binary

A single binary value can be used to represent a number. In stead of true and false, we can call these two states 1 and 0 which is actually incredibly useful. And if we want to represent larger things we just need to add more binary digits. This works exactly the same way as the decimal numbers that we're all familiar with.  

With decimal numbers, these are "only" 10 possible values a single digit can be; 0 through 9, and to get numbers larger than 9 we just start adding more digits to the front. We can do the same with binary.  

For example, let's take the number 263. It means we've got 2 one-hundreds, 6 tens, and 3 ones.  

| 100's | 10's | 1's |
| :----: | :----: | :----: |
| 2 | 6 | 3 |

In this case, each multiplier is ten times larger than the one to the right. That's because each column has ten possible digits to work with, after which you have to carry one to the next column. For this reason, it's called *base-ten notation（基于十的表示法）*, also called decimal since deci means ten.  

And Binary works exactly the same way, it's just base-two. That's because there are only two possible digits in binary - 1 and 0.  

This means that each multiplier has to be two times larger than the column to its right. Instead of hundreds, tens and ones, they are fours, twos and ones now.  

Take for example the binary number 101.  

| 4's | 2's | 1's |
| :----: | :----: | :----: |
| 1 | 0 | 1 |

This means we have 1 fours, 0 twos, and 1 one. And those all together and we've got the number 5 in base ten.

```txt
1*2^2 + 0*2^1 + 1*2^0 = 4 + 0 + 1 = 5
```

To represent larger numbers, binary needs a lot more digits.  

Take this number in binary 1011 0111.  

```txt
1*2^7 + 0*2^6 + 1*2^5 + 1*2^4 + 0*2^3 + 1*2^2 + 1*2^1 + 1*2^0 
= 1*128 + 0*64 + 1*32 + 1*16 + 0*8 + 1*4 + 1*2 + 1*1
= 128 + 32 + 16 + 4 + 2 + 1 
= 183
```

Math with binary numbers isn't hard either.  
Take for example decimal addition of 183 plus 19.  

![binary-add](https://article.anvelpro.xyz/IMAGES/2023/Computer-Basics/binary-add.png)

Adding 1 + 1 results in 2, even in binary. But there is no symbol "2", so we use 10(one-zero) and put 0 as our sum and carry the 1. Just like in our decimal example, 1 plus 1, plus the 1 carried, equals 3 or 11 in binary, so we put the sum as 1 and we carry 1 again, and so on.  

Each of these *binary digits*, 1 or 0, is called a "bit".  

In these last few examples, we were using 8-bit numbers with their lowest value of zero and highest value is 255, which requires all 8 bits to be set to 1. That's 256 different values, or 2 to the 8th power.  

### Storage Capacity

You might have heard of 8-bit computers, or 8-bit graphics or audio. These were computers that did most of their operations in chunks of 8 bits. But 256 different values isn't a lot to work with, so it meant things like 8-bit games were limited to 256 different colors for their graphics.  

And 8-bits is such a common size in computing, it has a special word: *byte(B)*.  

1 bytes = 8 bits.  

And the *kilobytes(KB)*, *megabytes(MB)*, *gigabytes(GB)* and so on, these prefixes denote different scales of data.  

Just like 1 kilogram(kg) is 1000 grams(g), 1 kilobyte is 1000 bytes, or really 8000 bits.  

Mega is a million bytes (MB), and giga is a billion bytes (GB). Today you might even have a hard drive that has 1 *terabyte (TB)* of storage -- that's 8 trillion ones and zeros.  

In binary, 1 kilobyte has 2 to the power of 10 bytes, or 1024.  

```txt
1 KB = 2^10 B = 1024 B
```

And the 1000 is also right when talking about kilobytes. We should acknowledge it isn't the only correct definition.  

### 32-bit & 64-bit

The term 32-bit or 64-bit computers, what this means is that they operate in chunks of 32 or 64 bits.  

```txt
2^32 = 4,294,967,296
2^64 = 18,446,744,073,709,551,616
```

The largest number you can represent with 32 bits is just under 4.3 billion, which is 32 1's in binary. This is why our photos are so smooth and pretty - they are composed of millions of colors, because computers today use 32-bit color graphics.  

But not everything is a positive number（正数）, so we need a way to represent positive and negative numbers.  

Most computers use the first bit for the sign: 1 for negative, 0 for positive numbers, and then use the remaining 31 bits for the number itself. That gives us a range of roughly plus or minus two billion.

```txt
2^31 = 2,147,483,648 ≈ 2.1*10^9
2^63 = 9,223,372,036,854,775,808 ≈ 9.2*10^18
```

While this is a pretty big range of numbers, it's not enough for many tasks. There are 7 billion people on the earth, and the US national debt is almost 20 trillion dollars after all. This is why 64-bit numbers are useful.  

The largest value a 64-bit number can represent is around 9.2 quintillion.  

Most importantly, computers must label locations in their memory（内存）, known as addresses（位址）, in order to store and retrieve values.  

As computer memory has grown to gigabytes and terabytes, it was necessary to have 64-bit memory addresses as well.  

### "Floating Point" Numbers

In addition to negative and positive numbers, computers must deal with numbers that are not whole numbers, like 12.7 and 3.14. These are called "floating point" numbers, because the decimal（小数） point can float around in the middle of number.  

Several methods have been developed to represent floating point numbers. The most common of which is the *IEEE 754 standard*.  

In essence, this standard stores decimal values sort of like scientific notation. For example, 625.9 can be written as 0.6259*10^3. There are two important numbers here: the `.6259` is called the significand（有效位数）. And 3 is the exponent（指数）.  

```txt
0 10001000 00111000111100110011010 = 625.9
```

[IEEE 754二进制浮点数算术标准](https://www.cnblogs.com/meteoric_cry/p/7266105.html)  
[IEEE754规范的舍入方案如何理解](https://www.zhihu.com/question/68131179/answer/273788172)  
[IEEE 754 的舍入规则](https://blog.leodots.me/post/45-ieee754-rounding-rules.html)  
[二进制小数和IEEE浮点标准](https://www.cnblogs.com/ysocean/p/7531667.html)
[浮点数舍入以及运算](https://www.cnblogs.com/ysocean/p/7577564.html)  

In a 32-bit floating point number, the first bit is used for the sign of the number -- positive or negative. The next 8 bits are used to store the exponent and the remaining 23 bits are used to store the significand.  

### ASCII & Unicode

Computers have a way to represent text.  

Rather than have a special form of storage for letters, computers simply use numbers to represent letters.  

The most straightforward approach might be to simply number the letters of the alphabet.  

ASCII, the American Standard Code for Information Interchange, invented in 1963. ASCII was a 7-bit code, enough to store 128 different values. With the range, it could encode capital letters, lowercase letters,digits 0 through 9, and symbols like the @ sign and punctuation marks.  

[ASCII Wiki](https://en.wikipedia.org/wiki/ASCII)  

ASCII was such an early standard, it became widely used, and critically, allowed different computers built by different companies to exchange data. This ability to univesally exchange information is called "interoperability（互用性）". However, it did have a major limitation: it was really only designed for English.  

Fortunately, there are 9 bits in a byte, not 7, and it soon became popular to use codes 128 through 255, previously unused, for "national" characters. And national character codes worked pretty well for most countries.  

The problem was, if you opened an email written in Latvian（拉脱维亚语） on a Turkish（土耳其） computer, the result was completely incomprehensible. And things totally broke with the rise of computing in Asia, as languages like Chinese and Japanese have thousands of characters. There was no way to encode all those characters in 8-bits.  

In response, each country invented multi-byte encoding schemes, all of which were mutually incompatible. The Japanese were so familiar ith this encoding problem that they had a special name for it: "mojibake（乱码）", which means "scrambled text".  

And so it was born - Unicode - one format to rule them all. Devised in 1992 to finally do away with all of the different international schemes. It replaced them with one universal encoding scheme.  

The most common version of Unicode uses 16 bits with space for over a million codes - enough for every single character from every language ever used.  

And in the same way that ASCII defines a scheme for encoding letters as binary numbers, other file formats - like MP3s or GIFs - use binary numbers to encode sounds or colors of a pixel in our photos, movies, and music. Most importantly, under thee hood it all comes down to long sequences of bits.  
