---
title: Vim
date: 2022-08-04 17:32:34
categories:
- [计算机知识, 计算机教育中缺失的一课]
tags: 
- Linux
- Vim编辑器
- 学习笔记
---

## Vim 介绍

这还要介绍？只要是学编程的应该都知道，不知道的请在网络上搜索。  

## 编辑模式

* Normal：在文件中移动光标进行浏览或编辑。正常启动 Vim 就是进入 Normal 模式，在此模式下可用其他组合键切换其他模式，在其他模式下按下`Esc`回到 Normal 模式。

* Insert：在 Normal 模式下按下`i`键进入。可插入文本。

* Replace：在 Normal 模式下按下`大写R`键进入。在该模式下会输入直接覆盖掉文本。

* Visual (Line/Block)：在 Normal 模式下按`v`键进入 Visual 模式，按`Shift+v`（大写V）进入 Visual line 模式，按`Ctrl+v`进入 Visual block 模式。可选中文本块。

* Command-line：在 Normal 模式下按下`:`键进入。用于执行命令。

## 基本操作

[vi命令详解](https://blog.csdn.net/cyl101816/article/details/82026678)

### 缓存，标签页，窗口

> Vim 会维护一系列打开的文件，称为“缓存”。一个 Vim 会话包含一系列标签页，每个标签页包含一系列窗口（分隔面板）。每个窗口显示一个缓存。跟网页浏览器等其他你熟悉的程序不一样的是， 缓存和窗口不是一一对应的关系；窗口只是视角。  一个缓存可以在多个窗口打开，甚至在同一个标签页内的多个窗口打开。这个功能其实很好用，比如在查看同一个文件的不同部分的时候。  
> Vim 默认打开一个标签页，这个标签也包含一个窗口。  

### 命令行（command-line）

* `:q`退出当前窗口

* `:w`保存文件

* `:wq`保存并退出当前窗口

* `:qa`退出所有窗口

* `:e {name of file}`打开要编辑的文件

* `:ls`显示打开的缓存

* `:help {topic}`打开帮助，一般格式如下`:help :w`，`:help w`（`:w`和`w`是不一样的，后者表示你在 Normal 模式下按`w`键）。在帮助下输入`:q`，回车后返回 Normal 模式。

* `:sp`分离（seperate）窗口。

## Vim 的接口其实是一种编程语言

“接口”即是指用户与其交互的方式、中介物。

Vim 中的键入操作 （以及他们的助记名） 本身是命令， 这些命令可以组合使用。这使得移动和编辑更加高效，特别是一旦形成肌肉记忆。

### 移动

* 基本移动: `hjkl`（左， 下， 上， 右）（这个操作有点反直觉，也可以用箭头来移动，按自己的习惯就可以）

* 词： `w`（下一个词），`b`（词初），`e`（词尾）

* 行：`0`（行初），`^`（第一个非空格字符），`$`（行尾）

* 屏幕：`H`（屏幕首行），`M`（屏幕中间），`L`（屏幕底部）

** 翻页：`Ctrl+u`（上翻），`Ctrl+d`（下翻）

* 文件：`gg`（文件头），`G`（文件尾）

* 行数：`:{行数}<CR>`或者`{行数}G`({行数}为行数)

* 杂项：`%`（找到配对，比如括号或者 `/* */` 之类的注释对）

* 查找：`f{字符}`，`t{字符}`，`F{字符}`，`T{字符}`

  * 向前(小写)/向后(大写) 查找(f)/到 (t，在该字符的前一位或后一位) 在本行的{字符}

  * `,`/`;`用于导航匹配

* 搜索:`/{正则表达式}`，`n`/`N`用于导航匹配。搜索结束之后输入`enter`转入到第一个结果位置，之后输入`n`跳转到下一个结果位置，`shift + n`跳转到前一个结果位置。

### 编辑

* `i` 进入插入模式

* `O` / `o` 在之上/之下插入行

* `d{移动命令}` 删除 {移动命令}
  * 例如， `dw` 删除词，`d$` 删除到行尾，`d0` 删除到行头，`dd`删除整行

* `c{移动命令}` 改变 {移动命令}
  * 例如， `cw` 改变词，`cc`改变整行
  * 比如 `d{移动命令}` 再 `i`

* `x` 删除字符（等同于 `dl`）

* `s` 替换字符（等同于 `xi`）

* 可视化模式 + 操作
  * 选中文字， `d` 删除 或者 `c` 改变

* `u` 撤销 (Undo)，`Ctrl+r` 重做 (Redo)

* `y` 复制 (yank) （ Vim 内的复制粘贴默认不使用操作系统的剪切板）
  * 例如`yy`复制整行，`yw`复制词，`y4l`复制右侧的4个字符

* `p` 粘贴

* `~` 改变字符的大小写

* `a` 追加

### 计数

* `3w` 向前移动三个词

* `5j` 向下移动5行

* `7dw`或者`d7w` 删除7个词

### 修饰符

修饰符有 `i`，表示“内部”或者“在内”，和 `a`， 表示“周围”。

`ci(` 改变当前括号内的内容
`ci[` 改变当前方括号内的内容
`da'` 删除一个单引号字符串，包括单引号

### 演示

这里是一个有问题的 [fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz) 实现：

（ fizz buzz 是一种输出 1 到 n 的练习，当数字能被 3 整除时，输出 fizz；当数字能被 5 整除时，输出buzz；当数字能同时被 3 和 5 整除时，输出fizzbuzz。若上述条件均没有满足，则直接输出数字）

```py
def fizz_buzz(limit):
    for i in range(limit):
        if i % 3 == 0:
            print('fizz')
        if i % 5 == 0:
            print('fizz')
        if i % 3 and i % 5:
            print(i)

def main():
    fizz_buzz(10)
```

我们会修复以下问题：

* 主函数没有被调用
* 从 0 而不是 1 开始
* 在 5 的整数倍的时候打印 “fizz”
* 在 15 的整数倍的时候在不同行打印 “fizz” 和 “buzz”
* 采用硬编码的参数 10 而不是从命令控制行读取参数

解决：

* 主函数没有被调用
  * `G` 文件尾
  * `o` 向下打开一个新行
  * 输入

    ```python
    if __name__ == '__main__':
        main()
    ```

* 从 0 而不是 1 开始
  * 搜索 `/range`
  * `ww` 向前移动两个词
  * `i` 插入文字， “1, ”
  * `ea` 在 limit 后插入， “+1”

* 在新的一行 “fizzbuzz”
  * `jj$i` 插入文字到行尾
  * 加入 “, end=''”
  * `jj.` 重复第二个打印（在 Vim 中，按下`.`会重复之前的操作）
  * `jjo` 在 if 下打开一行
  * 加入 “else: print()”
  
* 在 5 的整数倍的时候打印 “fizz”
  * 搜索 *`/fizz`，按`n`找到下一个匹配的结果
  * `ci'`改变两个单引号中间的内容为“buzz”

* 命令控制行参数
  * `ggO` 向上打开
  * “import sys”
  * `/10`
  * `ci(` 更改括号内容为 “int(sys.argv[1])”

展示详情请观看[课程视频](https://www.bilibili.com/video/BV1Dy4y1a7BW)。比较上面用 Vim 的操作和你可能使用其他程序的操作。值得一提的是 Vim 需要很少的键盘操作，允许你编辑的速度跟上你思维的速度。

## 自定义 Vim

Vim 由一个位于 `~/.vimrc` 的文本配置文件（包含 Vim 脚本命令）。 你可能会启用很多基本 设置。

我们提供一个文档详细的基本设置，你可以用它当作你的初始设置。我们推荐使用这个设置因为 它修复了一些 Vim 默认设置奇怪行为。在[这儿](https://missing-semester-cn.github.io/2020/files/vimrc)下载我们的设置，然后将它保存成 ~/.vimrc.  

Vim 能够被重度自定义，花时间探索自定义选项是值得的。你可以参考其他人的在GitHub 上共享的设置文件，比如，课程讲师们的 Vim 设置 ([Anish](https://github.com/anishathalye/dotfiles/blob/master/vimrc), [Jon](https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.vim) (uses [neovim](https://neovim.io/)), [Jose](https://github.com/JJGO/dotfiles/blob/master/vim/.vimrc))。 有很多好的博客文章也聊到了这个话题。尽量不要复制粘贴别人的整个设置文件，而是阅读和理解它，然后采用对你有用的部分。  

## 扩展 Vim

Vim 有很多扩展插件。跟很多互联网上已经过时的建议相反，你不需要在 Vim 使用一个插件管理器（从 Vim 8.0 开始）。你可以使用内置的插件管理系统。只需要创建一个 ~/.vim/pack/vendor/start/ 的文件夹，然后把插件放到这里（比如通过 git clone）。  

以下是一些我们最爱的插件：  

* [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim): 模糊文件查找  
* [ack.vim](https://github.com/mileszs/ack.vim): 代码搜索  
* [nerdtree](https://github.com/preservim/nerdtree): 文件浏览器  
* [vim-easymotion](https://github.com/easymotion/vim-easymotion): 魔术操作  

我们尽量避免在这里提供一份冗长的插件列表。你可以查看讲师们的开源的配置文件 ([Anish](https://github.com/anishathalye/dotfiles), [Jon](https://github.com/jonhoo/configs), [Jose](https://github.com/JJGO/dotfiles)) 来看看我们使用的其他插件。 浏览 [Vim Awesome](https://vimawesome.com/) 来了解一些很棒的插件。 这个话题也有很多博客文章：搜索 “best Vim plugins”。  

## Vim 进阶

### 宏

* `q{字符}` 来开始在寄存器`{字符}`中录制宏
* `q`停止录制
* `@{字符}` 重放宏
* 宏的执行遇错误会停止
* `{计数}@{字符}`执行一个宏{计数}次
* 宏可以递归
  * 首先用`q{字符}q`清除宏
  * 录制该宏，用 `@{字符}` 来递归调用该宏 （在录制完成之前不会有任何操作）

## 课后习题

1. 完成 vimtutor。

   在 Linux 的终端里输入：

   ```bash
   $ vimtutor
   ```

   即可打开 Vim 安装时自带的教程。

2. 下载我们提供的 [vimrc](https://missing-semester-cn.github.io/2020/files/vimrc)，然后把它保存到 `~/.vimrc`。 通读这个注释详细的文件 （用 Vim!）， 然后观察 Vim 在这个新的设置下看起来和使用起来有哪些细微的区别。:heavy_check_mark:

3. 安装和配置一个插件： ctrlp.vim. :heavy_check_mark:

4. 练习使用 Vim, 在你自己的机器上重做演示。:heavy_check_mark:

5. 下个月用 Vim 完成_所有的_文件编辑。每当不够高效的时候，或者你感觉 “一定有一个更好的方式”时， 尝试求助搜索引擎，很有可能有一个更好的方式。

6. 在其他工具中设置 Vim 快捷键 （见上面的操作指南）。
:heavy_check_mark:

7. 进一步自定义你的 `~/.vimrc` 和安装更多插件。（在本人虚拟机的 Ubuntu 系统没有找到 `.vimrc` 文件，这里直接挪用官方答案）

   安装插件最简单的方法是使用 Vim 的包管理器，即使用 vim-plug 安装插件：

   * 安装 vim-plug

   ```bash
    $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ```

   * 修改 ~/.vimrc

   ```bash
    call plug#begin()
    Plug 'preservim/NERDTree' #需要安装的插件 NERDTree
    Plug 'wikitopian/hardmode'  #安装 hardmode
    ..... # 更多插件
    call plug#end()
   ```

   * 在 vim 命令行中执行`:PlugInstall`

   ![示例图](https://missing-semester-cn.github.io/missing-notes-and-solutions/2020/solutions//images/3/3.png)

8. （高阶）用 Vim 宏将 XML 转换到 JSON ([例子文件](https://missing-semester-cn.github.io/2020/files/example-data.xml))。

   ```bash
   $ curl -O https://missing-semester-cn.github.io/2020/files/example-data.xml
   $ vim example-data.xml
   ```

   操作：  
   * `Gdd`, `ggdd` 删除第一行和最后一行

   这里`<ESC>`表示按下`Esc`键，空格和逗号不表示分隔，有什么就输入什么。

   * 格式化最后一个元素的宏 （寄存器为`e`）
     * 跳转到第一个有 `<name>` 的行 `qe^r"f>s": "<ESC>f<C"<ESC>q`

   * 格式化一个人的宏（寄存器为`p`）
     * 跳转到有第一个有 `<person> `的行 `qpS{<ESC>j@eA,<ESC>j@ejS},<ESC>q`

   * 格式化一个人然后转到另外一个人的宏（寄存器为`q`）
     * 跳转到有第二个有 `<person>` 的行 `qq@pjq`

   * 执行宏到文件尾 `999@q`

   * 手动移除最后的 `,` 然后在开头行和末尾行加上 `[` 和 `]` 分隔符。

   ```bash
   $ mv example-data.xml example-data.json
   $ vim example-data.json
   ```
