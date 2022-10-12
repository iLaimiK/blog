---
title: Shell工具与脚本
date: 2022-07-17 01:55:16
categories:
- [计算机知识, 计算机教育中缺失的一课]
tags:
- Shell
- Linux
- 学习笔记
---

官方文档: https://missing.csail.mit.edu/  
官方文档中文翻译: https://missing-semester-cn.github.io/  

# Shell 脚本

> 本节中，我们会专注于 bash 脚本，因为它最流行，应用更为广泛。

在bash中的变量赋值语法为`foo=bar`，访问变量中的值，其语法为`$foo`。

> 需要注意的是，`foo = bar`（使用空格隔开）是不能正确工作的，因为解释器会调用程序`foo`并将`=`和`bar`作为参数。

在bash、zsh、sh中，空格是用于分隔参数的保留字符，使用空格可能会造成混淆。  

Bash中的字符串通过`'`和`"`分隔符来定义，但是它们的含义并不相同。以`'`定义的字符串为原义字符串，其中的变量不会被转义，而`"`定义的字符串会将变量值进行替换。  

```bash
$ foo=bar
$ echo "$foo"   #打印 bar
$ echo '$foo'   #打印 $foo
```
和其他大多数的编程语言一样，Bash 也支持`if`，`case`，`while`和`for`这些控制流关键字。同样地， Bash 也支持函数，它可以接受参数并基于参数进行操作。  
以下是一个简单的函数定义，该函数位于`mcd.sh`文件中：  

```bash
mcd() {
    mkdir -p "$1"
    cd "$1"
}
```

该函数会创建一个文件夹并将当前目录切换到该文件夹。  

<details>
<summary>bash中的一些特殊变量</summary>

```bash
$0      #当前 Shell的名称（在命令行直接执行时）或者脚本名（在脚本中执行时）
$1 ~ $9 #第一个参数及其之后的参数
$@      #脚本的所有参数值
$#      #脚本的参数数量
$?      #上一个命令的返回值。返回值是0，表示上一个命令执行成功；如果不是零，表示上一个命令执行失败。
$$      #当前 Shell 的进程ID 或者当前脚本的进程ID
$_      #上一个命令的最后一个参数
!!      #完整的上一个命令
```

</details><br />

[Bash 变量](https://wangdoc.com/bash/variable.html)

source命令会在当前bash环境下读取并执行对应文件中的命令。`source mcd.sh`将`mcd.sh`文件内的内容添加到 Shell 中，即将函数`mcd`添加到了 Shell 中。
然后该函数即可在 Shell 中直接使用。

```bash
~$: source mcd.sh
~$: mcd test
~/test$: cd ..
```

[Bash 脚本入门](https://wangdoc.com/bash/script.html)

退出码可以搭配`&&`（与操作符）和`||`（或操作符）使用，用来进行条件判断，决定是否执行其他程序。它们都属于短路运算符（short-circuiting）。  
同一行的多个命令可以用`;`分隔。程序 true 的返回码永远是0，false 的返回码永远是1。  

```bash
$ false || echo "Oops, fail"
# Oops, fail

$ true || echo "Will not be printed"
#

$ true && echo "Things went well"
# Things went well

$ false && echo "Will not be printed"
#

$ false ; echo "This will always run"
# This will always run
```

另一个常见的模式是以变量的形式获取一个命令的输出，这可以通过 命令替换（command substitution）实现。  
当您通过`$( CMD )`这样的方式来执行`CMD`这个命令时，它的输出结果会替换掉 `$( CMD )`。例如，如果执行`for file in $(ls)`，Shell首先将调用`ls`，然后遍历得到的这些返回值。  

还有一个冷门的类似特性是*进程替换（process substitution）*，`<( CMD )`会执行 CMD 并将结果输出到一个临时文件中，并将`<( CMD )`替换成临时文件名。这在我们希望返回值通过文件而不是STDIN（标准输入）传递时很有用。例如，`diff <(ls foo) <(ls bar)`会显示文件夹 foo 和 bar 中文件的区别。  

```bash
$ foo=$(pwd)
$ echo $foo
# 输出当前目录路径
$ echo "We are in $(pwd)"
# We are in 当前目录路径
$ cat <(ls) <(ls ..)
# 输出当前目录与上一级目录内的所有文件名
```

包含上述所有 bash 变量的程序`example.sh`：

```bash
#!/bin/bash

echo "Starting program at $(date)"

echo "Running program $0 with $# args with pid $$"

for file in $@; do
    grep foobar $file > /dev/null 2> /dev/null
    # 如果没有找到，则 grep 退出状态为 1
    # 我们将 STDOUT(>) 和 STDERR (2>) 重定向到 Null，因为我们并不关心这些信息
    # 2> 是用来重定向 STDERR 的，因为 STDOUT 和 STDERR 是分离的
    if [[ $? -ne 0 ]]; then # 比较运算符 -ne (Non Equal)，代表不等于
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> $file
    fi
done
```

运行该脚本：

```bash
user@localhost:~/missing/shell_tools$ ./example.sh mcd.sh test2.sh
Starting program at Sun July 23 23:51:13 CST 2022
Running program ./example.sh with 2 args with pid 11920
File test2.sh does not have any foobar, adding one
```

## 通配

当执行脚本时，我们经常需要提供形式类似的参数。Bash使我们可以轻松的实现这一操作，它可以基于文件扩展名展开表达式。这一技术被称为shell的**通配（globbing）**  

通配符：当你想要利用通配符进行匹配时，你可以分别使用`?`和`*`来匹配一个或任意个字符。  

大括号{}：当你有一系列的指令，其中包含一段公共子串时，可以用大括号来自动展开这些命令。这在批量移动或转换文件时非常方便。  

```bash
convert image.{png,jpg}
# 会展开为
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# 会展开为
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# 也可以结合通配使用
mv *{.py,.sh} folder
# 会移动所有 *.py 和 *.sh 文件

mkdir foo bar
# 下面命令会创建foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h这些文件
touch {foo,bar}/{a..h}

touch foo/x bar/y
# 比较文件夹 foo 和 bar 中包含文件的不同
diff <(ls foo) <(ls bar)
# 输出
# < x
# ---
# > y
```

## 使用环境变量来解析脚本

脚本的第一行通常是指定解释器，即这个脚本必须通过什么解释器执行。这一行以`#!`字符开头，这个字符称为 Shebang，所以这一行就叫做 Shebang 行。  

例如：  

```python
#!/usr/bin/python
import sys
for arg in reversed(sys.argv[1:]):
    print(arg)
```

但是，如果解释器不放在目录/bin，脚本就无法执行了。为了保险，可以写成下面这样：  

```python
#!/usr/bin/env python
```

> `env`命令总是指向`/usr/bin/env`文件，或者说，这个二进制文件总是在目录`/usr/bin`。

> `#!/usr/bin/env NAME`这个语法的意思是，让 Shell 查找`$PATH`环境变量里面第一个匹配的`NAME`。如果你不知道某个命令的具体路径，或者希望兼容其他用户的机器，这样的写法就很有用。

<details>
<summary>Shell函数和脚本的一些不同点</summary>

1. 函数只能与shell使用相同的语言，脚本可以使用任意语言。因此在脚本中包含 Shebang 是很重要的。<br />

2. 函数仅在定义时被加载，脚本会在每次被执行时加载。这让函数的加载比脚本略快一些，但每次修改函数定义，都要重新加载一次。<br />

3. 函数会在当前的shell环境中执行，脚本会在单独的进程中执行。因此，函数可以对环境变量进行更改，比如改变当前工作目录，脚本则不行。脚本需要使用 `export`将环境变量导出，并将值传递给环境变量。<br />

4. 与其他程序语言一样，函数可以提高代码模块性、代码复用性并创建清晰性的结构。shell脚本中往往也会包含它们自己的函数定义。<br />
</details>

# Shell 工具

## find 指令

```bash
# . 表示当前目录
# 查找所有名称为 src 的文件夹
find . -name src -type d

# 查找所有文件夹路径中包含test的python文件
find . -path '*/test/*.py' -type f

# 查找前一天修改的所有文件
find . -mtime -1

# 查找所有大小在500k至10M的tar.gz文件
find . -size +500k -size -10M -name '*.tar.gz'

#对搜索结果执行 rm 操作
find . -name '*.tmp' -exec rm {} \;
```

[find 命令的 7 种用法](https://blog.csdn.net/weixin_44767040/article/details/124735740)  

## grep 命令

在文件中搜索：  

```bash
$ grep foobar mcd.sh
# foobar
```

文件夹中递归的搜索，需要 flag `-R`：  

```bash
$ grep -R foobar .
./example.sh:    grep foobar $file > /dev/null 2> /dev/null
./example.sh:        echo "File $file does not have any foobar, adding one"
./example.sh:        echo "# foobar" >> $file
./mcd.sh:# foobar
./test2.sh:# foobar
```

[grep 命令常见用法](https://blog.csdn.net/qq_40907977/article/details/107563374)

课程中介绍到了ripgrep（rg）命令，但这是非内置命令，并不具有通用性，故不作记录。需要了解的请自行在网络上搜索。  

## history 命令

`history`命令允许您以程序员的方式来访问 Shell 中输入的历史命令。这个命令会在 STDOUT 中打印 Shell 中的里面命令。如果我们要搜索历史记录，则可以利用管道将输出结果传递给`grep`进行模式搜索。 `history | grep find`会打印包含find子串的命令。  

[linux的history命令](http://t.zoukankan.com/ifme-p-12365394.html)  

组合键`ctrl + R`可以从指令输入历史中搜索对应的指令。  

<details>
<summary>fzf 命令</summary>
<br />
摘抄自<a href=https://github.com/piaoliangkb/missing-semester-2020#fzf-conmand-line-fuzzy-finder>Github上的学习笔记</a><br />
安装：https://github.com/junegunn/fzf#using-linux-package-managers
<br />
使用：

```bash
$ cat example.sh | fzf
```

可以进行模糊搜索。<br />

安装的时候可以选择绑定到 ctrl + R 指令，从而在历史搜索时启用 fzf
</details>


# 课后习题

1. 阅读 man ls ，然后使用ls 命令进行如下操作：

  * 所有文件（包括隐藏文件）
  * 文件打印以人类可以理解的格式输出 (例如，使用454M 而不是 454279954)
  * 文件以最近访问顺序排序
  * 以彩色文本显示输出结果

```bash
$ man ls
$ ls -a
$ ls -h
$ ls --color=auto
$ ls -alhS --color=auto
```

[ls命令常见使用方法](https://blog.csdn.net/Mr_Sudo/article/details/124761409)

2. 编写两个bash函数`marco`和`polo`执行下面的操作。 每当你执行`marco`时，当前的工作目录应当以某种形式保存，当执行`polo`时，无论现在处在什么目录下，都应当`cd`回到当时执行`marco`的目录。 为了方便debug，你可以把代码写在单独的文件`marco.sh`中，并通过`source marco.sh`命令，（重新）加载函数。

```bash
#!/bin/bash

marco(){
    echo "$(pwd)" > $HOME/marco_pwd.log
    echo "save pwd $(pwd)"
}

polp(){
    cd "$(cat "$HOME/marco_pwd.log")"
}
```

```bash
$ vim marco.sh
$ source marco.sh
$ marco
save pwd /home/missing/shell_tools
~/missing/shell_tools$ cd /
/$ polo
~/missing/shell_tools$ 
```
 
3. 假设您有一个命令，它很少出错。因此为了在出错时能够对其进行调试，需要花费大量的时间重现错误并捕获输出。 编写一段bash脚本，运行如下的脚本直到它出错，将它的标准输出和标准错误流记录到文件，并在最后输出所有内容。 加分项：报告脚本在失败前共运行了多少次。

```bash
 #!/usr/bin/env bash

 n=$(( RANDOM % 100 ))

 if [[ n -eq 42 ]]; then
    echo "Something went wrong"
    >&2 echo "The error was using magic numbers"
    exit 1
 fi

 echo "Everything went according to plan"
```

```bash
#! usr/bin/env bash

count=1

while true
do
    ./buggy.sh > stdout.log 2> stderr.log
    if [[ $? -ne 0 ]]; then
        echo "failed after $count times"
        cat stderr.log
        break
    fi
    ((count++))
done
```

4. 本节课我们讲解的`find`命令中的`-exec`参数非常强大，它可以对我们查找的文件进行操作。但是，如果我们要对所有文件进行操作呢？例如创建一个zip压缩文件？我们已经知道，命令行可以从参数或标准输入接受输入。在用管道连接命令时，我们将标准输出和标准输入连接起来，但是有些命令，例如`tar`则需要从参数接受输入。这里我们可以使用`xargs`命令，它可以使用标准输入中的内容作为参数。 例如`ls | xargs rm`会删除当前目录中的所有文件。

您的任务是编写一个命令，它可以递归地查找文件夹中所有的 HTML 文件，并将它们压缩成zip文件。注意，即使文件名中包含空格，您的命令也应该能够正确执行（提示：查看`xargs`的参数`-d`）

```bash
$ mkdir html_folder
$ cd html_folder
$ touch {1..10}.html
$ mkdir html
$ cd html
$ touch test.html
$ cd ..
$ find . -type f -name "*.html" | xargs -d '\n' tar -cvzf html.zip
```

[xargs命令详解](https://www.cnblogs.com/lidabo/p/15662869.html)
[tar命令常用方法](https://blog.csdn.net/bigdatafreedom/article/details/121300876)

5. （进阶）编写一个命令或脚本递归的查找文件夹中最近使用的文件。更通用的做法，你可以按照最近的使用时间列出文件吗？

```bash
find . -type f -mmin -60 -print0 | xargs -0 ls -lt | head -10
```
