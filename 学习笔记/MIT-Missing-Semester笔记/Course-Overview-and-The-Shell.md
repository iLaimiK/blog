---
title: 课程概览与Shell
date: 2022-07-17 01:54:08
categories:
- [计算机知识, 计算机教育中缺失的一课]
tags:
- Shell
- Linux
- 学习笔记
---

官方文档: https://missing.csail.mit.edu/
官方文档中文翻译: https://missing-semester-cn.github.io/

# 为什么要上这门课？

> 作为计算机科学家，我们都知道计算机最擅长帮助我们完成重复性的工作。 但是我们却常常忘记这一点也适用于我们使用计算机的方式，而不仅仅是利用计算机程序去帮我们求解问题。 在从事与计算机相关的工作时，我们有很多触手可及的工具可以帮助我们更高效的解决问题。但是我们中的大多数人实际上只利用了这些工具中的很少一部分，我们常常只是死记硬背一些如咒语般的命令，或是当我们卡住的时候，盲目地从网上复制粘贴一些命令。

本课程为了解决这个问题，将向您展示一些您在日常工作和学习中可以使用的工具，挖掘它们的潜力。我们将教会您如何充分利用您所知道的工具，并教授一些您所不知道的新工具。
在课程中将会展示如何同时使用多个工具来制造出您所想象不到的东西。

# 课程结构

见官方文档或该文档的汉化版。

# The Shell

## 什么是 Shell

当您想在电脑图形界面所允许的行为上做更多的事情时，Shell将会是您和电脑交互的主要方式。图形界面在大多数的时候都是受限制的（我认为这是对于开发人员来说的）。
而基于文本的工具通常是能互相耦合的，也有无数种方法能将它们结合起来，或者用程序使其可以自动化。Shell则是您去实现这些方法的工具。

> 几乎所有您能够接触到的平台都支持某种形式的 shell，有些甚至还提供了多种 shell 供您选择。虽然它们之间有些细节上的差异，但是其核心功能都是一样的：它允许你执行程序，输入并获取某种半结构化的输出。

这里的Shell可以理解为命令行界面(CLI, Command Line Interface)。

> 本节课我们会使用 Bourne Again Shell, 简称 “bash” 。 这是被最广泛使用的一种shell，它的语法和其他的shell都是类似的。打开shell提示符（命令行提示符），您首先需要打开终端(Terminal) 。您的设备通常都已经内置了终端(Terminal)，或者您也可以安装一个，非常简单。

## 使用 Shell

当您打开终端时，它通常看起来是这样的：

```bash
Username@Hostname:~$ 
```

`Username`即是您的用户名，如您作为root登入，该处显示为`root`
`hostname`为您的主机名，这里显示您的主机名称。
`~`的位置符号表示当前的工作目录（“current working directory”）或者说您当前所在的位置(`~`表示 “home目录”)。
`$`符号表示您目前的身份为非root用户。root用户显示为`#`。
这个提示符是可以自定义的，但是默认的一般都是这样。

这是您电脑上和Shell交互的主要文本界面，您可以在命令行提示符上输入命令(command)。

如：

```bash
Username@Hostname:~$ echo hello
hello

```

`echo`是用来打印您传给它的参数的程序，而参数(argument)是一些紧随程序名后面且用空格分隔开的文本。

> 如果您希望传递的参数中包含空格（例如一个名为 My Photos 的文件夹），您要么用使用单引号，双引号将其包裹起来，要么使用转义符号 \ 进行处理（My\ Photos）。

## Shell 是如何运行这些程序的？

Shell，或者说 bash 本身就是一种程序设计语言，您输入的提示符(Prompl)不仅能带参运行程序，您也可以写出 while 循环、for 循环、条件等等，甚至可以定义函数或者变量。

> 类似于 Python 或 Ruby，Shell 是一个编程环境，所以它具备变量、条件、循环和函数。当你在 shell 中执行命令时，您实际上是在执行一段 Shell 可以解释执行的简短代码。如果你要求 Shell 执行某个指令，但是该指令并不是 Shell 所了解的编程关键字，那么它会去咨询 *环境变量(Environment Variable)* `$PATH`，它会列出当 shell 接到某条指令时，进行程序搜索的路径：

```bash
Username@Hostname:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
Username@Hostname:~$ whcih echo
/bin/echo
Username@Hostname:~$ /bin/echo hello
hello
```

> 当我们执行 echo 命令时，Shell 了解到需要执行 echo 这个程序，随后它便会在`$PATH`中搜索由 : 所分割的一系列目录，基于名字搜索该程序。当找到该程序时便执行（假定该文件是*可执行程序*）。确定某个程序名代表的是哪个具体的程序，可以使用`which`程序。我们也可以绕过`$PATH`，通过直接指定需要执行的程序的路径来执行该程序。

## 在Shell中导航

> Shell 中的路径是一组被分割的目录，在 Linux 和 macOS 上使用`/`分割，而在Windows上是`\`。路径`/`代表的是系统的根目录，所有的文件夹都包括在这个路径之下，在Windows上每个盘都有一个根目录（例如：`C:\`）。 我们假设您在学习本课程时使用的是 Linux 文件系统。如果某个路径以`/`开头，那么它是一个*绝对路径*，其他的都是*相对路径*。

*绝对路径*是可以绝对精准地确定一个文件的位置的路径，*相对路径*是相对于您当前所在位置的路径。
要找出我们当前所在的位置在哪里，我们可以使用`pwd`(print working directory)。在bash中输入`pwd`，它就会输出当前所在的目录路径：

```bash
Username@Hostname:~/missing$ pwd
/home/missing
Username@Hostname:~/missing$ cd ..
Username@Hostname:~$ pwd
/home
Username@Hostname:~$ cd ..
Username@Hostname:/$ pwd
/
Username@Hostname:/$ cd ./home
Username@Hostname:~$ cd missing
Username@Hostname:~/missing$ pwd
/home/missing
Username@Hostname:~/missing$ ../../bin/echo hello
hello
```

切换目录需要使用`cd`命令。在路径中，`.`表示的是当前目录，而`..`表示上级目录。

一般情况下，使用命令行运行程序时，程序会默认在当前目录运行，除非您再给程序指定了一个路径。

查看当前目录下包含的文件，可以使用`ls`命令：

```bash
Username@Hostname:~/missing$ ls
Username@Hostname:~/missing$ cd ..
Username@Hostname:~$ ls
missing
Username@Hostname:~$ cd missing/
Username@Hostname:~/missing$ ls ..
missing
Username@Hostname:~/missing$ cd /
Username@Hostname:/$ ls
bin    boot    dev    etc    home
...
Username@Hostname:/$ cd ~/missing
Username@Hostname:~/missing$ cd -
/
Username@Hostname:/$
```

`cd -`命令为从当前目录跳转到您之前工作的上一个目录。

> 除非我们利用第一个参数指定目录，否则`ls`会打印当前目录下的文件。大多数的命令接受标记和选项（带有值的标记），它们以`-`开头，并可以改变程序的行为。通常，在执行程序时使用`-h`或`--help`标记可以打印帮助信息，以便了解有哪些可用的标记或选项。

在帮助信息中，`...`代表可不填或者输入一个或以上的值，`[]`代表选项。

`ls -l`或`ll`表示采用长列表的形式输出信息。表现形式如下：

```bash
Username@Hostname:~$ ls -l
drwxr-xr-x 1 root users 4096 July 15 2022 missing
```

这个参数可以更加详细地列出目录下文件或文件夹的信息。首先，本行第一个字符`d`表示 missing 是一个目录。然后接下来的九个字符，每三个字符构成一组(`rwx`)。 三组从左到右分别代表了文件所有者（root），用户组（users） 以及其他所有人具有的权限。其中`-`表示该用户不具备相应的权限。
从上面的信息来看，只有文件所有者可以修改或者写入（`w`）missing 文件夹 （例如添加或删除文件夹中的文件）。
为了进入某个文件夹，用户需要具备该文件夹以及其父文件夹的“搜索”权限（以“可执行”：`x`权限表示）。
为了列出它的包含的内容，用户必须对该文件夹具备读取权限（`r`）。对于文件来说，权限的意义也是类似的。
注意，/bin 目录下的程序在最后一组，即表示所有人的用户组中，均包含`x`权限，也就是说任何人都可以执行这些程序。

## 重命名、移动、复制、删除文件以及新建文件夹

`mv`命令后面通常会跟随两个路径（path）作为参数，第一个是原有路径，第二个是新的路径。
这也代表着`mv`既可以让你重命名一个文件（在原有位置），也可以让你将文件移动到另一个目录里。
例如：

```bash
Username@Hostname:~/missing$ ls
test.txt
Username@Hostname:~/missing$ mv test.txt test1.txt
Username@Hostname:~/missing$ ls
test1.txt
Username@Hostname:~/missing$ mv test1.txt ../test
Username@Hostname:~/missing$ cd ../test
Username@Hostname:~/test$ ls
test1.txt
```

`cp`（copy）命令可以将文件复制到一个具体的文件名或一个已经存在的目录下，也可以同时复制多个文件到一个指定的目录中。
例如：

```bash
Username@Hostname:~/test$ cp test1.txt ../missing/test.txt
Username@Hostname:~/test$ ls
test1.txt
Username@Hostname:~/test$ cd ../missing
Username@Hostname:~/missing$ ls
test.txt
```

`rm`为remove的缩写，`rm`命令的功能为删除一个目录中的一个或多个文件或目录，它也可以将某个目录及其下的所有文件及子目录均删除。对于链接文件，只是删除了链接，原有文件均保持不变。`rm`是一个危险的命令，使用的时候要特别当心,在执行`rm`之前最好先确认一下在哪个目录，到底要删除什么东西。
例如：

```bash
Username@Hostname:~/missing$ rm ../test/test1.txt
Username@Hostname:~/missing$ ls ../test
Username@Hostname:~/missing$
```

删除一个目录中的一个或多个文件或目录，如欲删除目录必须加上参数`-r`，否则预设仅会删除文件。如果使用`rm`来删除文件，通常仍可以将该文件恢复原状。

`mkdir`命令用来创建目录。如果在目录名的前面没有加任何路径名，则在当前目录下创建由DirName（指定的文件名）命名的文件夹或目录；如果给出了一个已经存在的路径，将会在该目录下创建一个指定的目录。在创建目录时，应保证新建的目录与它所在目录下的文件没有重名。
例如：

```bash
Username@Hostname:~/missing$ mkdir test
Username@Hostname:~/missing$ ll
total 4
drwxr-xr-x. 2 root users    6 July 15 2022 test
```

> 如果您想要知道关于程序参数、输入输出的信息，亦或是想要了解它们的工作方式，请试试`man`这个程序。它会接受一个程序名作为参数，然后将它的文档（用户手册）展现给您。注意，使用`q`可以退出该程序。

```bash
Username@Hostname:~/missing$ man ls
```

`man`的意思是手册、说明书（manual pages），非内置程序。

手动输入`clear`或者同时按下`Ctrl`+`l`可清屏。

## 在程序间创建连接

如果您想把多个程序连接起来或者与文件交互，可以借助“流”（stream）来实现。

> 在 Shell 中，程序有两个主要的“流”：它们的输入流和输出流。 当程序尝试读取信息时，它们会从输入流中进行读取，当程序打印信息时，它们会将信息输出到输出流中。 通常，一个程序的输入输出流都是您的终端。也就是，您的键盘作为输入，显示器作为输出。

Shell提供了重定向这些“流”的方法，可将输入和输出都改到您所指定的地方。
最简单的重定向是`< file`和`> file`。这两个命令可以将程序的输入输出流分别重定向到文件：

```bash
Username@Hostname:~/missing$ echo hello > hello.txt
Username@Hostname:~/missing$ cat hello.txt
hello
Username@Hostname:~/missing$ cat < hello.txt
hello
Username@Hostname:~/missing$ cat < hello.txt > hello2.txt
Username@Hostname:~/missing$ cat hello2.txt
hello
```

您还可以使用`>>`来向一个文件追加内容。使用管道（pipe），我们能够更好的利用文件重定向。`|`操作符允许我们将一个程序的输出和另外一个程序的输入连接起来：

```bash
Username@Hostname:~/missing$ cat < hello.txt >> hello2.txt
Username@Hostname:~/missing$ cat hello2.txt
hello
hello
Username@Hostname:~/missing$ ls -l / | tail -n1
drwxr-xr-x 1 root  root  4096 Jun 20  2022 var
Username@Hostname:~/missing$ ls -l / | tail -n1 > ls.txt
Username@Hostname:~/missing$ cat ls.txt
drwxr-xr-x 1 root  root  4096 Jun 20  2022 var
Username@Hostname:~/missing$ curl --head --silent google.com | grep --i content-length
Content-Length: 219
Username@Hostname:~/missing$ curl --head --silent google.com | grep --i content-length | cut --delimiter=' ' -f2
219
```

## 根用户（root）

在Linux和MacOS中有一个root用户，它相当于Windows的Administrator。
root用户被允许在系统上做出任意的行为，它几乎不受任何限制，可以创建、读取、更新和删除系统中的任何文件，相当于一种“超级用户”。
您通常不会以root用户登录系统，而是用您自己命名的用户登录并操作这个系统。
如果您想用root权限操作，可以使用`sudo`命令，`su`即为Super User的缩写。

> 有一件事情是您必须作为根用户才能做的，那就是向`sysfs`文件写入内容。系统被挂载在`/sys`下，`sysfs`文件则暴露了一些内核（kernel）参数。 因此，您不需要借助任何专用的工具，就可以轻松地在运行期间配置系统内核。注意 Windows 和 macOS 没有这个文件。

例如，您笔记本电脑的屏幕亮度写在 brightness 文件中，它位于

```bash
/sys/class/backlight
```

通过将数值写入该文件，我们可以改变屏幕的亮度。您可能会这样尝试更改：

```bash
$ sudo find -L /sys/class/backlight -maxdepth 2 -name '*brightness*'
/sys/class/backlight/intel_backlight/brightness
$ cd /sys/class/backlight/intel_backlight
$ sudo echo 500 > brightness
An error occurred while redirecting file 'brightness'
open: Permission denied
```

显然，这样会得到一个错误信息。因为输入输出的重定向是通过Shell执行的，而echo等程序并不知道如`|`、`<`、`>`等的存在，它们只知道从自己的输入输出流中进行读写。

> 对于上面这种情况， Shell(权限为您的当前用户)在设置`sudo echo`前尝试打开`brightness`文件并写入，但是系统拒绝了 Shell 的操作因为此时 Shell 的权限不是root用户。

在Stackoverflow上，您可能见到过这样的命令：

```bash
User@localhost:~$ # echo 1 > /sys/net/ipv4_forward
```

上述命令之所以能运行，是因为前面的`#`表明是以root权限运行整条命令。

切换到root用户也很简单，只需要简单的命令：

```bash
User@localhost:~$ sudo su
```

回车后会让您输入密码，密码正确即可以root权限操作Shell。
操作完毕后输入`exit`即可返回原用户权限。

在不使用root权限去更改屏幕亮度，可以这样做：

```bash
$ echo 500 | sudo tee brightness
500
```

`tee`命令用于将标准输入复制到每个指定文件，并显示到标准输出。`tee`指令会从标准输入设备读取数据，将其内容输出到标准输出设备，同时保存成文件。

## 课后练习

1. 在 `/tmp` 下新建一个名为 `missing` 的文件夹。

```bash
User@localhost:~$ cd /tmp
User@localhost:/tmp$ mkdir missing
User@localhost:/tmp$ ls
...
missing
...
```

2. 用`man`查看程序`touch`的使用手册。

```bash
$ man touch

TOUCH(1)                         User Commands                        TOUCH(1)

NAME
       touch - change file timestamps

SYNOPSIS
       touch [OPTION]... FILE...

DESCRIPTION
...
```

3. 用 `touch` 在 `missing` 文件夹中新建一个叫 `semester` 的文件。

User@localhost:/tmp$ cd missing
User@localhost:/tmp/missing$ touch semester

4. 将以下内容一行一行地写入 `semester` 文件：

```bash
#!/bin/sh
curl --head --silent https://missing.csail.mit.edu
```

```bash
User@localhost:/tmp/missing$ echo '#!/bin/sh' > semester
User@localhost:/tmp/missing$ echo "curl --head --silent https://missing.csail.mit.edu" >> semester
User@localhost:/tmp/missing$ cat semester
#!/bin/sh
curl --head --silent https://missing.csail.mit.edu
```

[curl用法指南](https://www.ruanyifeng.com/blog/2019/09/curl-reference.html)

5. 尝试执行这个文件。例如，将该脚本的路径（`./semester`）输入到您的shell中并回车。如果程序无法执行，请使用 ls 命令来获取信息并理解其不能执行的原因。

```bash
$ ./semester
bash: permission denied: ./semester
$ ls -l
total 8
-rw-r--r-- 1 user   user     61 July  20 19:39 semester
```

6. 查看 `chmod` 的手册(例如，使用 `man chmod` 命令)

```bash
$ man chmod
```

[chmod修改权限用法](https://blog.csdn.net/qq_42289214/article/details/87996211)

7. 使用 `chmod` 命令改变权限，使 `./semester` 能够成功执行，不要使用 `sh semester` 来执行该程序。

```bash
$ chmod a=rwx semester
$ ll
total 8
-rwxrwxrwx 1 user   user     61 July  20 19:39 semester
```

8. 使用 `|` 和 `>` ，将 `semester` 文件输出的最后更改日期信息，写入主目录下的 last-modified.txt 的文件中

```bash
$ ./semester | grep last-modified > ~/last-modified.txt
$ cat ~/last-modified.txt
last-modified: Sat, 14 May 2022 10:50:11 GMT
```

9. 写一段命令来从 /sys 中获取笔记本的电量信息，或者台式机 CPU 的温度。

```bash
$ cat /sys/class/power_supply/BAT1/capacity
```
