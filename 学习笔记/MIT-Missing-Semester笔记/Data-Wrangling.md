---
title: 数据整理
date: 2022-08-08 19:23:25
categories:
- [计算机知识, 计算机教育中缺失的一课]
tags: 
- Linux
- Shell
- 学习笔记
---

数据整理解决的基本问题就是：把一种格式的数据转换成另一种。这不仅仅是图片格式之间的转换，还有文本文件、日志文件等等，将其转换成图表或者统计数据的格式。  
简单来说，数据整理就是把一个数据以另一种方式表达。  

> 在之前的课程中，其实我们已经接触到了一些数据整理的基本技术。可以这么说，每当您使用管道运算符的时候，其实就是在进行某种形式的数据整理。  
> 例如这样一条命令 `journalctl | grep -i intel`，它会找到所有包含 intel(不区分大小写) 的系统日志。您可能并不认为这是数据整理，但是它确实将某种形式的数据（全部系统日志）转换成了另外一种形式的数据（仅包含intel的日志）。大多数情况下，数据整理需要您能够明确哪些工具可以被用来达成特定数据整理的目的，并且明白如何组合使用这些工具。  

数据整理需要有*用来整理的数据*和*相关的应用场景*。  

> 日志处理通常是一个比较典型的使用场景，因为我们经常需要在日志中查找某些信息，这种情况下通读日志是不现实的。现在，让我们研究一下系统日志，看看哪些用户曾经尝试过登录我们的服务器：

```bash
ssh servername journalctl
```

> 日志内容太多了。现在让我们把涉及 sshd 的信息过滤出来：

```bash
ssh servername journalctl | grep sshd
```

`ssh`是一种通过命令行远程访问计算机的方式。  

> 此时我们打印出的内容，仍然比我们需要的要多得多，读起来也非常费劲。我们来改进一下：

```bash
ssh servername 'journalctl | grep sshd | grep "Disconnected from"' | less
```

> 多出来的引号是什么作用呢？这么说吧，系统日志是一个非常大的文件，把这么大的文件流直接传输到我们本地的电脑上再进行过滤是对流量的一种浪费。因此我们采取另外一种方式，我们先在远端机器上过滤文本内容，然后再将结果传输到本机。 less 为我们创建来一个文件分页器，使我们可以通过翻页的方式浏览较长的文本。为了进一步节省流量，我们甚至可以将当前过滤出的日志保存到文件中，这样后续就不需要再次通过网络访问该文件了：

```bash
$ ssh servername 'journalctl | grep sshd | grep "Disconnected from"' > ssh.log
$ less ssh.log
```

过滤结果中仍然包含不少没用的数据。这时候来了解一下`sed`这个工具。  

`sed`是一个基于文本编辑器ed构建的”流编辑器” 。在`sed`中，您基本上是利用一些简短的命令来修改文件，而不是直接操作文件的内容（尽管您也可以选择这样做）。相关的命令行非常多，但是最常用的是 `s`，即替换命令，例如我们可以这样写：  

```bash
cat ssh.log | sed 's/.*Disconnected from //'
```

上面这段命令中，我们使用了一段简单的正则表达式。  

正则表达式是一种非常强大的工具，可以让我们基于某种模式来对字符串进行匹配。`s` 命令的语法如下：`s/REGEX/SUBSTITUTION/`, 其中 `REGEX` 部分是我们需要使用的正则表达式，而 `SUBSTITUTION` 是用于替换匹配结果的文本。  

## 正则表达式

[正则表达式-语法](https://www.runoob.com/regexp/regexp-syntax.html)  
[正则表达式](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Guide/Regular_Expressions)  

> 正则表达式非常常见也非常有用，值得您花些时间去理解它。让我们从这一句正则表达式开始学习： `/.*Disconnected from /`。正则表达式通常以（尽管并不总是）`/`开始和结束。大多数的 ASCII 字符都表示它们本来的含义，但是有一些字符确实具有表示匹配行为的“特殊”含义。不同字符所表示的含义，根据正则表达式的实现方式不同，也会有所变化，这一点确实令人沮丧。常见的模式有：  

- `.`除换行符之外的”任意单个字符”

- `*`匹配前面字符零次或多次

- `+`匹配前面字符一次或多次

- `[abc]`匹配 a, b 和 c 中的任意一个

- `(RX1|RX2)`任何能够匹配RX1 或 RX2的结果

- `^`行首

- `$`行尾

> `sed` 的正则表达式有些时候是比较奇怪的，它需要你在这些模式前添加`\`才能使其具有特殊含义。或者，您也可以添加`-E`选项来支持这些匹配。  

可以发现`/.*Disconnected from /`这个正则表达式可以匹配任何以若干个任意字符开头，并在后面跟着“Disconnected from ”的字符串。但是在默认情况下，`*`和`+`是贪婪模式，它会尽可能多的匹配文本。所以有时候会出现如下情况：  

```bash
$ cat ssh.log | head -n1
Jan 17 03:13:00 thesquareplanet.com sshd[2631]: Disconnected from invalid user Disconnected from 46.97.239.16 port 55920 [preauth]

$ cat ssh.log | sed 's/.*Disconnected from //' | head -n1
46.97.239.16 port 55920 [preauth]
```

可见其将IP地址前的用户名（Disconnected from）也匹配并替换了，这样一来就达不到我们想要的结果了。  

解决方法是换用一个正则表达式来匹配一整行：  

```bash
sed -E 's/^.*Disconnected from (invalid |authenticating )?user .* [^ ]+ port [0-9]+( \[preauth\])?$//'
```

让我们借助正则表达式在线调试工具 [regex debugger](https://regex101.com/r/qqbZqh/2) 来理解这段表达式。  

开始的部分和之前是一样的，然后匹配两种类型的“user”（在日志中基于两种前缀区分）。再然后我们匹配属于用户名的所有字符。接着，再匹配任意一个单词（`[^ ]+` 会匹配任意非空且不包含空格的序列）。紧接着后面匹配单“port”和它后面的一串数字，以及可能存在的后缀[preauth]，最后再匹配行尾。  

使用上面的命令会将日志内容全部替换成空字符串，输出显示的仅为一片空白。  
那我们需要将用户名输出显示，就要使用“捕获组（capture group）”来完成。  

捕获组表示用来记住该值并在之后使用。在正则表达式中，任何圆括号括起来的**表达式**就是这样的一个捕获组。  

> 被圆括号内的正则表达式匹配到的文本，都会被存入一系列以编号区分的捕获组中。捕获组的内容可以在替换字符串时使用（有些正则表达式的引擎甚至支持替换表达式本身），例如`\1`、`\2`、`\3`等等。  

```bash
sed -E 's/^.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
```

为了完成某种匹配，我们最终可能会写出非常复杂的正则表达式。  
正则表达式是出了名的难以写对，但是它仍然会是您强大的常备工具之一。  

## 回到数据整理

现在，我们已经得到了一个包含用户名的列表，列表中的用户都曾经尝试过登录我们的系统。但这还不够，让我们过滤出那些最常出现的用户：  

```bash
$ cat ssh.log | sed -E 's/^.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/' | sort | uniq -c
```

`sort`会对其输入数据进行排序。`uniq -c` 会把连续出现的行折叠为一行并使用出现次数作为前缀。我们希望按照出现次数排序，过滤出最常出现的用户名：  

```bash
$ cat ssh.log | sed -E 's/^.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/' | sort | uniq -c | sort -nk1,1 | tail -n10
```

`sort -n` 会按照数字顺序对输入进行排序（默认情况下是按照字典序排序 `-k1,1` 则表示“仅基于以空格分割的第一列进行排序”。`,n` 部分表示“仅排序到第n个部分”，默认情况是到行尾。  

如果我们希望得到登录次数最少的用户，我们可以使用 `head` 来代替`tail`。或者使用`sort -r`来进行倒序排序。  

只获取用户名并按逗号分隔并列显示：  

```bash
$ cat ssh.log | sed -E 's/^.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/' | sort | uniq -c | sort -nk1,1 | tail -n10 | awk '{print $2}' | paste -sd,
```

我们可以利用`paste`命令来合并行(`-s`)，并指定一个分隔符进行分割 (`-d`)，那`awk`的作用又是什么呢？  

### awk - 另外一种流编辑器

`awk` 其实是一种编程语言，只不过它碰巧非常善于处理文本。  

`awk` 程序接受一个模式串（可选），以及一个代码块，指定当模式匹配时应该做何种操作。默认当模式串即匹配所有行。 在代码块中，`$0` 表示整行的内容，`$1` 到 `$n` 为一行中的 n 个区域，区域的分割基于 `awk` 的域分隔符（默认是空格，可以通过`-F`来修改）。  

`awk '{print $2}'`的意思即为对每一行文本打印其第二部分，在这里则是指用户名。  

让我们统计一下所有以 c 开头，以 e 结尾，且仅登录过一次的用户。  

```bash
$ cat ssh.log | sed -E 's/^.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/' | sort | uniq -c | awk '$1 == 1 && $2 ~ /^c.*e$/ {print $0}
```

这次我们为`awk`指定了一个匹配模式串（也就是`{...}`前面的那部分内容）。该匹配要求文本的第一部分需要等于 1（这部分刚好是uniq -c得到的计数值），然后其第二部分必须满足给定的一个正则表达式。`~`就是表示用来匹配后面的正则表达式，告诉`awk`后面开始是正则语法。代码块中的内容则表示打印整行。  

不过，既然 awk 是一种编程语言，那么则可以这样统计行数：

```bash
BEGIN { rows = 0 }
$1 == 1 && $2 ~ /^c[^ ]*e$/ { rows += $1 }
END { print rows }
```

`BEGIN` 也是一种模式，它会匹配输入的开头（ `END` 则匹配结尾）。然后，对每一行第一个部分进行累加，最后将结果输出。事实上，我们完全可以抛弃 `grep` 和 `sed` ，因为 `awk` 就可以[解决所有问题](https://backreference.org/2010/02/10/idiomatic-awk/)。  

## 分析数据

想做数学计算也是可以的！例如这样，您可以将每行的数字加起来：  

```bash
| awk '{print $1}' | paste -sd+ | bc -l
```

下面这种更加复杂的表达式也可以：  

```bash
echo "2*($(data | paste -sd+))" | bc -l
```

您可以通过多种方式获取统计数据。如果已经安装了R语言，[st](https://github.com/nferraz/st) 是个不错的选择：  

```bash
$ cat ssh.log | sed -E 's/^.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/' | sort | uniq -c | awk '{print $1}' | R --slave -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
```

> `R` 也是一种编程语言，它非常适合被用来进行数据分析和[绘制图表](https://ggplot2.tidyverse.org/)。这里我们不会讲的特别详细， 您只需要知道`summary`可以打印某个向量的统计结果。我们将输入的一系列数据存放在一个向量后，利用R语言就可以得到我们想要的统计数据。  

如果您希望绘制一些简单的图表， `gnuplot` 可以帮助到您：  

```bash
$ cat ssh.log | sed -E 's/^.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/' | sort | uniq -c | sort -nk1,1 | tail -n10 | gnuplot -p -e 'set boxwidth 0.5; plot "-" using 1:xtic(2) with boxes'
```

## 命令行参数处理

有时候您要利用数据整理技术从一长串列表里找出你所需要安装或移除的东西。我们之前讨论的相关技术配合 `xargs` 即可实现：  

```bash
$ rustup toolchain list | grep nightly | grep -vE "nightly-x86" | sed 's/-x86.*//' | xargs rustup toolchain uninstall
```

`xargs`接受若干行输出，并将它们转化为参数形式。  

## 整理二进制数据

虽然到目前为止我们的讨论都是基于文本数据，但对于二进制文件其实同样有用。例如我们可以用 ffmpeg 从相机中捕获一张图片，将其转换成灰度图后通过SSH将压缩后的文件发送到远端服务器，并在那里解压、存档并显示。  

```bash
$ ffmpeg -loglevel panic -i /dev/video0 -frames 1 -f image2 - | convert - -colorspace gray - | gzip | ssh servername 'gzip -d | tee copy.jpg' | feh -
```

## 课后练习

1. 学习一下这篇简短的[交互式正则表达式教程](https://imageslr.github.io/regexone-cn/)。  

   原网站是全英文教程，不过都很简短明晰。不过不知道为什么不能交互了，所以我将网址换成了它的汉化版。  
   网站上的教程做完基本能熟悉正则表达式的基本用法。下面我放一下自己的答案（答案不止一种）：  

   ```bash
   # 课程
   1. [a-c]+
   2. \d\d\d
   3. ^.*\.
   4. ^[cmf]+[an]+$
   5. ^[^b]og$
   6. ^[^a-z]\w*$
   7. ^waz{2,}up$
   8. a+b*c+
   9. ^\d+ files? found\?$
   10. ^\d.\s+.*$
   11. ^\w+\:\s?successful$
   12. ^(.*)\.pdf$
   13. ^(.*\s+(\d+))$
   14. (\d{3,4})x(\d{3,4})
   15. ^.*(cats|dogs)$
   16. .*

   # 问题
   1. ^-?\d+(,\d+)*(\.\d+)?(e\d+)?$
   2. 1?\s*-?\(?(\d{3})\)?\s*-?\d{3}\s*-?\d{4}
   3. ^([\w\.]*)
   4. ^\<(\w+)
   5. ^(\w+)\.(jpg|png|gif)$
   6. ^\s+(.*)\s*$
   7. (\w+)\((.+):(\d+)\)
   8. ^(\w+)://([^/:]+)(:(\d+))?

   # 进阶课程
   1. ((\w+) \2)
   2-1. \w+(?=ly)
   2-2. (?<=un)\w+
   2-3. re(?!g)
   2-4. (?<!un)happy
   3. .*(?:cats|dogs)
   4. (\d+?)0*$
   ```

   更多资源：[在线学正则表达式](https://zhuanlan.zhihu.com/p/447336932)

2. 统计words文件 (`/usr/share/dict/words`) 中包含至少三个`a`且不以`'s`结尾的单词个数。这些单词中，出现频率前三的末尾两个字母是什么？ `sed`的`y`命令，或者 `tr` 程序也许可以帮你解决大小写的问题。共存在多少种词尾两字母组合？还有一个很有挑战性的问题：哪个组合从未出现过？  

   [Linux sed 命令详解](http://t.zoukankan.com/baichunyu-p-15227423.html)  
   [Linux tr 命令详解](https://www.cnblogs.com/ftl1012/p/tr.html)  

   统计个数：

   ```bash
   $ cat /usr/share/dict/words | tr "[:upper:]" "[:lower:]" | grep -E "^(.*a){3}.*[^'s]$"| wc -l
   ```

   在上面的单词中统计出现频率前三的末尾两个字母：

   ```bash
   $ cat /usr/share/dict/words | tr "[:upper:]" "[:lower:]" | grep -E "^(.*a){3}.*[^'s]$" | sed -E "s/.*([a-z]{2})$/\1/" | sort | uniq -c | sort | tail -n3
   ```

   词尾两字母组合种类数量：

   ```bash
   $ cat /usr/share/dict/words | tr "[:upper:]" "[:lower:]" | grep -E    "^(.*a){3}.*[^'s]$" | sed -E "s/.*([a-z]{2})$/\1/" | sort | uniq | wc -l
   ```

   未出现过的组合：

   ```bash
   # 枚举所有组合
   #!/bin/bash

   for i in {a..z};
   do for j in {a..z};
     do echo ${i}${j}
     done
   done
   ```

   ```bash occur.sh
   $ ./all.sh > all.txt
   $ cat /usr/share/dict/words | tr "[:upper:]" "[:lower:]" | grep -E    "^(.*a){3}.*[^'s]$" | sed -E "s/.*([a-z]{2})$/\1/" | sort | uniq |    sort > occur.txt
   $ diff --unchanged-group-format='' <(cat occur.txt) <(cat all.   txt) | wc -l
   ```

3. 进行原地替换听上去很有诱惑力，例如： `sed s/REGEX/SUBSTITUTION/ input.txt > input.txt`。但是这并不是一个明智的做法，为什么呢？还是说只有 sed是这样的? 查看 `man sed` 来完成这个问题  

   不能使用`sed s/REGEX/SUBSTITUTION/ input.txt > input.txt`的操作，因为会先执行`> input.txt`将后者清空。所以前面一个`input.txt`在还没有被 `sed` 处理时已经为空了。在使用正则处理文件前最好是首先备份文件。  

   ```bash
   sed -i.bak s/REGEX/SUBSTITUTION/ input.txt > input.txt
   ```

   上面的命令会自动创建一个后缀为 `.bak` 的备份文件。  

4. 找出您最近十次开机的开机时间平均数、中位数和最长时间。在Linux上需要用到 `journalctl` 。找到每次起到开始和结束时的时间戳。在Linux上类似这样操作：  

   ```bash
   Logs begin at ...
   ```

   和

   ```bash
   systemd[577]: Startup finished in ...
   ```

   `journalctl` 默认只会保存最近一次启动的日志。我们需要修改设置来允许    `journalctl` 记录多次开机的日志。

   ```bash
   $ sudo vi /etc/systemd/journald.conf
   ```

   设置`Storage=persistent`：  

   ![journald.conf](https://www.z4a.net/images/2022/08/11/JcsyeCcf0p.png)  

   然后手动重启多次系统，收集数据：  

   ![重启](https://www.z4a.net/images/2022/08/11/nQfzdQmLVO.png)

   使用 `journalctl` 和 `grep` 筛选出系统启动数据：  

   ![日志筛选](https://www.z4a.net/images/2022/08/11/Fg6mkHNY1h.png)

   观察发现带有`kernel`即`内核`的条目即为系统的真正启动时间，进一步筛选：  

   ![启动时间](https://www.z4a.net/images/2022/08/11/gMr9ikssFQ.png)

   编写脚本`getlog.sh`来获取最近十次的启动时间数据：  

   ```bash
   #!/bin/bash

   for i in {0..9}; do
       journalctl -b-$i | grep "Startup finished in"
   done
   ```

   ```bash
   $ ./getlog.sh > starttime.txt
   ```

   `sed`的正则有许多语法都不支持，因此这里只用最基本的语法。  

   ```bash
   #获取最长时间
   $ cat starttime.txt | grep "systemd\[1\]" | sed -E "s/.*=\ (.*)s\.$/\1/" | sort | tail -n1

   #获取最短时间
   $ cat starttime.txt | grep "systemd\[1\]" | sed -E "s/.*=\ (.*)s\.$/\1/" | sort -r | tail -n1

   #平均数（注意 awk 要使用单引号）
   $ cat starttime.txt | grep "systemd\[1\]" | sed -E "s/.*=\ (.*)s\.$/\1/" | paste -sd+ | bc -l | awk '{print $1/10}'

   # 中位数
   $ cat starttime.txt | grep "systemd\[1\]" | sed -E "s/.*=\ (.*)s\.$/\1/" | sort | paste -sd\ | awk '{print ($5+$6)/2}'
   ```

5. 查看之前三次重启启动信息中不同的部分(参见`journalctl`的`-b`选项)。将这一任务分为几个步骤，首先获取之前三次启动的启动日志，也许获取启动日志的命令就有合适的选项可以帮助您提取前三次启动的日志，亦或者您可以使用`sed '0,/STRING/d'` 来删除`STRING`匹配到的字符串前面的全部内容。然后，过滤掉每次都不相同的部分，例如时间戳。下一步，重复记录输入行并对其计数(可以使用`uniq`)。最后，删除所有出现过3次的内容（因为这些内容是三次启动日志中的重复部分）。  

      将上面的`getlog.sh`简单修改为：  

      ```bash
      #!/bin/bash

      for i in {0..2}; do #获取最近三次的启动日志
          journalctl -b-$i | sed '0,/Startup finished/d'
      done
      ```

      然后输入下列命令：  

      ```bash
      $ ./getlog.sh > last3time.txt
      ```

      去除开头的时间戳：  

      ```bash
      $ cat last3time.txt | sed -E "s/.*al\ (.*)/\1/" | head -n10
      ```

      重复记录输入行并对其计数，并删除所有出现过3次的内容：  

      ```bash
      #注意 uniq 只能过滤相邻的行，所以必须先排序
      $ cat last3time.txt | sed -E "s/.*al\ (.*)/\1/" | sort | uniq -c |       sort | awk '$1!=3 { print }'
      ```

6. 在网上找一个类似[这个](https://stats.wikimedia.org/EN/TablesWikipediaZZ.htm)或者[这个](https://ucr.fbi.gov/crime-in-the-u.s/2016/crime-in-the-u.s.-2016/topic-pages/tables/table-1)的数据集。或者从[这里](https://www.springboard.com/blog/data-science/free-public-data-sets-data-science-project/)找一些。使用 `curl` 获取数据集并提取其中两列数据，如果您想要获取的是HTML数据，那么`pup`可能会更有帮助。对于JSON类型的数据，可以试试`jq`。请使用一条指令来找出其中一列的最大值和最小值，用另外一条指令计算两列之间差的总和。

   emmmmmm，我看了看两个数据集，内容都还挺多的，第三个网站是自己去里面列出的网址找数据集。  
   `curl`命令会遍历整个html文件并下载，使用`grep`和`sed`命令筛选将会得到一长串包含正则表达式的命令。题目中提到的工具确实能使数据筛选更高效快速。  
   题目中说的一条指令，可以包含长串的函数，那样来说确实是一条，但是不够美观。  
   因本人懒，且虚拟机无法连接上以上网站，所以这里不作解答。  
