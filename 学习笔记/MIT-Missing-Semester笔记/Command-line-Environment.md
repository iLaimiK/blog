---
title: 命令行环境
date: 2022-08-16 22:49:27
categories:
- [计算机知识, 计算机教育中缺失的一课]
tags: 
- Linux
- Bash
- 学习笔记
---

# 任务控制（Job Control）

大多数情况下我们中断执行中的任务都是使用`Ctrl+c`来强制停止进程。这里我们研究一下它的工作原理。  

## 结束进程

> Shell 会使用 UNIX 提供的信号机制执行进程间通信。当一个进程接收到信号时，它会停止执行、处理该信号并基于信号传递的信息来改变其执行。就这一点而言，信号是一种*软件中断*。

当我们键入`Ctrl+c`的时候，Shell 会发送`SIGINT`的信号（**Sig**nal **Int**errupt），来让程序停止运行。  

信号列表：（我在虚拟机的 Linux 命令行上输入 `man signal` 后并没有列出各个信号的名字和描述，故在此放出来）  

```bash
No      Name        Default Action      Description
1       SIGHUP      terminate process   terminal line hangup
2       SIGINT      terminate process   interrupt program
3       SIGQUIT     create core image   quit program
4       SIGILL      create core image   illegal instruction
5       SIGTRAP     create core image   trace trap
6       SIGABRT     create core image   abort program (formerly SIGIOT)
7       SIGEMT      create core image   emulate instruction executed
8       SIGFPE      create core image   floating-point exception
9       SIGKILL     terminate process   kill program
10      SIGBUS      create core image   bus error
11      SIGSEGV     create core image   segmentation violation
12      SIGSYS      create core image   non-existent system call invoked
13      SIGPIPE     terminate process   write on a pipe with no reader
14      SIGALRM     terminate process   real-time timer expired
15      SIGTERM     terminate process   software termination signal
16      SIGURG      discard signal      urgent condition present on socket
17      SIGSTOP     stop process        stop (cannot be caught or ignored)
18      SIGTSTP     stop process        stop signal generated from keyboard
19      SIGCONT     discard signal      continue after stop
20      SIGCHLD     discard signal      child status has changed
...
```

这里有一个使用Python脚本来捕获`SIGINT`信号并且忽视它的例子，因为捕获了信号，所以不会导致程序停止。想要停止程序需要使用`SIGQUIT`，输入`Ctrl+\`即可。  

```py
#!/usr/bin/env python
import signal, time

def handler(signum, time):
    print("\nI got a SIGINT, but I am not stopping")

signal.signal(signal.SIGINT, handler)
i = 0
while True:
    time.sleep(.1)
    print("\r{}".format(i), end="")
    i += 1
```

我们向这个程序发送两次`SIGINT`，然后再发送一次`SIGQUIT`。注意，`^`是我们在终端输入`Ctrl`时的表示形式。  

```bash
$ python sigint.py
24^C
I got a SIGINT, but I am not stopping
26^C
I got a SIGINT, but I am not stopping
30^\[1]    39913 quit       python sigint.py
```

无法捕获的信号有`SIGKILL`等，通常情况下，此种信号终止的进程可能会残留子进程，子进程在没有主进程的情况下可能会产生不可预料的行为。  
尽管`SIGINT`和`SIGQUIT`都是常用的终止程序的终端请求，一个更常用的用来停止程序的信号是`SIGTERM`。我们需要使用[kill](https://www.man7.org/linux/man-pages/man1/kill.1.html)命令发送这个信号，语法是`kill -TERM <PID>`。  

## 暂停和后台执行进程

信号除了杀死进程之外还能做一些其他的事情。例如，`SIGSTOP`会让进程暂停。在终端中，键入`Ctrl+Z`会让 Shell 发送`SIGTSTP`信号，`SIGTSTP`是`Terminal Stop`的缩写（即terminal版本的`SIGSTOP`）。  

我们可以使用[fg](https://www.man7.org/linux/man-pages/man1/fg.1p.html)或[bg](http://man7.org/linux/man-pages/man1/bg.1p.html)命令恢复暂停的工作。它们分别表示在前台继续或在后台继续。  

[jobs](http://man7.org/linux/man-pages/man1/jobs.1p.html)命令会列出当前终端会话当中没有结束的任务。你可以使用任务的 pid 来指代这些任务（也可以使用[pgrep](https://www.man7.org/linux/man-pages/man1/pgrep.1.html)来找出pid）。你也可以使用百分号`%`加上任务编号来指代任务，这样更加符合直觉（`jobs`命令会打印出任务编号）。你也可以使用`$!`指代最近的一个任务。  

在 Shell 命令中添加`&`后缀可以让命令在直接在后台运行，这使得你可以直接在 Shell 中继续做其他操作，不过它此时还是会使用 Shell 的标准输出。这点有的时候比较麻烦，可以使用重定向进行处理。  

让已经在运行的进程转到后台运行，你可以键入`Ctrl+Z`，然后紧接着再输入`bg`。注意，后台的进程仍然是你的终端进程的子进程，一旦你关闭终端（会发送另外一个信号`SIGHUP`），这些后台的进程也会终止。为了防止这种情况发生，你可以使用[nohup](https://www.man7.org/linux/man-pages/man1/nohup.1.html)(一个用来忽略`SIGHUP`的封装) 来运行程序。针对已经运行的程序，可以使用`disown`。除此之外，你还可以使用终端多路复用器来实现。  

下面是展示了刚才这些概念的简单例子：

```bash
$ sleep 1000
^Z
[1]  + 18653 suspended  sleep 1000

$ nohup sleep 2000 &
[2] 18745
appending output to nohup.out

$ jobs
[1]  + suspended  sleep 1000
[2]  - running    nohup sleep 2000

$ bg %1
[1]  - 18653 continued  sleep 1000

$ jobs
[1]  - running    sleep 1000
[2]  + running    nohup sleep 2000

$ kill -STOP %1
[1]  + 18653 suspended (signal)  sleep 1000

$ jobs
[1]  + suspended (signal)  sleep 1000
[2]  - running    nohup sleep 2000

$ kill -SIGHUP %1
[1]  + 18653 hangup     sleep 1000

$ jobs
[2]  + running    nohup sleep 2000

$ kill -SIGHUP %2

$ jobs
[2]  + running    nohup sleep 2000

$ kill %2
[2]  + 18745 terminated  nohup sleep 2000

$ jobs
$
```

# 终端多路复用（Terminal Multiplexers）

在使用终端的时候，你通常会同时执行多个任务。比如你想要同时编辑代码和运行程序。尽管打开一个新的终端窗口也能实现，但使用终端多路复用器是一个更好的解决方案。  

像[tmux](https://www.man7.org/linux/man-pages/man1/tmux.1.html)这类的终端多路复用器可以允许我们基于面板(pane)和标签(tab)分割出多个终端窗口，这样你便可以同时与多个 Shell 会话(session)进行交互。  

终端多路复用还可以让我们可以挂起当前终端会话并在将来重新连接。  

这让你操作远端设备时的工作流大大改善，避免了使用`nohup`或是其他类似的操作。  

目前最流行的终端多路复用器是`tmux`，`tmux`可以高度定制，通过快捷键可以创建多个标签页（tab）以及快速在它们之间导航。  

`tmux`的快捷键需要我们掌握，它们都是类似`Ctrl+b x`这样的组合，即需要先按下`Ctrl+b`，松开后再按下`x`。`tmux`中对象的继承结构如下：  

- 会话（Session）- 每个会话都是一个独立的工作区，其中包含一个或多个窗口  
  - `tmux` 开始一个新的会话  
  - `tmux new -s NAME` 以指定名称开始一个新的会话  
  - `tmux ls` 列出当前所有会话  
  - 在`tmux`中输入`Ctrl+b d`，将当前会话挂起  
  - `tmux a`重新连接最后一个会话。可用`-t`来指定具体的会话  

- 窗口（Window）- 相当于编辑器或是浏览器中的标签页，从视觉上将一个会话分割为多个部分  
  - `Ctrl+b c`创建一个新的窗口，使用`Ctrl+d`关闭  
  - `Ctrl+b N` 跳转到第 N 个窗口，注意每个窗口都是有编号的
  - `Ctrl+b p` 切换到前一个窗口
  - `Ctrl+b n` 切换到下一个窗口
  - `Ctrl+b ,` 重命名当前窗口
  - `Ctrl+b w` 列出当前所有窗口

- 面板（Pane）- 像 vim 中的分屏一样，面板使我们可以在一个屏幕里显示多个 Shell  
  - `Ctrl+b "` 水平分割  
  - `Ctrl+b %` 垂直分割  
  - `Ctrl+b <方向>` 切换到指定方向的面板，<方向> 指的是键盘上的方向键  
  - `Ctrl+b z` 切换当前面板的缩放  
  - `Ctrl+b [` 开始往回卷动屏幕。你可以按下空格键来开始选择，回车键复制选中的部分  
  - `Ctrl+b <空格>` 在不同的面板排布间切换  

扩展阅读：[这里](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)是一份 tmux 快速入门教程，而[这一篇](http://linuxcommand.org/lc3_adv_termmux.php) 文章则更加详细，它包含了`screen`命令。你也许想要掌握[screen](https://www.man7.org/linux/man-pages/man1/screen.1.html)命令，因为在大多数 UNIX 系统中都默认安装有该程序。  

中文教程：  
[Tmux 使用教程](https://www.ruanyifeng.com/blog/2019/10/tmux.html)  
[Linux命令之screen命令](https://blog.csdn.net/carefree2005/article/details/122415714)  

## 别名

有的时候输入比较长的命令比较麻烦，尤其是涉及多许多 flag 和选项的时候。出于简化的目的，大多数 Shell 都支持别名。Shell 中的别名相当于长命令的缩写形式，Shell 会自动将其替换成原本的命令。比如，bash中的别名语法如下：  

```bash
alias alias_name="command_to_alias arg1 arg2"
```

注意， `=`两边是没有空格的，因为[alias](https://www.man7.org/linux/man-pages/man1/alias.1p.html)是一个 Shell 命令，它只接受一个参数。  

别名有许多很方便的特性:  

```bash
# 创建常用命令的缩写
alias ll="ls -lh"

# 能够少输入很多
alias gs="git status"
alias gc="git commit"
alias v="vim"

# 手误打错命令也没关系
alias sl=ls

# 重新定义一些命令行的默认行为
alias mv="mv -i"           # -i prompts before overwrite
alias mkdir="mkdir -p"     # -p make parent dirs as needed
alias df="df -h"           # -h prints human readable format

# 别名可以组合使用
alias la="ls -A"
alias lla="la -l"

# 在忽略某个别名
\ls
# 或者禁用别名
unalias la

# 获取别名的定义
alias ll
# 会打印 ll='ls -lh'
```

<details>
<summary>更改 Shell 的名字</summary>
Shell 的名字也是一个环境变量，你可以更改其提示字符串

```bash
bash-5.0$ PS1="> "
> exit
```

</details>
<br/>

注意：默认情况下，别名在 Shell 中并不会永久保存，为了让别名永久生效，你可以将配置写入 Shell 的启动配置文件当中，比如`.bashrc`或`.zshrc`。  

[Linux中如何使用alias命令](https://www.cnblogs.com/linuxprobe/p/15366863.html)

# 配置文件（Dotfiles）

很多程序的配置都是通过纯文本格式的被称作点文件（dotfiles）的配置文件来完成的（之所以称为点文件，是因为它们的文件名以`.`开头，例如`~/.vimrc`。也正因为此，它们默认是隐藏文件，单纯的`ls`并不会显示它们）。  

Shell 也是使用 点文件 进行配置的程序。在启动的时候，Shell 会读取很多文件来载入配置。根据 Shell 的不同，你是否登录或者是否以交互的形式开始，这个过程会有很大的区别并且非常复杂。关于这个话题，[这里](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html)有一个很好的资源。  

对于 Bash 来说，在大多数系统下，你需要编辑`.bashrc`或者`.bash_profile`来进行配置。在文件当中，你可以添加需要在启动的时候执行的命令，比如 别名 或者 配置环境变量。  
实际上，很多程序都会要求你在 Shell 的配置文件当中加入一行类似 `export PATH="$PATH:/path/to/program/bin"`的配置。加入了之后，才能确保这些程序能够被 Shell 找到。  

还有一些其他的工具也可以通过*dotfile*进行配置：  

- bash - `~/.bashrc`,` ~/.bash_profile`  
- git - `~/.gitconfig`  
- vim - `~/.vimrc` 和 `~/.vim` 目录  
- ssh - `~/.ssh/config`  
- tmux - `~/.tmux.conf`  

我们要怎么管理我们的 dotfile 呢？它们应该在它们独自的文件夹下，通过版本控制系统（version control）进行管理，通过脚本将其 [**符号链接**](https://blog.csdn.net/pythondby/article/details/122303443)（*软链接*）到需要的地方。这样做有这些好处：  

- **安装简单**: 如果你登录了一台新的设备，在这台设备上应用你的配置只需要几分钟的时间；  
- **可以执行**: 你的工具在任何地方都以相同的配置工作  
- **同步**: 在一处更新配置文件，可以同步到其他所有地方  
- **变更追踪**: 你可能要在整个程序员生涯中持续维护这些配置文件，而对于长期项目而言，版本历史是非常重要的  

dotfile 中需要放些什么？你可以通过在线文档和帮助手册（manual page）了解所使用工具的设置项。或者在网上搜索有关特定程序的文章，作者们在文章中会分享他们的配置。还有一种方法就是直接浏览其他人的配置文件：你可以在这里找到无数的[dotfiles 仓库](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories) —— 其中最受欢迎的那些可以在[这里](https://github.com/mathiasbynens/dotfiles)找到。[这里](https://dotfiles.github.io/) 也有一些非常有用的资源。  

我们希望你不是仅仅复制粘贴，而是能花点时间阅读一下配置文件当中的细节， 理解这些配置存在的意义以及这么配置的原因。（这里需要你有一定的英语基础）  

本课程的老师们也在 GitHub 上开源了他们的配置文件：[Anish](https://github.com/anishathalye/dotfiles), [Jon](https://github.com/jonhoo/configs), [Jose](https://github.com/jjgo/dotfiles).  

## 可移植性

dotfile 的一个常见痛点是它并不能在不同的设备上生效，如你在不同设备上使用的操作系统或者 Shell 是不一样的，那配置文件是无法生效的。有的时候你可能也会想让特定的配置只在某些设备上生效。  

有一些技巧可以轻松达成这些目的。如果配置 `if 语句`，则你可以借助它针对不同的设备编写不同的配置。例如，你的 shell 可以这样做：  

```bash
if [[ "$(uname)" == "Linux" ]]; then {do_sth}; fi

# 使用和 shell 相关的配置时先检查当前 shell 类型
if [[ "$SHELL" == "zsh" ]]; then {do_sth}; fi

# 针对特定设备进行配置
if [[ "$(hostname)" == "myServer" ]]; then {do_sth}; fi
```

如果配置文件支持 include 功能，你也可以使用include，比如`~/.gitignore`可以这样编写：  

```bash
[include]
    path = ~/.gitconfig_local
```

对于每台机器来说，`~/.gitconfig_local`可以包含独有的一些配置。你甚至可以创建一个专门的代码仓库来追踪管理这些特定的配置。  

在你想要不同的程序共享某些配置的时候，这个思路也一样有用。比如，你想要让`bash`和`zsh`中同时启用一些别名，你可以将这些别名写在`.aliases`当中，然后在这两个 Shell 的配置当中加上：  

```shell
# Test if ~/.aliases exists and source it
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi
```

# 远端连接（Remote Machines）

对于程序员来说，在他们的日常工作中使用远程服务器已经非常普遍了。如果需要使用远程服务器来部署后端程序或需要一个高性能计算的服务器，你就会用到 Secure Shell（SSH）。和其他工具一样，SSH 也是可以高度定制的，也值得我们花时间学习它。  

通过如下命令，你可以使用 ssh 连接到其他服务器：  

```bash
ssh foo@bar.mit.edu
```

这里的`foo`是用户名，`bar.mit.edu`是服务器地址。服务器地址可以是域名也可以是 IP。之后我们将会看到进行 ssh 的配置之后，我们可以仅仅使用 `ssh bar` 来进行登录。  

## 执行命令

ssh 一个经常被忽略的功能是直接执行命令。  

`ssh foobar@server ls`将会在`foobar`设备中home目录下执行`ls`命令。
管道命令同样有效，所以`ssh foobar@server ls | grep PATTERN`将会本地`grep`远程命令`ls`获取的结果。`ls | ssh foobar@server grep PATTERN`将会在远端`grep`本地命令`ls`得到的结果。  

## SSH Keys

基于 key 的验证机制使用了密码学中的公钥来向服务器证明用户持有对应的私钥，而不需要公开其私钥。  
使用这种方法可以避免每次登录都输入密码。不过，私钥相当于你的密码，你需要保管好它。通常存放在`~/.ssh/id_rsa`或者`~/.ssh/id_ed25519`。  

### Key 生成

使用 [ssh-keygen](http://man7.org/linux/man-pages/man1/ssh-keygen.1.html) 命令可以生成公钥和私钥：  

```bash
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519
```

你可以为私钥设置密码，这样可以防止别人用你的私钥访问你的服务器。你可以使用 [ssh-agent](https://www.man7.org/linux/man-pages/man1/ssh-agent.1.html) 或 [gpg-agent](https://linux.die.net/man/1/gpg-agent) ，这样就不需要每次都输入该密码了。  

若你配置过 SSH Key 推送到 GitHub，那么你就已经完成了[这里](https://help.github.com/articles/connecting-to-github-with-ssh/)介绍的步骤，并且已经有了一对密钥。要检查你是否持有密码并验证它，你可以使用这个命令`ssh-keygen -y -f /path/to/key`。  

### 基于 Key 的认证机制

ssh 将会查找`.ssh/authorized_keys`来决定允许哪些用户访问。你可以使用命令将你的公钥拷贝到服务器上：  

```bash
cat .ssh/id_ed25519 | ssh foobar@remote 'cat >> ~/.ssh/authorized_keys'
```

如果支持`ssh-copy-id`的话，可以使用下面这个更简单的命令：  

```bash
ssh-copy-id -i .ssh/id_ed25519.pub foobar@remote
```

## 通过 SSH 复制文件

使用 ssh 复制文件有很多方法：  

- `ssh + tee`, 最简单的方法是执行 `ssh` 命令，然后通过这样的方法利用标准输入实现 `cat localfile | ssh remote_server tee serverfile`。[tee](https://www.man7.org/linux/man-pages/man1/tee.1.html) 命令会将标准输出写入到一个文件；  
- [scp](https://www.man7.org/linux/man-pages/man1/scp.1.html) ：当需要拷贝大量的文件或目录时，使用`scp`命令会更方便，因为它可以遍历相关路径。语法如下：`scp path/to/local_file remote_host:path/to/remote_file`；  
- [rsync](https://www.man7.org/linux/man-pages/man1/rsync.1.html) 对 `scp` 进行了改进，它可以检测本地环境和远程服务器的文件以防止重复拷贝。它还可以提供一些诸如符号连接、权限管理等精心打磨的功能。甚至还可以基于 `--partial`标记实现断点续传。`rsync`的语法和`scp`类似；  

## 端口转发（Port Forwarding）

在许多场景当中，你将会运行一些监听某些端口的程序。当你在本地运行的时候，你可以使用`localhost:PORT`或者`127.0.0.1:PORT`。但当你在服务器上运行时你该如何操作呢？服务器上的端口通常不会通过网络暴露给你。  

此时就需要进行*端口转发*。端口转发有两种：本地端口转发和远程端口转发。（参见下图，该图片引用自[这篇 StackOverflow 文章](https://unix.stackexchange.com/questions/115897/whats-ssh-port-forwarding-and-whats-the-difference-between-ssh-local-and-remot)）  

### 本地端口转发（Local Port Forwarding）

![local](https://i.stack.imgur.com/a28N8.png%C2%A0)

### 远程端口转发（Remote Port Forwarding）

![remote](https://i.stack.imgur.com/4iK3b.png%C2%A0)

最常用的是本地端口转发，即远端服务器上的服务监听了一个端口，你希望将本地设备的一个端口和远程的端口连接起来。  
举个例子，如果我们在远程服务器上的`8888`端口运行了一个`jupyter notebook`。然后我们建立本地`9999`端口的转发，使用`ssh -L 9999:localhost:8888 foobar@remote_server`。这样一来，我们只需要访问本地的`localhost:9999`端口即可。  

## SSH 配置

我们已经介绍了许多参数，为了快捷，我们可以为它们创建别名，例如：  

```bash
alias my_server="ssh -i ~/.id_ed25519 --port 2222 -L 9999:localhost:8888 foobar@remote_server"
```

一劳永逸的方法是配置 config 文件（一般的路径为`~/.ssh/config`）：  

```shell
Host vm
    User foobar
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
    LocalForward 9999 localhost:8888

# 在配置文件中也可以使用通配符
Host *.mit.edu
    User foobar
```

使用`~/.ssh/config`来创建别名，可以让`scp`、`rsync`、`mosh`等等命令都可以读取这个配置并进行利用。  

注意，`~/.ssh/config`也是一个 dotfile ，一般情况下也可以被导入其他配置文件。如果你公开到互联网上，那么其他人也能看到你的一些潜在信息，比如服务器、用户名、开放端口等等，这可能会帮助到那些想要入侵你的黑客，请务必小心。  

远程服务器端的配置文件一般位于 `/etc/ssh/sshd_config`，你可以在其中配置诸如 取消密码验证、修改 ssh 端口、开启 X11 转发 等等。你可以针对每一个用户进行单独设置。  

## 杂项

远程连接服务器的其中一个常见痛点是，当网络环境发生变化、电脑关机/睡眠时会导致断开连接。并且如果连接的延迟很高也很让人绝望。[Mosh](https://mosh.org/)（mobile shell）对 ssh 进行了改进，允许连接漫游、间歇连接以及智能本地回显等等功能。  

有时将远程的文件夹挂载到本地会比较方便，[sshfs](https://github.com/libfuse/sshfs)可以将远程服务器中的一个文件夹挂载到本地，这样你就可以使用本地编辑器进行访问了。  

# Shell & 框架

在 shell 工具和脚本那节课中我们已经介绍了 bash shell，因为它是目前最通用的 shell，大多数的系统都将其作为默认 shell。但是，它并不是唯一的选项。  

例如，zsh shell 是 bash 的超集并提供了一些方便的功能：  

- 智能替换, `**`  
- 行内替换/通配符扩展  
- 拼写纠错  
- 更好的 tab 补全和选择  
- 路径展开 (`cd /u/lo/b` 会被展开为 `/usr/local/bin`)  

**框架**也可以改进你的 shell。比较流行的通用框架包括[prezto](https://github.com/sorin-ionescu/prezto)或[oh-my-zsh](https://ohmyz.sh/)。还有一些更精简的框架，它们往往专注于某一个特定功能，例如[zsh 语法高亮](https://github.com/zsh-users/zsh-syntax-highlighting) 或 [zsh 历史子串查询](https://github.com/zsh-users/zsh-history-substring-search)。 像 [fish](https://fishshell.com/) 这样的 shell 包含了很多用户友好的功能，其中一些特性包括：  

- 向右对齐  
- 命令语法高亮  
- 历史子串查询  
- 基于手册页面的选项补全  
- 更智能的自动补全  
- 提示符主题  

需要注意的是，使用这些框架可能会降低 shell 的性能，尤其是如果这些框架的代码没有优化或者代码过多。你随时可以测试其性能或禁用某些不常用的功能来实现速度与功能的平衡。  

# 终端模拟器（Terminal Emulators）

和自定义 shell 一样，花点时间选择适合你的**终端模拟器**并进行设置是很有必要的。有许多终端模拟器可供你选择（[这里](https://anarc.at/blog/2018-04-12-terminal-emulators-1/)有一些关于它们之间比较的信息）  

你会花上很多时间在使用终端上，因此研究一下终端的设置是很有必要的，你可以从下面这些方面来配置你的终端：  

- 字体选择  
- 彩色主题  
- 快捷键  
- 标签页/面板支持  
- 回退配置  
- 性能（像 [Alacritty](https://github.com/jwilm/alacritty) 或者 [kitty](https://sw.kovidgoyal.net/kitty/) 这种比较新的终端，它们支持GPU加速）  

# 课后练习

## 任务控制

1. 我们可以使用类似`ps aux | grep`这样的命令来获取任务的 pid ，然后您可以基于pid 来结束这些进程。但我们其实有更好的方法来做这件事。在终端中执行 `sleep 10000` 这个任务。然后用 `Ctrl+z` 将其切换到后台并使用 `bg` 来继续允许它。现在，使用 [pgrep](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) 来查找 pid 并使用 [pkill](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) 结束进程而不需要手动输入pid。(提示：: 使用 `-af` 标记)。

![answer](https://s1.imagehub.cc/images/2022/10/08/kEKXarq814.png)

PS: 这里虚拟机表示`-a`为无效选项，查看帮助后发现没有`-a`选项，所以只用了`-f`。

```bash
-a  Include process ancestors in the match list. By default, the current pgrep or pkill process and all of its ancestors are excluded (unless -v is used).
包含匹配列表中的父进程。默认为目前执行 pgrep 或 pkill 命令的进程以及其所有父进程（除非使用了 -v）

-f  Match against full argument lists. The default is to match against process names.
匹配所有参数列表。默认只匹配进程名称。
```

2. 如果您希望某个进程结束后再开始另外一个进程， 应该如何实现呢？在这个练习中，我们使用 `sleep 60 &` 作为先执行的程序。一种方法是使用 [wait](http://man7.org/linux/man-pages/man1/wait.1p.html) 命令。尝试启动这个休眠命令，然后待其结束后再执行 `ls` 命令。

```bash
sleep 60 &
pgrep sleep | wait; ls
```

但是，如果我们在不同的 bash 会话中进行操作，则上述方法就不起作用了。因为 `wait` 只能对子进程起作用。之前我们没有提过的一个特性是，`kill` 命令成功退出时其状态码为 0 ，其他状态则是非0。`kill -0` 则不会发送信号，但是会在进程不存在时返回一个不为 0 的状态码。请编写一个 bash 函数 `pidwait` ，它接受一个 pid 作为输入参数，然后一直等待直到该进程结束。您需要使用 `sleep` 来避免浪费 CPU 性能。

```bash
#!/bin/bash

pidwait()
{
    while kill -0 $1
    do
    sleep 1
    done
    ls
}
```

这里 while 判断的是命令行的返回值而不是布尔值，这个和其他语言有所区别。返回值 0 表示成功所以能够进入循环，参考[这个问题](https://unix.stackexchange.com/questions/185793/why-is-it-while-kill-0-pid-and-not-until-kill-0-pid)

![answer](https://s1.imagehub.cc/images/2022/10/08/zFHxuDwdgy.png)

## 终端多路复用

1. 请完成这个 [tmux 教程](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) ，并参考[这些步骤](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/)来学习如何自定义 tmux。

很好的一个教程，只需要一点英语基础就能看懂。

## 别名

1. 创建一个 `dc` 别名，它的功能是当我们错误的将 `cd` 输入为 `dc` 时也能正确执行。

```bash
alias dc=cd
```

2. 执行 `history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10` 来获取您最常用的十条命令，尝试为它们创建别名。注意：这个命令只在 Bash 中生效，如果您使用 ZSH，使用 `history 1` 替换 `history`。

这里我的虚拟机是经常换来换去的，获取的数据不准确，可以依照个人习惯改别名。

## 配置文件

让我们帮助您进一步学习配置文件：

1. 为您的配置文件新建一个文件夹，并设置好版本控制
2. 在其中添加至少一个配置文件，比如说您的 shell，在其中包含一些自定义设置（可以从设置 `$PS1` 开始）。
3. 建立一种在新设备进行快速安装配置的方法（无需手动操作）。最简单的方法是写一个 shell 脚本对每个文件使用 `ln -s`，也可以使用[专用工具](https://dotfiles.github.io/utilities/)
4. 在新的虚拟机上测试该安装脚本。
5. 将您现有的所有配置文件移动到项目仓库里。
6. 将项目发布到GitHub。

```bash
mkdir ~/dotfiles
git init ~/dotfiles
```

```bash
#!/bin/bash

files="bashrc vimrc "

for file in $files; do
    ln -s ~/dotfiles/$file ~/.$file
done
```

## 远端连接

1. 前往 `~/.ssh/` 并查看是否已经存在 SSH 密钥对。如果不存在，请使用`ssh-keygen -o -a 100 -t ed25519`来创建一个。建议为密钥设置密码然后使用`ssh-agent`，更多信息可以参考 [这里](https://www.ssh.com/ssh/agent)；

这里我本地电脑已经有密钥了，直接使用就行。

2. 在.ssh/config加入下面内容：

```bash
Host vm
    User username_goes_here
    HostName ip_goes_here
    IdentityFile ~/.ssh/id_ed25519
    LocalForward 9999 localhost:8888
```

这里添加我的虚拟机，ssh配置如下：

![config](https://s1.imagehub.cc/images/2022/10/09/bYWQQNrpa5.png)

3. 使用 `ssh-copy-id vm` 将您的 ssh 密钥拷贝到服务器。

本地电脑为Windows，无法使用`ssh-copy-id`，故不进行免密登录。

4. 使用`python -m http.server 8888` 在您的虚拟机中启动一个 Web 服务器并通过本机的`http://localhost:9999` 访问虚拟机上的 Web 服务器

PS：这里用的是低版本的python，所以指令有所不同

![连接](https://s1.imagehub.cc/images/2022/10/09/J5qXFlQNTx.png)

![访问](https://s1.imagehub.cc/images/2022/10/09/N3XwFkIjpV.png)

5. 使用`sudo vim /etc/ssh/sshd_config` 编辑 SSH 服务器配置，通过修改`PasswordAuthentication`的值来禁用密码验证。通过修改`PermitRootLogin`的值来禁用 root 登录。然后使用`sudo service sshd restart`重启 ssh 服务器，然后重新尝试。

这里本地Windows没有用免密验证，所以跳过此题。

6. (附加题) 在虚拟机中安装 [mosh](https://mosh.org/) 并启动连接。然后断开服务器/虚拟机的网络适配器。`mosh`可以恢复连接吗？

[使用 Mosh 来优化 SSH 连接](http://t.zoukankan.com/sunweiye-p-12003616.html)

7. (附加题) 查看 ssh 的`-N` 和 `-f` 选项的作用，找出在后台进行端口转发的命令是什么？

```bash
-N      Do not execute a remote command.  This is useful for just forwarding ports.

-f      Requests ssh to go to background just before command execution.  This is useful if ssh is going to ask for passwords or passphrases, but the user wants it in the background.  This implies -n.  The recommended way to start X11 programs at a remote site is with something like ssh -f host xterm.

If the ExitOnForwardFailure configuration option is set to ``yes'', then a client started with -f will wait for all remote port forwards to be successfully established before placing itself in the background.
```

- -N 就是不执行远端命令，适用于端口转发的情况
- -f 是让 ssh 在执行命令前切换到后台运行

后台进行端口转发的命令:

```bash
ssh -fN -L 9999:localhost:8888 vm
```
