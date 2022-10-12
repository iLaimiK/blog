---
title: 原神私服搭建流程记录
date: 2022-08-10 03:35:16
categories:
- [计算机知识]
tags: 
- Windows
- MongoDB
- 原神
- 学习笔记
---

```
原神用户协议中的某些条款：

如果您从未经米哈游合法授权的第三方获取米哈游游戏或与米哈游游戏名称相同及/或相似的游戏，将视为您未获得米哈游授权，米哈游无法保证该游戏能够正常使用，并对因此给您造成的损失不予负责。

除非本协议另有约定，否则，未经米哈游事先书面同意，用户不得实施下列行为（无论是营利的还是非营利的）：
（1）复制、翻录、反编译（de-compile）、反汇编（disassemble）、传播和陈列米哈游游戏软件的程序、使用手册和其它图文音像资料的全部或部分内容，或对米哈游游戏软件的任何功能或程序进行反向工程（reverse engineering）；
（2）公开展示和播放米哈游游戏，及/或米哈游游戏服务的全部或部分内容；
（3）出租、销售米哈游游戏及/或利用米哈游游戏从事任何营利或非营利行为；

禁止用户利用米哈游游戏服务从事无关的行为，包括但不限于：
（d）下载、安装或使用未经米哈游游戏授权开发并正式发布的其它任何网络服务或产品；
（e）接收或下载由其他米哈游游戏用户传输非法传播的任何材料；

用户不得通过不正当的手段或其他不公平的手段使用米哈游游戏、米哈游游戏服务或参与米哈游游戏活动，除非中华人民共和国法律允许或米哈游事先书面许可，用户不得从事下列行为：
（4）对游戏软件或者软件运行过程中释放到任何终端内存中的数据、软件运行过程中客户端与服务器端的交互数据，以及软件运行所必需的系统数据，进行复制、修改、增加、删除、挂接运行或创作任何衍生作品，形式包括但不限于使用插件、外挂或非经合法授权的第三方工具/服务接入软件和相关系统；
（6）通过非米哈游开发、授权的第三方软件、插件、外挂、系统，使用米哈游游戏及米哈游游戏服务，或制作、发布、传播非米哈游开发、授权的第三方软件、插件、外挂、系统；
```

> 本文仅供学习或技术交流使用，禁止用于学习研究外的其他目的，请于研究后 24 小时内删除相关资源，此外任何原因导致的法律及版权纠纷均与本人无关，本人不承担连带责任。

# 系统要求

- Windows 10+（本文使用 Windows 在本地搭建）
- Linux（服务器没有空间啦_(:зゝ∠)_ 就……懒得弄了）

# 环境及软件需求

- [Java SE - 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)
- [MongoDB](https://www.mongodb.com/try/download/community)（所需版本为4.0+）
- [MongoDB Compass](https://www.mongodb.com/try/download/compass)（数据库管理[可选]）
- 代理（Proxy）软件（选其一）
    - [mitmproxy](https://mitmproxy.org/)（需配合[Python](https://www.python.org/downloads/)使用）
    - [Fiddler Classic](https://www.telerik.com/download/fiddler)
    - 其他

# 核心

- [Grasscutter](https://github.com/Grasscutters/Grasscutter)（Releases更新不及时，请不要在Releases下载）

# 自行编译服务端文件

确保上面提到的环境均已设置完毕，并安装了其中一款代理（Proxy）软件（本文使用`mitmproxy`）。即可开始获取服务端文件：（需依赖[Git](https://git-scm.com/downloads)）

```shell
git clone https://github.com/Grasscutters/Grasscutter.git # 或使用自己的fork地址

# git clone太慢的话，去百度搜索国内目前可用的Github镜像网站，将上面 github.com 替换为镜像网站，如：
git clone https://hub.fastgit.xyz/Grasscutters/Grasscutter.git
# 请不要盲目复制上面的命令，因为镜像网站随时会失效，还请自行搜索替换，同时请不要登录任何github镜像网站
```

Grasscutter 使用 Gradle 来处理依赖及编译：  

```shell
cd Grasscutter
.\gradlew.bat # 建立开发环境
.\gradlew jar # 编译
```

![编译](https://s1.imagehub.cc/images/2022/08/12/powershell_dll9u5zDg4.png)

编译成功后会在当前目录中发现一个以`.jar`为后缀的服务端核心文件。  

# 服务端资源

为方便后续操作及资源更新，将该`.jar`文件放到另一个目录中，在`jar`文件根目录中创建`resources`文件夹，并将[Resources](https://github.com/Koko-boya/Grasscutter_Resources)里的资源放到`resources`文件夹中。  
此外还需将[Keystore 文件](https://github.com/Grasscutters/Grasscutter/blob/development/keystore.p12)放到`jar`文件的根目录中。  

![Server](https://s1.imagehub.cc/images/2022/08/12/TRkTh24DZH.png "Server目录")
![resources](https://s1.imagehub.cc/images/2022/08/12/u6EQwSS03y.png "\Server\resources目录")

上述资源都是版本更新时需要**覆盖替换**的，`jar`从旧版本升级到新版本还需删除目录下的`config.json`（启动服务端后自动生成）。  

# 运行服务端

在`jar`根目录下打开`cmd`，输入以下命令：  

```shell
java -jar grasscutter-1.2.3-dev.jar
```

此命令为服务端启动命令，请结合实际`.jar`文件名称来输入。  

运行成功应如下图所示：  

![启动Grasscutter](https://s1.imagehub.cc/images/2022/08/12/ry6G2bVTTl.png)  

PS：关闭服务端不可直接关闭该`cmd`窗口，需在该窗口内输入`stop`来关闭。如若不慎关闭了窗口，请在任务管理器中直接杀掉`Java`相关进程。  

# 本地客户端连接

在运行客户端之前，首先需要将客户端请求代理至本地服务器 (同理可代理至运行服务端的云服务器)。  
这里使用的是 mitmproxy 代理工具。  

在`grasscutter`的项目目录内有`proxy.py`和`proxy_config.py`文件，将其复制到`jar`文件的根目录中。  

将证书文件（keystore.p12）导入到“受信任的根证书颁发机构”，双击文件后的一系列设置按默认选项，密码为123456，在证书存储中按下图设置，随后完成导入，在弹出的警告窗口选择“是”。  

![证书存储](https://s1.imagehub.cc/images/2022/08/12/rundll32_qqCpzYSnoz.png)

在目录下打开`cmd`输入命令运行`proxy.py`：  

```shell
mitmdump -s proxy.py --ssl-insecure --listen-port 54321
```

![](https://s1.imagehub.cc/images/2022/08/12/pZkfYvCdAs.png)

运行代理后，关闭现有的系统代理软件，前往系统网络设置，手动设置代理为`127.0.0.1:54321`。  

![代理](https://s1.imagehub.cc/images/2022/08/12/ApplicationFrameHost_AWgvLWwhUd.png)

设置完成后，需要添加 mitmproxy 生成的证书才可以正常进行连接，使用浏览器访问 <http://mitm.it/>，下载对应平台的证书，并根据网页教程添加至 “受信任的根证书颁发机构” 即可。  

PS：使用`Ctrl+c`即可退出 mitmdump  

# 进入游戏

进入游戏前需要创建账号，在服务端的控制台下输入命令：  

```shell
account create [username] [uid]
```

![运行游戏](https://s1.imagehub.cc/images/2022/08/12/xNsLgI3PnM.png)

然后找到本地客户端（原神游戏目录），进入`\Genshin Impact\Genshin Imapct Game`目录，运行`YuanShen.exe`。（不能通过官方启动器运行）  

进入登录界面应显示为`Hoyoverse`，输入刚刚创建的账号用户名，并随便输入一个密码即可进入游戏。  

![登录界面](https://s1.imagehub.cc/images/2022/08/12/YuanShen_0qrG0PA7HT.png)

<details>
<summary>登入后出现4214错误代码解决方案</summary>

在进行下面操作时务必先备份一遍文件，以免操作不当或程序出现问题导致文件损坏或者丢失。

备份操作如下：

在原神游戏目录找到`Managed`文件夹，进入该文件夹，将`Metadata`文件夹整个复制备份至其他地方。（请善用 Windows 内置的文件搜索功能）

![Metadata](https://s1.imagehub.cc/images/2022/08/12/4sdr59sZ5g.png)

1. 自行替换文件

国服点击[这里](https://github.com/577fkj/GenshinProxy/files/9107927/default.zip)下载`metadata-patch`文件。
国际服请点击[这里](https://github.com/577fkj/GenshinProxy/files/9107929/default.zip)下载。
（链接不保证长期有效）

解压后将文件夹内的`global-metadata.dat`文件 与 原神游戏目录内的`/Metadata/global-metadata.dat`替换。
然后运行私服即可进行游玩。
关闭私服后请尽快将上述文件还原为官方提供的文件（即备份），以免因个人疏忽产生不良后果。

2. 使用[该启动器](https://github.com/gc-toolkit/OceanLauncher)解决。

打开启动器，并点击设置：

![OL](https://s1.imagehub.cc/images/2022/08/12/OceanLauncher_uTmr7kLBOB.png)

在设置里填入游戏路径后，往下拉点击`Patch`选项，即可打上 2.8 客户端补丁（用来连接私服的）。
换回官方提供的文件只需点击`Unpatch`即可。
打完补丁后不用在启动器运行游戏，关闭启动器自己运行私服即可。
关闭私服后请尽快打开启动器设置并`Unpatch`（如出现问题请将备份进行复制替换），以免因个人疏忽产生不良后果。
</details>

虽说进入游戏后即可关闭代理，但我不建议关闭代理，因为不知道米哈游还会在客户端做什么手脚。

![游戏内](https://s1.imagehub.cc/images/2022/08/12/YuanShen_O48YYE7E0K.jpg)

# 私服基本操作

## 指令

游戏内需要使用指令来获取各种物品，打开聊天框并添加会话对象`Server`，即可进入控制台（没错，唯一的聊天对象就是游戏内控制台）。

如不出意外，在`jar`文件根目录下已经有各种语言的`Handbook`（即指令手册）了，自己找到简中或繁中的查看即可。
在游戏内向控制台发送指令需加上前缀`!`或`/`，否则无效。

![Handbook](https://s1.imagehub.cc/images/2022/08/12/qS1s24V2zl.png)

<details>
<summary>快速查找私服指令工具</summary>
见项目 <a hetf="https://github.com/jie65535/GrasscutterCommandGenerator"> Grasscutter Tools </a>，支持指令生成、卡池编辑等功能。<br />

网页版 Grasscutter Tools请点击[这里](https://wmn1525.github.io/grasscutterTools/dist/index.html#/)
</details>

## 传送

* 当你想传送到某个地方时，请使用大地图里的游戏内标记功能。
    * 使用鱼钩标记（最后一个）在地图上标记一个点
    * （可选）将地图标记重命名为数字来改写 Y 坐标（即高度，默认 300。）
    * 确认并关闭地图
    * 然后你会看到人物从一个非常高的地方掉落至你标记的位置

## 结束游戏

退出游戏后请及时关闭服务端和代理（proxy），并将网络设置里的代理关闭，把官方提供的原文件替换回去，以免出现不必要的问题。  

# 其他

## 服务端配置文件释义

带`?`的为不太清楚功能，仅为英文翻译。  

```json config.json-v3
{
  // 目录结构
  "folderStructure": {
    "resources": "./resources/",
    "data": "./data/",
    "packets": "./packets/",
    "scripts": "./resources/Scripts/",
    "plugins": "./plugins/"
  },
  // 数据库信息
  "databaseInfo": {
    "server": {
      "connectionUri": "mongodb://localhost:27017",
      "collection": "grasscutter"
    },
    "game": {
      "connectionUri": "mongodb://localhost:27017",
      "collection": "grasscutter"
    }
  },
  // 语言
  "language": {
    "language": "zh_CN",
    "fallback": "en_US",
    "document": "EN"
  },
  // 账户设置
  "account": {
    "autoCreate": false, // 本选项设置为 true时,进入游戏的登录框无需提前使用 account create xxx uid 预注册,没有的账号将会自动注册
    "EXPERIMENTAL_RealPassword": false,
    "defaultPermissions": [],
    "maxPlayer": -1
  },
  //服务端启动信息
  "server": {
    "debugLevel": "NONE", //调试模式，下面两个为调试白名单和黑名单
    "debugWhitelist": [],
    "debugBlacklist": [],
    "runMode": "HYBRID", //运行模式
    // 类型："HYBRID" | "DISPATCH_ONLY" | "GAME_ONLY"
    // HYBRID: 同时运行负载均衡服务器和游戏服务器
    // DISPATCH_ONLY: 仅运行负载均衡服务器
    // GAME_ONLY: 仅运行游戏服务器
    // 如果负载均衡与游戏服务器分开部署的话,就可以在此处做出相应的配置
    "http": {
      "bindAddress": "0.0.0.0", // 绑定的IP地址
      "bindPort": 443, // 通讯SSL端口，本地不需要改，如在服务器则需要更改为其他端口
      "accessAddress": "127.0.0.1", // 外网IP地址
      "accessPort": 0, //外网端口
      // 此项主要是加密证书验证,对应的就是目录中的那个证书文件,默认不需要动他
      "encryption": {
        "useEncryption": true,
        "useInRouting": true,
        "keystore": "./keystore.p12",
        "keystorePassword": "123456"
      },
      // 策略
      "policies": {
        "cors": {
          "enabled": false,
          "allowedOrigins": [
            "*"
          ]
        }
      },
      // 游戏内菜单的功能链接。替换此地址，可以更换为你自己写好的html页面
      "files": {
        "indexFile": "./index.html",
        "errorFile": "./404.html"
      }
    },
    // 服务端运行游戏配置
    "game": {
      "bindAddress": "0.0.0.0", // 绑定的IP地址
      "bindPort": 22102, // 游戏启动端口
      "accessAddress": "127.0.0.1", // 外网IP地址
      "accessPort": 0, // 外网端口
      "loadEntitiesForPlayerRange": 100, // 玩家附近区域加载范围
      "enableScriptInBigWorld": false, // 大世界脚本？
      "enableConsole": true, // 启用控制台
      "kcpInterval": 20, // KCP传输间隔
      "logPackets": "NONE", //日志打包上传？
      "gameOptions": {
        //游戏内仓库存储数量上限
        "inventoryLimits": {
          "weapons": 2000,   //武器
          "relics": 2000,    //圣遗物
          "materials": 2000, //材料
          "furniture": 2000, //家具
          "all": 30000       //总库存
        },
        // 联机角色与角色配队最大值
        "avatarLimits": {
          "singlePlayerTeam": 4,
          "multiplayerTeam": 4
        },
        "sceneEntityLimit": 1000, // 世界怪物数量上限
        "watchGachaConfig": false,  // 监控Gacha配置
        "enableShopItems": true,   //是否开启商店
        "staminaUsage": true,    // 体力条
        "energyUsage": false,  // 元素充能
        //树脂设置
        "resinOptions": {
          "resinUsage": false,  //树脂是否会被消耗
          "cap": 160,           //树脂上限
          "rechargeTime": 480   //树脂补充间隔
        },
        //掉落率
        "rates": {
          "adventureExp": 1.0,  //冒险经验
          "mora": 1.0,          //摩拉
          "leyLines": 1.0       //地脉
        }
      },
      "joinOptions": {
        // 内置控制台发送的欢迎表情
        "welcomeEmotes": [
          2007,
          1002,
          4010
        ],
        // 内置控制台对玩家说的欢迎语句
        "welcomeMessage": "Welcome to a Grasscutter server.",
        // 欢迎游玩 grasscutter 的内置邮件
        "welcomeMail": {
          "title": "Welcome to Grasscutter!",  //邮件标题
          "content": "Hi there!\r\nFirst of all, welcome to Grasscutter. If you have any issues, please let us know so that Lawnmower can help you! \r\n\r\nCheck out our:\r\n\u003ctype\u003d\"browser\" text\u003d\"Discord\" href\u003d\"https://discord.gg/T5vZU6UyeG\"/\u003e\n", //邮件内容
          "sender": "Lawnmower", //发件人
          //第一次登录时赠送你的物品，参考物品对照表使用
          "items": [
            {
              "itemId": 13509,
              "itemCount": 1,
              "itemLevel": 1
            },
            {
              "itemId": 201,
              "itemCount": 99999,
              "itemLevel": 1
            }
          ]
        }
      },
      // 控制台账户信息
      "serverAccount": {
        // 控制台玩家头像
        "avatarId": 10000007,
        // 控制台玩家名片
        "nameCardId": 210001,
        // 控制台玩家冒险等级
        "adventureRank": 1,
        // 控制台玩家世界等级
        "worldLevel": 0,
        // 控制台玩家昵称
        "nickName": "Server",
        // 控制台玩家签名
        "signature": "Welcome to Grasscutter!"
      }
    },
    // 下面的没看明白是什么东西
    "dispatch": {
      "regions": [],
      "defaultName": "Grasscutter",
      "logRequests": "NONE"
    }
  },
  // config.json配置文件的版本信息，根据迭代，版本信息会变化，内部的排版也会变化
  "version": 3
}
```

## 卡池

卡池配置文件为`.\data\Banners.json`，同样的我给一下注释，重复出现的不作二次注释。  

```json
[
    //新手池，这里不建议做任何修改
	{
		"comment": "Beginner's Banner. Do not change for no reason.", 
		"comment4": "4 stars: Noelle", 
		"gachaType": 100, 
		"scheduleId": 803, 
		"bannerType": "EVENT",
		"prefabPath": "GachaShowPanel_A016",
		"previewPrefabPath": "UI_Tab_GachaShowPanel_A016",
		"titlePath": "UI_GACHA_SHOW_PANEL_A016_TITLE",
		"costItemId": 224,
		"costItemAmount10": 8,
		"gachaTimesLimit": 20,
		"beginTime": 0,
		"endTime": 1924992000,
		"sortId": 9999,
		"rateUpItems5": [],
		"rateUpItems4": [1034]
	},
    //常驻池
	{
		"comment": "Standard", //卡池注解
		"gachaType": 200, //gacha类型
		"scheduleId": 893,  //计划ID？（此ID要求唯一）
		"bannerType": "STANDARD", //卡池类型
		"prefabPath": "GachaShowPanel_A022", //卡池大图
		"previewPrefabPath": "UI_Tab_GachaShowPanel_A022", //卡池预览图
		"titlePath": "UI_GACHA_SHOW_PANEL_A022_TITLE", //卡池标题
		"costItemId": 224, //抽取卡池需要消耗的物品
		"beginTime": 0, //卡池开始时间
		"endTime": 1924992000, //卡池结束时间
		"sortId": 1000, //卡池排序，越大越靠前
		"fallbackItems4Pool1": [1006, 1014, 1015, 1020, 1021, 1023, 1024, 1025, 1027, 1031, 1032, 1034, 1036, 1039, 1043, 1044, 1045, 1048, 1053, 1055, 1056, 1064], //基础池包含的4星角色
		"weights5": [[1,75], [73,150], [90,10000]] 
    //五星权重，数组，每个成员由两个数字构成，后一个数字代表前一个数字抽数下出五星的权重，简单点就是 [[1, 出货权重(baseYellowRate)], [最少抽数(softPity), 出货权重], [保底最多抽数(hardPity), 10000]]，详见 https://github.com/Grasscutters/Grasscutter/pull/639
	},
    //角色UP池-1
	{
		"comment": "Character Event Banner 1", //卡池注解
		"comment5": "5 stars: Kaedehara Kazuha", //卡池5星注解
		"comment4": "4 stars: Thoma, Ningguang and Shinakonin Heizou", //卡池4星注解
		"gachaType": 301, 
		"scheduleId": 903,
		"bannerType": "EVENT",
		"prefabPath": "GachaShowPanel_A086",
		"previewPrefabPath": "UI_Tab_GachaShowPanel_A086",
		"titlePath": "UI_GACHA_SHOW_PANEL_A045_TITLE",
		"costItemId": 223,
		"beginTime": 0,
		"endTime": 1924992000,
		"sortId": 9998,
		"rateUpItems4": [1059, 1050, 1027], //卡池 up 的四星
		"rateUpItems5": [1047],             //卡池 up 的五星
		"weights5": [[1,80], [73,80], [90,10000]]
	},
    //角色UP池-2
	{
		"comment": "Character Event Banner 2",
		"comment5": "5 stars: Klee",
		"comment4": "4 stars: Thoma, Ningguang and Shinakonin Heizou",
		"gachaType": 400,
		"scheduleId": 923,
		"bannerType": "EVENT",
		"prefabPath": "GachaShowPanel_A087",
		"previewPrefabPath": "UI_Tab_GachaShowPanel_A087",
		"titlePath": "UI_GACHA_SHOW_PANEL_A018_TITLE",
		"costItemId": 223,
		"beginTime": 0,
		"endTime": 1924992000,
		"sortId": 9998,
		"rateUpItems4": [1059, 1050, 1027],
		"rateUpItems5": [1029],
		"fallbackItems5Pool2": [],                 //基础池包含的5星角色
		"weights5": [[1,80], [73,80], [90,10000]]
	},
    //武器池
	{
		"comment": "Weapon Event Banner",
		"comment5": "5 stars: Freedom-Sworn, Lost Prayer to the Sacred Winds",
		"comment4": "4 stars: The Alley Flash, Rainslasher, Favonius Lance, The Widsith, Mitternachts Waltz",
		"gachaType": 302,
		"scheduleId": 913,
		"bannerType": "WEAPON",
		"prefabPath": "GachaShowPanel_A088",
		"previewPrefabPath": "UI_Tab_GachaShowPanel_A088",
		"titlePath": "UI_GACHA_SHOW_PANEL_A013_TITLE",
		"costItemId": 223,
		"beginTime": 0,
		"endTime": 1924992000,
		"sortId": 9997,
		"rateUpItems4":[11410, 12405, 13407, 14402, 15412],
		"rateUpItems5": [11503, 14502],
		"fallbackItems5Pool1": [],         //基础池包含的5星武器
		"weights4": [[1,600], [7,600], [8,6600], [10,12600]],
		"weights5": [[1,100], [62,100], [73,7800], [80,10000]],
		"eventChance4": 75,     //四星为 up 的概率
		"eventChance5": 75      //五星为 up 的概率
	}
]
```

新增卡池的话，只需增加`gachaType`为非文件中的值，且`scheduleId`的值不重复即可。注意客户端只识别以上四个`gachaType`值，添加的其他卡池不会显示类型。  
要修改卡池图片和标题的话，可以到[荼蘼云盘](https://pan.tomys.top/s/dkZCZ?password=blnuot)里找到`原神卡池顺序_V<version>_byTomyJan.xlsx`下载查看。随后修改对应参数项的值中的`A0**`为你想要的卡池ID。  

下面是全物品卡池的参数：  

```json
{
  "gachaType":888,
  "scheduleId":514,
  "prefabPath":"GachaShowPanel_A009",  //可能无效
  "previewPrefabPath":"UI_Tab_GachaShowPanel_A009",  //可能无效
  "titlePath":"UI_GACHA_SHOW_PANEL_A009_TITLE",  //可能无效
  "costItem":224,
  "beginTime":0,
  "endTime":2147472000,
  "sortId":1000,
  "rateUpItems4":[],
  "rateUpItems5":[],
  "fallbackItems3":[1062,11301,11302,11303,11304,11305,11306,12301,12302,12303,12304,12305,12306,13301,13302,13303,13304,14301,14302,14303,14304,14305,14306,15301,15302,15303,15304,15305,15306],
  "fallbackItems4Pool1":[1001,1006,1014,1015,1020,1021,1023,1024,1025,1027,1031,1032,1034,1036,1039,1043,1044,1045,1048,1050,1053,1055,1056,1064],
  "fallbackItems4Pool2":[11401,11402,11403,11404,11405,11406,11407,11408,11409,11410,11412,11413,11414,11415,12401,12402,12403,12404,12405,12406,12407,12408,12409,12410,12411,12412,12414,12416,13401,13402,13403,13404,13405,13406,13407,13408,13409,13414,13415,13416,14401,14402,14403,14404,14405,14406,14407,14408,14409,14410,14412,14413,14414,14415,15401,15402,15403,15404,15405,15406,15407,15408,15409,15410,15411,15412,15413,15414,15415,15416],
  "fallbackItems5Pool1":[1002,1003,1005,1007,1016,1022,1026,1029,1030,1033,1035,1037,1038,1041,1042,1046,1047,1049,1051,1052,1054,1057,1058,1063,1066],
  "fallbackItems5Pool2":[11501,11502,11503,11504,11505,11509,11510,12501,12502,12503,12504,12510,13501,13502,13504,13505,13507,13509,14501,14502,14504,14506,14509,15501,15502,15503,15507,15508,15509],
  "removeC6FromPool":false,    //是否避免命座溢出
  "autoStripRateUpFromFallback":false,       //是否自动避免 up 被基础池抽中
  "weights4":[[1,510],[8,510],[10,10000]],   
  "weights5":[[1,75],[73,150],[90,10000]],
  "poolBalanceWeights4":[[1,255],[17,255],[21,10455]],    //四星角色和武器平衡机制（仅混合池有效）
  "poolBalanceWeights5":[[1,30],[147,150],[181,10230]],   //五星角色和武器平衡机制（仅混合池有效）
  "eventChance4":50,
  "eventChance5":50,
  "bannerType":"EVENT"
}
```

## 数据库管理

这里需要用到 MongoDB Campass  

下面的操作需要你在私服内拥有了人物，如没有人物，请进入游戏内输入指令获取。  

### 修改角色等级/突破阶段/天赋

1. 打开 MongoDB Campass 并连接到私服服务端数据库（默认 URI 是 mongodb://localhost:27017）
2. 选择`Databases`>`grasscutter`>`avatars`
3. [可选]将`VIEW`设置成 JSON 视图，如图：

![JSON View](https://s1.imagehub.cc/images/2022/08/12/x7DM7fWPnr.png)

4. 在`FILTER`（过滤）输入`{avaterId: 角色id}`，`角色id`是对应`Handbook`中 Avatars （第一项）下面的ID，该ID恒为8位数。随后点击`FIND`即可。

![筛选](https://s1.imagehub.cc/images/2022/08/12/QmgooOVR73.png)

5. 在下方文本区域进行编辑修改

![默认视图](https://s1.imagehub.cc/images/2022/08/12/N0I6jb3WEQ.png "MongoDB Campass默认视图")
![JSON View](https://s1.imagehub.cc/images/2022/08/12/8VRyFXXdCL.png "MongoDB Campass JSON 视图")
{.gallery data-height="220"}

- 等级修改 - `level`的对应值（1~90）
- 突破阶段修改 - `promoteLevel`的对应值（0~6）
- 天赋修改 - 展开`proudSkillList`
  - 解锁角色突破第1阶段（即升至20级并突破）后获得的天赋，在`proudSkillList`的方括号`[]`内添加`XX2101,`，`XX`为`avaterId`的值的最后两位数，`,`是非末尾行都必须添加的符号。
  - 解锁角色突破第4阶段（即升至60级并突破）后获得的天赋，在`proudSkillList`的方括号`[]`内添加`XX2201,`。

- 天赋等级修改 - 展开`skillLevelMap`,修改花括号`{}`内键的对应值（1~10）

![修改例图](https://s1.imagehub.cc/images/2022/08/13/drvYDfXpIm.png)

6. 修改完毕后点击`REPLACE`即可完成编辑。

最后重启服务端和客户端使修改后的数据库生效。  

### 修改武器/圣遗物

重复操作不再赘述  

1. 连接后选择`Databases`>`grasscutter`>`items`

2. 在`FILTER`（过滤）输入`{itemId: 物品id}`，`物品id`是对应`Handbook`中 Items （第二项）下面的ID（武器ID恒为5位数且以1开头，圣遗物ID也恒为5位数，具体圣遗物对应ID在`Handbook`里查找）。随后点击`FIND`即可。

3. 在下方文本区域进行编辑修改

- 武器

![武器](https://s1.imagehub.cc/images/2022/08/12/MznGeCzD97.png)

- 等级修改 - `level`的对应值（1~90）
- 突破阶段修改 - `promoteLevel`的对应值（0~6）
- 精炼等阶修改 - `refinement`的对应值（0~4 分别对应 精1~精5）

![修改例图](https://s1.imagehub.cc/images/2022/08/12/fLTj6k0zVT.png)

- 圣遗物

![圣遗物](https://s1.imagehub.cc/images/2022/08/12/W2ymgxQe2s.png)

- 强化等级 - `level`的对应值（1~21 分别对应 +0 ~ +20）
- 总经验 - `totalExp`的对应值（满级圣遗物均为`270475`）
- 主词条 - `mainPropId`的对应值，主词条ID可在 GrasscutterTools 工具里查找（较为高效）。
- 副词条 - 展开`appendPropIdList`，对方括号`[]`内的值进行增添/修改，副词条ID可在 GrasscutterTools 工具里查找（较为高效）。同一个副词条ID多次出现为该词条数值多次叠加（游戏内数值为“副词条数值×副词条ID出现次数”）

4. 修改完毕后点击`REPLACE`即可完成编辑。

最后重启服务端和客户端使修改后的数据库生效。  

# 参考资料

[原神私服 Grasscutter 搭建指南 - 2.7 更新](https://blog.dsrkafuu.net/post/2022/genshin-grasscutter/)  
[记录关于原神私服搭建的详细流程与心得](https://www.mryunqi.com/archives/102)  
[GenshinTJ - 荼蘼博客](https://blog.tomys.top/2022-04/GenshinTJ/)
[【原神】知名二次元游戏Grasscutter常见问题及Config.json配置文件以及服务端命令详解](https://7yog.cn/archives/204.html)  
