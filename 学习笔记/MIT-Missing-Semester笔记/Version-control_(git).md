---
title: 版本控制
date: 2022-10-26
categories:
- [计算机知识, 计算机教育中缺失的一课]
tags:
- Shell
- Linux
- 学习笔记
---

官方文档: <https://missing.csail.mit.edu/>  
官方文档中文翻译: <https://missing-semester-cn.github.io/>  

版本控制系统 (Version Control Systems - 简称 VCS) 是一类用于追踪源代码（或其他文件、文件夹）改动的工具。顾名思义，这些工具可以帮助我们管理代码的修改历史；不仅如此，它还可以让协作编码变得更方便，在需要他人合作的软件项目上就十分有用了。VCS 通过一系列的快照将某个文件夹及其内容保存了起来，每个快照都包含了文件或文件夹的完整状态。同时它还维护了快照创建者的信息以及每个快照的相关信息等等。  

为什么说版本控制系统非常有用？即使您只是一个人进行编程工作，它也可以帮您创建项目的快照，记录每个改动的目的、基于多分支并行开发等等。和别人协作开发时，它更是一个无价之宝，您可以看到别人对代码进行的修改，同时解决由于并行开发引起的冲突。  

现代的版本控制系统可以帮助您轻松地（甚至自动地）回答以下问题：  

- 当前模块是谁编写的？  
- 这个文件的这一行是什么时候被编辑的？是谁作出的修改？修改原因是什么呢？
- 最近的1000个版本中，何时/为什么导致了单元测试失败？  

尽管版本控制系统有很多，其事实上的标准则是 Git 。而这篇 [XKCD 漫画](https://xkcd.com/1597/) 则反映出了人们对 Git 的评价：  

![git](https://imgs.xkcd.com/comics/git.png)  

因为 Git 接口的抽象泄漏（leaky abstraction）问题，通过自顶向下的方式（从命令行接口开始）学习 Git 可能会让人感到非常困惑。很多时候您只能死记硬背一些命令行，然后像使用魔法一样使用它们，一旦出现问题，就只能像上面那幅漫画里说的那样去处理了。  

尽管 Git 的接口有些丑陋，但是它的底层设计和思想却是非常优雅的。丑陋的接口只能靠死记硬背，而优雅的底层设计则非常容易被人理解。因此，我们将通过一种自底向上的方式向您介绍 Git。我们会从数据模型开始，最后再学习它的接口。一旦您搞懂了 Git 的数据模型，再学习其接口并理解这些接口是如何操作数据模型的就非常容易了。  

## Git 的数据模型

进行版本控制的方法很多。Git 拥有一个经过精心设计的模型，这使其能够支持版本控制所需的所有特性，例如维护历史记录、支持分支和促进协作。  

### 快照

Git 将顶级目录中的文件和文件夹作为集合，并通过一系列快照来管理其历史记录。在Git的术语里，文件被称作 Blob 对象（数据对象），也就是一组数据。目录则被称之为“树”，它将名字与 Blob 对象或树对象进行映射（使得目录中可以包含其他目录）。快照则是被追踪的最顶层的树。例如，一个树看起来可能是这样的：  

```raw
<root> (tree)
|
+- foo (tree)
|  |
|  + bar.txt (blob, contents = "hello world")
|
+- baz.txt (blob, contents = "git is wonderful")
```

这个顶层的树包含了两个元素，一个名为 “foo” 的树（它本身包含了一个blob对象 “bar.txt”），以及一个 blob 对象 “baz.txt”。  

### 历史记录建模：关联快照

VCS 和 快照 有什么关系呢？线性历史记录是一种最简单的模型，它包含了一组按照时间顺序线性排列的快照。不过由于种种原因，Git 并没有采用这样的模型。  

在 Git 中，历史记录是一个由快照组成的有向无环图（DAG）。这代表 Git 中的每个快照都有一系列的“父辈”，也就是其之前的一系列快照。注意，快照具有多个“父辈”而非一个，因为某个快照可能由多个父辈而来。例如，经过合并后的两条分支。  

在 Git 中，这些快照被称为“提交”。通过可视化的方式来表示这些历史提交记录时，看起来差不多是这样的：  

```raw
o <-- o <-- o <-- o
            ^  
             \
              --- o <-- o
```

上面是一个 ASCII 码构成的简图，其中的`o`表示一次提交（快照）。  

箭头指向了当前提交的父辈（这是一种“在…之前”，而不是“在…之后”的关系）。在第三次提交之后，历史记录分岔成了两条独立的分支。这可能因为此时需要同时开发两个不同的特性，它们之间是相互独立的。  

PS：Git 可以将历史分支到两个独立的 Forks，并以一种彼此无关的方式暂时并行处理不同的事情，然后还可以合并来自不同分支的修改。  
通俗点，`o`表示项目快照状态，进行修改后处于其他状态，每个状态指向前一个状态。你可以从某个特定的状态 fork history，如上图即为基于项目主要发展路线的第三个快照版本上创建了一个新的快照。主要路线上的第四个快照可能是添加新功能，而新的快照则只是修复bug。  

开发完成后，这些分支可能会被合并并创建一个新的提交，这个新的提交会同时包含这些特性。新的提交会创建一个新的历史记录，看上去像这样：  

```raw
o <-- o <-- o <-- o <---- o (<- 这个是最新合并提交的)
            ^            /
             \          v
              --- o <-- o
```

Git 中的提交是不可改变的。但这并不代表错误不能被修改，只不过这种“修改”实际上是创建了一个全新的提交记录。而引用（参见下文）则被更新为指向这些新的提交。  

PS：当合并分支的时候，可能会产生意料之外的错误，可能是这个特性实际上改变了一些东西，使得这个 bug 修复变得多余，或者是这个 bug 修复破坏了这个特性。这里的关键就是合并冲突（merge conflicts），这是 git 会尝试做的事情。当你合并你的并行开发分支时，它会尝试以保留所有重要修改的方式来自动合并变更，但如果它觉得代码混淆了，它会报告合并冲突，然后把它交给程序员去弄清楚如何合并不同分支的不同代码到相同的文件上。

### 数据模型及其伪代码表示

以伪代码的形式来学习 Git 的数据模型，可能更加清晰：

```raw
// 文件就是一组数据
type blob = array<byte>

// 一个包含文件和目录的目录
type tree = map<string, tree | blob>

// 每个提交都包含一个父辈，元数据和顶层树
type commit = struct {
    parent: array<commit>    //实际上并不是一个 commit 数组，而是一系列的 ID
    author: string
    message: string
    snapshot: tree    //实际上并不是对象树，而是树的 ID
}
```

这是一种简洁的历史模型。

PS：commit 包含所有其他分支的 commit 以及快照或者相似的东西。实际上它们都是指针，所以 commit 能够通过 ID 引用一系列的父辈（parents）。所有这些对象都是独立存储的，然后可以通过它们的 ID 来对 object（对象）进行引用。

### 对象和内存寻址

Git 中的对象可以是 blob、tree或commit：  

```raw
type object = blob | tree | commit
```

Git 在储存数据时，所有的对象都会基于它们的 [SHA-1 哈希](https://en.wikipedia.org/wiki/SHA-1) 进行寻址。  

```raw
objects = map<string, object>

def store(object):
    id = sha1(object)
    objects[id] = object

def load(id):
    return objects[id]
```

PS：以上均为伪代码。

blobs、trees 和 commits 都一样，它们都是对象。当它们引用其他对象时，它们并没有真正的在硬盘上保存这些对象，而是仅仅保存了它们的哈希值作为引用。  

例如，上面例子中的树（可以通过 `git cat-file -p 698281bc680d1995c5f4caaf3359721a5a58d48d` 来进行可视化），看上去是这样的：  

```bash
100644 blob 4448adbf7ecd394f42ae135bbeed9676e894af85    baz.txt
040000 tree c68d233a33c5c06e0340e4c224f0afca87c8ce87    foo
```

树本身会包含一些指向其他内容的指针，例如 baz.txt (blob) 和 foo (tree)。如果我们用 `git cat-file -p 4448adbf7ecd394f42ae135bbeed9676e894af85`，即通过哈希值查看 baz.txt 的内容，会得到以下信息：  

```bash
git is wonderful
```

### 引用

现在，所有的快照都可以通过它们的 SHA-1 哈希值来标记了。但这也太不方便了，谁也记不住一串 40 位的十六进制字符。  

针对这一问题，Git 的解决方法是给这些哈希值赋予人类可读的名字，也就是引用（references）。引用是指向 commit 的指针。与对象不同的是，它是可变的（引用可以被更新，指向新的 commit ）。例如，`master` 引用通常会指向主分支的最新一次 commit 。  

```raw
references = map<string, string> // map from string to string

def update_reference(name, id):
    references[name] = id

def read_reference(name):
    return references[name]

def load_reference(name_or_id):
    if name_or_id in references:
        return load(references[name_or_id])
    else:
        return load(name_or_id)
```

这样，Git 就可以使用诸如 “master” 这样人类可读的名称来表示历史记录中某个特定的提交，而不需要在使用一长串十六进制字符了。  

有一个细节需要我们注意，通常情况下，我们会想要知道“我们当前所在位置”，并将其标记下来。这样当我们创建新的快照的时候，我们就可以知道它关联哪些快照。在 Git 中，我们当前的位置有一个特殊的索引，它就是 “HEAD”。  

### 仓库

最后，我们可以粗略地给出 Git 仓库的定义了：对象 和 引用。

在硬盘上，Git 仅存储对象和引用：因为其数据模型仅包含这些东西。所有的 `git` 命令都对应着 commit DAG 上的操作，例如增加对象，增加或删除引用。

当您输入某个指令时，请思考一下这条命令是如何对底层的图数据结构进行操作的。另一方面，如果您希望修改 commit DAG，例如“丢弃未提交的修改和将 ‘master’ 引用指向`5d83f9e commit` 时”，有什么命令可以完成该操作（针对这个具体问题，您可以使用 `git checkout master; git reset --hard 5d83f9e`）  

## 暂存区（Staging area）

Git 中还包括一个和数据模型完全不相关的概念，但它确是创建提交的接口的一部分。

就上面介绍的快照系统来说，您也许会期望它的实现里包括一个 “创建快照” 的命令，该命令能够基于当前工作目录的当前状态创建一个全新的快照。有些 VCS 确实是这样工作的，但 Git 不是。我们希望简洁的快照，而且每次从当前状态创建快照可能效果并不理想。例如，考虑如下场景，您开发完了两个功能，你想要创建两个不同的分支。第一个分支包含第一个功能，第二个分支包含第二个。或者，假设您在调试代码时添加了很多打印语句，然后您仅仅希望提交和修复 bug 相关的代码而丢弃所有的打印语句。

Git 处理这些场景的方法是使用一种叫做 “暂存区（staging area）”的机制，它允许您指定下次快照中要包括那些改动。  

## Git 命令行

[git 使用教程，常用命令](https://www.cnblogs.com/wangyk517/p/5821754.html)

为了避免重复信息，我们将不会详细解释以下命令行。强烈推荐您阅读 [Pro Git 中文版](https://git-scm.com/book/zh/v2) 或可以观看本课程的视频来学习。  

### 基础

```raw
git help <command>    //获取 git 命令的帮助信息
git init    //创建一个新的 git 仓库，其数据会存放在一个名为 .git 的目录下
git status    //显示当前的仓库状态
git add <filename>    //添加文件到暂存区
git commit    //创建一个新的提交
git log    //显示历史日志
git log --all --graph --decorate    //可视化历史记录（有向无环图）
git diff <filename>    //显示与暂存区文件的差异
git diff <revision> <filename>    //显示某个文件两个版本之间的差异
git checkout <revision>    //更新 HEAD 和目前的分支
```

- 如何编写 [良好的提交信息](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)!
- 为何要 [编写良好的提交信息](https://chris.beams.io/posts/git-commit/)

### 分支和合并

```raw
git branch    //显示分支
git branch <name>    //创建分支
git checkout -b <name>    //创建分支并切换到该分支，相当于 git branch <name>; git checkout <name>
git merge <revision>    //合并到当前分支
git mergetool    //使用工具来处理合并冲突
git rebase    //将一系列补丁变基（rebase）为新的基线
```

### 远程操作

```raw
git remote    //列出远端
git remote add <name> <url>    //添加一个远端
git push <remote> <local branch>:<remote branch>    //将对象传送至远端并更新远端引用
git branch --set-upstream-to=<remote>/<remote branch>    //创建本地和远端分支的关联关系
git fetch    //从远端获取对象/索引
git pull    //相当于 git fetch; git merge
git clone    //从远端下载仓库
```

### 撤销

```raw
git commit --amend    //编辑提交的内容或信息
git reset HEAD <file>    //恢复暂存的文件
git checkout -- <file>    //丢弃修改
git restore    //git2.32版本后取代git reset 进行许多撤销操作
```

## Git 高级操作

- `git config`: Git 是一个 [高度可定制的工具](https://git-scm.com/docs/git-config)  
- `git clone --depth=1`: 浅克隆（shallow clone），不包括完整的版本历史信息  
- `git add -p`: 交互式暂存  
- `git rebase -i`: 交互式变基  
- `git blame`: 查看最后修改某行的人  
- `git stash`: 暂时移除工作目录下的修改内容  
- `git bisect`: 通过二分查找搜索历史记录  
- `.gitignore`: 指定 故意不追踪的文件  

## 杂项

- 图形用户界面: Git 的 [图形用户界面客户端](https://git-scm.com/downloads/guis) 有很多，但是我们自己并不使用这些图形用户界面的客户端，我们选择使用命令行接口
- Shell 集成: 将 Git 状态集成到您的 shell 中会非常方便。([zsh](https://github.com/olivierverdier/zsh-git-prompt), [bash](https://github.com/magicmonty/bash-git-prompt))。[Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)这样的框架中一般以及集成了这一功能
- 编辑器集成: 和上面一条类似，将 Git 集成到编辑器中好处多多。[fugitive.vim](https://github.com/tpope/vim-fugitive) 是 Vim 中集成 GIt 的常用插件
- 工作流: 我们已经讲解了数据模型与一些基础命令，但还没讨论到进行大型项目时的一些惯例 ( 有[很多](https://nvie.com/posts/a-successful-git-branching-model/) [不同的](https://www.endoflineblog.com/gitflow-considered-harmful) [处理方法](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow))
- GitHub: Git 并不等同于 GitHub。 在 GitHub 中您需要使用一个被称作[拉取请求（pull request）](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests)的方法来向其他项目贡献代码
- 其他 Git 提供商: GitHub 并不是唯一的。还有像 [GitLab](https://about.gitlab.com/) 和 [BitBucket](https://bitbucket.org/) 这样的平台。  

## 资源

- [Pro Git](https://git-scm.com/book/en/v2) ，强烈推荐！学习前五章的内容可以教会您流畅使用 Git 的绝大多数技巧，因为您已经理解了 Git 的数据模型。后面的章节提供了很多有趣的高级主题。（[Pro Git 中文版](https://git-scm.com/book/zh/v2)）；
- [Oh Shit, Git!?!](https://ohshitgit.com/) ，简短的介绍了如何从 Git 错误中恢复；
- [Git for Computer Scientists](https://eagain.net/articles/git-for-computer-scientists/) ，简短的介绍了 Git 的数据模型，与本文相比包含较少量的伪代码以及大量的精美图片；
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/)详细的介绍了 Git 的实现细节，而不仅仅局限于数据模型。好奇的同学可以看看；
- [How to explain git in simple words](https://smusamashah.github.io/blog/2017/10/14/explain-git-in-simple-words)；
- [Learn Git Branching](https://learngitbranching.js.org/) 通过基于浏览器的游戏来学习 Git ；  

## 课后练习

1. 如果您之前从来没有用过 Git，推荐您阅读 [Pro Git](https://git-scm.com/book/en/v2) 的前几章，或者完成像 [Learn Git Branching](https://learngitbranching.js.org/) 这样的教程。重点关注 Git 命令和数据模型相关内容；  

2. Fork [本课程网站的仓库](https://github.com/missing-semester/missing-semester)  
   1. 将版本历史可视化并进行探索  

      ```bash
      git log --all --graph --decorate
      ```

      ![graph](https://s1.imagehub.cc/images/2022/10/31/9AuFJtIonp.png)

   2. 是谁最后修改了 `README.md` 文件？（提示：使用 `git log` 命令并添加合适的参数）   

      ```bash
      git log README.md
      ```

      ![README](https://s1.imagehub.cc/images/2022/10/31/uIA5RoqBwY.png)

   3. 最后一次修改`_config.yml` 文件中 `collections:` 行时的提交信息是什么？（提示：使用 `git blame` 和 `git show`）  

      ```bash
      git blame _config.yml | grep collections
      ```

      ![show](https://s1.imagehub.cc/images/2022/10/31/ZAAYWNOrQa.png)

3. 使用 Git 时的一个常见错误是提交本不应该由 Git 管理的大文件，或是将含有敏感信息的文件提交给 Git 。尝试向仓库中添加一个文件并添加提交信息，然后将其从历史中删除 ([这篇文章也许会有帮助](https://help.github.com/articles/removing-sensitive-data-from-a-repository/))；  

   首先提交一些敏感信息：

   ```bash
   echo "password123">my_password
   git add .
   git commit -m "add password123 to file"
   git log
   ```

   ![log](https://s1.imagehub.cc/images/2022/10/31/JnI9HOSSpF.png)  

   然后使用`git filter-branch`清除提交记录：  

   ```bash
   git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch ./my_password' --prune-empty --tag-name-filter cat -- --all
   ```

   文件和提交记录均已删除：  

   ![file](https://s1.imagehub.cc/images/2022/10/31/C5mt09LP5n.png)  
   ![commit](https://s1.imagehub.cc/images/2022/10/31/uy76fgjIbY.png)  

4. 从 GitHub 上克隆某个仓库，修改一些文件。当您使用 `git stash` 会发生什么？当您执行 `git log --all --oneline` 时会显示什么？通过 `git stash pop` 命令来撤销 `git stash` 操作，什么时候会用到这一技巧？  

   ![stash](https://s1.imagehub.cc/images/2022/10/31/fpWDLoK3jM.png)  
   ![log](https://s1.imagehub.cc/images/2022/10/31/GocBUoywow.png)  
   ![stash pop](https://s1.imagehub.cc/images/2022/10/31/RvpEYkwZqa.png)  

   [git stash 命令实用指南](https://zhuanlan.zhihu.com/p/364339115)  

5. 与其他的命令行工具一样，Git 也提供了一个名为 `~/.gitconfig` 配置文件 (或 dotfile)。请在 `~/.gitconfig` 中创建一个别名，使您在运行 `git graph` 时，您可以得到 `git log --all --graph --decorate --oneline` 的输出结果；  

   ```bash
   [alias]
       graph = log --all --graph --decorate --oneline
   ```

6. 您可以通过执行 `git config --global core.excludesfile ~/.gitignore_global` 在 `~/.gitignore_global` 中创建全局忽略规则。配置您的全局 gitignore 文件来自动忽略系统或编辑器的临时文件，例如 `.DS_Store`；  

   ```bash
   git config --global core.excludesfile ~/.gitignore .DS_Store
   ```

7. 克隆 本课程网站的仓库，找找有没有错别字或其他可以改进的地方，在 GitHub 上发起拉取请求（Pull Request）；  

   首先 fork 本网站仓库，然后克隆 fork 后的仓库，在本地进行修改后，提交到 fork 后的仓库，然后[发起 PR](https://github.com/missing-semester/missing-semester/pulls)
   ![pr](https://missing-semester-cn.github.io/missing-notes-and-solutions/2020/solutions/images/6/12.png)
