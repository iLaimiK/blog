---
title: 对某手游的拆包记录
date: 2021-01-21 21:56:45
tags:
- Android
- 学习笔记
categories:
- [计算机知识, 软件逆向]
---

`解密函数已失效，本文仅供参考。`

`本人对手游拆包是以学习交流为目的，且不用于任何商业用途。`

## 所需工具

* 安卓模拟器 or Android手机一台
* Visual Studio Code
* [AssetStudio](https://github.com/Perfare/AssetStudio) （原UnityStudio）
* GFLive2DDecrypter（原文件已经很久不更新了，这里也不作提供）

## 游戏数据获取

1. 官网或其他途径获得安装包
2. 安装并运行该手游，下载完整数据包
3. 取得数据包及释放游戏数据

### 演示步骤（以MuMu模拟器为例）

> 在电脑上下载app可直接获得apk文件，以下Step 1为已安装应用的提取方法。

1. 提取安装包

   Android应用安装后，会在系统内部保留一份基础的安装包，属于应用运行的必要文   件，因此只要应用还存在于设备上，该应用安装包就可以随时获取。  
   访问这个安装包需要设备获得Root权限。

   ![打开文件管理器](https://www.z4a.net/images/2021/01/22/step1.png "打开文件管理器")  

   进入模拟器并打开文件管理→设置→常规设置→访问模式→超级用户访问模式→允许  

   设置完毕后，回到文件列表可以看到地址栏为 `/` \ `storage` \ `emulated` \ `0`  

   点击地址栏上的`/`，然后找到data目录，打开后进入app目录，找到该游戏的文件夹，再次打开便可看到其保留的apk文件。  

   将apk文件选中，点击左上角`≡`→内部储存设备→$MuMu共享文件夹→操作(右上角三个点)→粘贴选择项,然后打开模拟器底部的"文件共享"即可。  

   ![文件共享](https://www.z4a.net/images/2021/01/22/step2.png "文件共享")

2. 提取数据包

   打开文件管理器，进入`/` \ `storage` \ `emulated` \ `0` \ `Android` \ `data`，选中目标应用的数据包文件夹，通过任意方式传输到PC上即可。

   ![数据包获取](https://www.z4a.net/images/2021/01/22/step3.png "数据包获取")

3. 释放数据

   将所获取的.apk文件后缀名改为.zip，使用压缩软件进行解压，解压后如图所示。

   ![释放数据](https://www.z4a.net/images/2021/01/22/step4.png "释放数据")

#### 关于判断游戏是否使用Unity引擎

在解压出来的目录中，进入`assets` \ `bin` \ `Data`，若能看到`Managed`与`Resources`两个文件夹，则可以确定游戏为Unity3D制作。

## 提取游戏数据

打开AssetStudio后可看到如下界面：

![界面](https://www.z4a.net/images/2021/01/22/step5.png)

选择Options选项后点击Export options，进行如下设置：（适用于v0.15.32）

![设置](https://www.z4a.net/images/2021/01/22/step6.png "设置")

拆包后加载**安装包内的Data文件夹**以及**数据包内的Android\New文件夹**，可看到游戏文本、立绘等文件。

![Data](https://www.z4a.net/images/2021/01/22/step7.png "Data加载预览")

Filter Type选择All，然后Export → Filtered assets，这样提取出来的文件都是以Asset List预览中的Container路径放置，不会被打乱。

* 一般手游的拆包就到此为止了，其他后续操作都是转换文件类型（比如音频等）或者整合图像（比如立绘等），在此不多作介绍。  

## 其他

我本次目的是为了提取游戏中的Live2D文件，提取出来后发现除了贴图，均为二进制文件，即文件被加密。  

用VS Code查看model.json文件会提示（如图）：  

![VS Code](https://www.z4a.net/images/2021/01/22/step8.png)

而moc文件用IDE打开后发现并没有相关moc的头字符。  

上网搜索了一下，发现有大佬做过该手游的Live2D解密，我甚是高兴。  
但看了看时间，3年前的东西了，但是评论区半年前表示该代码仍然奏效，我自己试了试，果然可行。  

下面贴上代码：（摘自[Live2D|Perfare's Blog](https://www.perfare.net/1162.html)）

```cs GFLive2DDecrypter
public static byte[] Decrypt(byte[] encrypt)
{
    var length = encrypt.Length - 17;
    var v24 = new byte[16];
    var decrypt = new byte[length];
    for (var i = 0; i < 16; i++)
    {
        v24[i] = encrypt[i * 5 + 1];
    }
    var v20 = 0;
    var v10 = -1;
    var v11 = 0;
    do
    {
        var v12 = v10 + 1;
        if (v10 + 1 > 80)
        {
            var v13 = v24[v10 - ((v10 + ((v10 - 16) >> 31 >> 28) - 16) & 0xFFFFFFF0) - 16];
            decrypt[v11] = (byte)(encrypt[v10 + 1] ^ v13);
            v12 = v10 + 1;
            ++v11;
        }
        else
        {
            if (v10 == 5 * (v10 / 5))
            {
                ++v20;
            }
            else if (v10 != -1)
            {
                decrypt[v11++] = (byte)(encrypt[v10 + 1] ^ v24[(v10 - v20) % 16]);
            }
        }
        v10 = v12;
    }
    while (v11 != length);
    return decrypt;
}
```

> 版权属于: [Perfare's Blog](https://www.perfare.net/)
> 原文地址: <https://www.perfare.net/1162.html>
> 转载时必须以链接形式注明原始出处及本声明。

* 注：动作文件也进行了加密。  

顺便一提，原网址中说的解密函数塞在`libLive2DEncryption.so`里，现在已经连文件都荡然无存了。  

### 成果欣赏

眼睛变色可能是录制的问题，其他都没什么大碍。  

![HK416child](https://www.z4a.net/images/2021/01/21/HK416child.gif)

附赠另一款手游的立绘辅助处理工具：  
[AzurLanePaintingExtract](https://github.com/azurlane-doujin/AzurLanePaintingExtract-v1.0)
