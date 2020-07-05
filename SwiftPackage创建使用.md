### 简介

WWDC2019中介绍了Swift Package，用来将代码封装起来以进行复用和后续的版本迭代，本篇文章将创建一个最简单的Swift Package来帮助你快速入门

### 工具

XCode11+Swift5.0

### 创建

1. 打到XCode欢迎页(shift + command + 1)

2. file->new->Swift Package
3. 命名之后选上`Create Git reponsitory on my Mac`(这一步是为了在本地为你创建一个版本管理)
4. （可选）为你的README.md添加说明，添加swift文件到Sources文件夹，在Tests文件夹下加入单元测试
5. command + 2 进入「版本管理Navigator」，右击master文件夹，点击`Tag 'master'`，然后在Tag栏中输入版本号1.0.0然后点击create(这一步相当于对包标记了版本)
6. 右击master文件夹，Create \`包名\` Remote，然后create(这时候就已经创建好了，你可以在你的Github仓库中看到)

### 使用

在需要用到的项目中点击file->Swift Packages-> Add Package Dependency，输入url或者在你自己的github中找到那个仓库，点next，XCode会自动帮你选好版本，最后点击Next就成功了

然后就可以在需要用到的文件中import xxx，然后使用API了

### 我遇到的坑😭

Q：XCode与git push的时候提示failed to connect to raw.githubusercontent.com port 443 connection refused，最后发现是自己原来为了Github提速配置了某服务器进行中转，后台那台服务器崩了之后XCode就会git push失败。

A：解决方法是在我的/etc/hosts 文件中把 代理错误的那一行注释掉

```shell
# 192.30.253.113 github.com
```



Q：关于Swift Package Tag，也就是版本号，刚开始的时候版本号写了诸如'1.0', '1.1', '2.0' 类似的两位版本号，这样会导致在导入package的时候XCode不能识别它的版本号，从而报错：Package Resolution Failed "xxx" could not be resolved: The remote repository could not be accessed. Make sure a valid repository exists at the specified......

A：把版本号写成诸如'1.0.0','1.1.0','2.0.0'这样三位的形式就可以被正确识别，顺便附上一个网址，里面解释了版本号的格式代表了：https://semver.org/lang/zh-CN/

