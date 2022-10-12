---
title: Windows基础
date: 2020-12-23 12:17:38
tags:
- Windows
- 学习笔记
categories:
- [计算机知识, Web渗透]
---

# 系统目录

> Windows  
> Program Files  
> 用户  
> PerfLogs  

* 把某个程序放在“C:\用户（Users）\UserName\AppData\Roaming\Microsoft\Windows\「开始」菜单（Start Menu）\程序（Programs）\启动（Startup）”目录下，对应用户一旦登录系统，它就会自动启动该程序。
* C:\Windows\System32 目录下存放系统配置文件，如无必要请勿乱动
* C:\Windows\System32\config 目录下的'SAM'文件，是用来存放Windows系统用户账号和密码的文件
* C:\Windows\System32\drivers\etc 目录下的'host'文件，是用来解析域名的
* PerfLogs是Windows系统的日志信息，如磁盘扫描错误信息。可以删掉，但不建议删。删掉会降低系统速度。此文件夹是自动生成的。

# 服务

服务是一种应用程序类型，它在后台运行，服务应用程序通常可以在本地和通过网络为用户提供一些功能，例如客户端/服务器应用程序、Web服务器、数据服务器以及其他基于服务器的应用程序。

## 打开服务

右击“计算机/此电脑”打开“管理”  
or  
Win + R 打开运行，输入 services.msc 后回车  

## 服务的作用

* 服务决定了计算机的一些功能是否被启用  
* 不同的服务对应的功能不同  
* 通过计算机提供的服务可以有效实现资源共享  

## 常见的服务

* web服务
* dns服务
* dhcp服务
* 邮件服务
* telnet服务
* ssh服务
* ftp服务
* smb服务

# 端口

计算机“端口”是英文 port 的义译，可以认为是计算机与外界通讯交流的出口。  

按端口号可分为三大类：  

* 公认端口（Well Known Ports）
* 注册端口（Registered Ports）
* 动态 和/或 私有端口（Dynamic and/or Private Ports）

## 端口的作用

我们知道，一台拥有IP地址的主机可以提供许多服务，比如Web服务、ftp服务、SMTP服务等，这些服务完全可以通过1个IP地址来实现。  
显然，主机并不能只靠IP地址来区分不同的网络服务，因为IP地址与网络的关系是一对多的关系。因此，主机实际上是通过“IP地址+端口号”来区分不同服务的。  

需要注意的是，端口并不是一一对应的。比如你的电脑作为客户机访问一台WWW服务器时，WWW服务器使用“80”端口与你的电脑通信，但你的电脑则可能使用“3457”这样的端口。  

## 端口的分类

### 按端口号分布划分

#### 知名端口(Well-Known Ports)

即众所周知的端口号，范围从0到1023，这些端口号一般固定分配给一些服务。  
比如21端口分配给FTP服务，25端口分配给SMTP(简单邮件传输协议)服务，80端口分配给HTTP服务，135端口分配给RPC(远程过程调用)服务等等。  

#### 动态端口(Dynamic Ports)

动态端口的范围从1024到65535，这些端口号一般不固定分配给某个服务，也就是说许多服务都可以使用这些端口。  
只要运行的程序向系统提出访问网络的申请，那么系统就可以从这些端口号中分配一个供该程序使用。  
比如1024端口就是分配给第一个向系统发出申请的程序。在关闭程序进程后，就会释放所占用的端口号。  

* 不过，动态端口也常常被病毒木马程序所利用，如冰河默认连接端口是 7626，WAY 2.4 是 8011，Netspy 3.0 是 7306，YAI 病毒是 1024 等等。

### 按协议类型划分

*按协议类型划分，可以分为TCP、UDP、IP和ICMP(Internet控制消息协议)等端口。下面主要介绍TCP和UDP端口:*

#### TCP端口

即传输控制协议端口，需要在客户端和服务器之间建立连接，这样可以提供可靠的数据传输。  
常见的有FTP服务的21端口，Telnet服务的23端口，SMTP服务的25端口，以及HTTP服务的80端口等。  

#### UDP端口

即用户数据包协议端口，无需在客户端和服务器之间建立连接，安全性得不到保障。
常见的有DNS服务的53端口，SNMP(简单网络管理协议)服务的161端口，QQ使用的8000和4000端口等等。  

## 常见的端口

* HTTP协议代理服务器常用端口号：80/8080/3128/8081/9080  
* FTP(文件传输)协议代理服务器常用端口号：21  
* Telnet(远程登录)协议代理服务器常用端口：23  
* TFTP(Trivial File Transfer Protocol)，默认的端口号为69/udp；  
* SSH(安全登录)、SCP(文件传输)、端口重定向，默认的端口号为22/tcp；  
* SMTP Simple Mail Transfer Protocol(E-mail)，默认的端口号为25/tcp(木马Antigen、Email Password Sender、Haebu Coceda、Shtrilitz Stealth、WinPC、WinSpy都开放这个端口)；  
* POP3 Post Office Protocol(E-mail)，默认的端口号为110/tcp；  
* TOMCAT，默认的端口号为8080；  
* WIN2003远程登陆，默认的端口号为3389；  
* Oracle 数据库，默认的端口号为1521；  
* MS SQL*SERVER数据库server，默认的端口号为1433/tcp 1433/udp；  
* QQ，默认的端口号为1080/udp  

## 黑客通过端口可以干什么

* 信息搜集
* 目标探测
* 服务判断
* 系统判断
* 系统角色分析

# 注册表

注册表(Registry,繁体中文版Windows称之为登录档)是Microsoft Windows中的一个重要的数据库，用于存储系统和应用程序的设置信息。早在Windows3.0推出OLE技术的时候，注册表就已经出现。随后推出的Windows NT是第一个从系统级别广泛使用注册表的操作系统。但是，从MicrosoftWindows 95开始，注册表才真正成为Windows用户经常接触的内容，并在其后的操作系统中继续沿用至今。

## 打开注册表

Win+R 打开运行，输入 regedit 回车即可  

## 注册表的作用

注册表是Windows操作系统中的一个核心数据库，其中存放着各种参数，直接控制着Windows的启动、硬件驱动程序的装载以及一些Windows应用程序的运行，从而在整个系统中起着核心作用。这些作用包括了软、硬件相关配置和状态信息，比如注册表中保存有应用程序和资源管理器外壳的初始条件、首选项和卸载数据等，联网计算机的整个系统的设置和各种许可，文件扩展名与应用程序的关联，硬件部件的描述、状态和属性，性能记录和其他底层的系统状态信息，以及其他数据等。  

## 注册表结构

1. HKEY_CLASSES_ROOT  
管理文件系统。根据在Windows中安装的应用程序的扩展名，该根键指明其文件类型的名称，相应打开该文件所需要调用的程序等等信息。  

2. HKEY_CURRENT_USER  
管理系统当前的用户信息。在这个根键中保存了本地计算机中存放的当前登录的用户信息，包括用户登录用户名和暂存的密码。在用户登录Windows 98时，其信息从HKEY_USERS中相应的项拷贝到HKEY_CURRENT_USER中。  

3. HKEY_LOCAL_MACHINE  
管理当前系统硬件配置。在这个根键中保存了本地计算机硬件配置数据，此根键下的子关键字包括在SYSTEM.DAT中，用来提供HKEY_LOCAL_MACHINE所需的信息，或者在远程计算机中可访问的一组键中。  
这个根键里面的许多子健与System.ini文件中设置项类似。  

4. HKEY_USERS  
管理系统的用户信息。在这个根键中保存了存放在本地计算机口令列表中的用户标识和密码列表。同时每个用户的预配置信息都存储在HKEY_USERS根键中。HKEY_USERS是远程计算机中访问的根键之一。  

5. HKEY_CURRENT_CONFIG  
管理当前用户的系统配置。在这个根键中保存着定义当前用户桌面配置（如显示器等等）的数据，该用户使用过的文档列表（MRU），应用程序配置和其他有关当前用户的Windows 98中文版的安装的信息。  

*常用的有第2个和第3个*  

## 利用注册表防病毒

不少计算机系统感染了网络病毒后，可能会在这些注册表中做修改：

```shell
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServices  #本人计算机 Win10 注册表中没有找到这项
```

还有一些详细列出的方法，我自己在注册表中粗略找了一遍，部分没有找到，故不列出，需要了解的可以网上搜索该**子标题**。  

## 入侵中常用的注册表

[渗透入侵中获取信息常用到的一些注册表键值](https://www.it610.com/article/3510566.htm)  
[入侵检测中需要监控的注册表路径研究](https://www.cnblogs.com/LittleHann/p/4790000.html)  

# DOS命令

[DOS命令大全](https://www.jb51.net/article/87401.htm)  
[黑客必知的DOS命令集合](https://www.cnblogs.com/coder-wzr/p/8086784.html)  
[黑客常用的dos命令](https://www.cnblogs.com/liang-chen/p/11567976.html)  

## 关于AT命令已弃用

[Windows系统中取代AT的schtasks命令](https://blog.csdn.net/mao_mao37/article/details/82592568)  

# 批处理文件

批处理文件是dos命令的组合文件，写在批处理文件的命令会被逐一执行。
后缀名为`.bat`  

## 新建批处理文件

* 新建一个文本文档，保存时把后缀名改为`.bat`  
* 也可以使用命令：  

```raw
copy con 123.net
net user yourname 123123 /add
net localgroup administretors yourname /add
```

然后Ctrl+Z，最后回车  

# Windows系统快捷键

[Windows的常用快捷键(实用篇)](https://www.cnblogs.com/qzqdy/p/8041584.html)  

# 系统优化

## 修改启动项

开始菜单→在搜索程序框中输入"msconfig"命令，打开系统配置窗口后找到“启动”选项。  
该项在Windows任务管理器中可以找到。  

## 加快系统启动速度

同上，打开系统配置窗口后找到“引导”选项（英文系统是“Boot”）。  
点击“高级选项”，此时就可以看到我们将要修改的设置项了。  

## 提高窗口切换速度

右击计算机→属性→高级系统设置→高级选项下性能一栏的设置→视觉效果  
先点击Windows选择计算机的最佳设置→再点击自定义→把最后的勾选去掉→确定  

## 使用工具优化

工具就是软件，没什么好说的，青菜萝卜各有所爱，选用自己合适的就行。  

# 手动清除木马

* 查找开机启动项
* 查询服务
* 查看网络端口连接
