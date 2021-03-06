## 写在前面

本篇博客帮助iOS开发者创建一个很简单的机器学习模型，并使用它

### 1、创建一个机器学习工程

![截屏2020-07-17 下午5.41.08](%E7%AE%80%E5%8D%95%E7%9A%84%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E6%A8%A1%E5%9E%8B.assets/%E6%88%AA%E5%B1%8F2020-07-17%20%E4%B8%8B%E5%8D%885.41.08.png)

- 本次使用ImageClassifier 进行学习![截屏2020-07-17 下午5.42.18](%E7%AE%80%E5%8D%95%E7%9A%84%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E6%A8%A1%E5%9E%8B.assets/%E6%88%AA%E5%B1%8F2020-07-17%20%E4%B8%8B%E5%8D%885.42.51.png)
- ==请不要像我一样使用中文命名，因为后面会出现问题，==

## 2、为学习工程提供分类好的文件以供学习

在这里进行选择对应文件夹![截屏2020-07-17 下午5.44.36](%E7%AE%80%E5%8D%95%E7%9A%84%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E6%A8%A1%E5%9E%8B.assets/%E6%88%AA%E5%B1%8F2020-07-17%20%E4%B8%8B%E5%8D%885.44.36.png)此处我选择的ImageData文件夹里有两个文件夹，分别是Royal(皇室战争游戏截图)和NoRoyal(其他截图)，![截屏2020-07-17 下午5.54.06](%E7%AE%80%E5%8D%95%E7%9A%84%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E6%A8%A1%E5%9E%8B.assets/%E6%88%AA%E5%B1%8F2020-07-17%20%E4%B8%8B%E5%8D%885.54.06.png)![截屏2020-07-17 下午5.47.27](%E7%AE%80%E5%8D%95%E7%9A%84%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E6%A8%A1%E5%9E%8B%E4%BB%A5%E5%8F%8A%E5%9C%A8app%E4%B8%AD%E4%BD%BF%E7%94%A8.assets/%E6%88%AA%E5%B1%8F2020-07-17%20%E4%B8%8B%E5%8D%885.48.32.png)![截屏2020-07-17 下午9.33.00](%E7%AE%80%E5%8D%95%E7%9A%84%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E6%A8%A1%E5%9E%8B%E4%BB%A5%E5%8F%8A%E5%9C%A8app%E4%B8%AD%E4%BD%BF%E7%94%A8.assets/%E6%88%AA%E5%B1%8F2020-07-17%20%E4%B8%8B%E5%8D%889.33.00.png)

## 3、开始训练

点击Train开始学习![截屏2020-07-17 下午5.49.24](%E7%AE%80%E5%8D%95%E7%9A%84%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E6%A8%A1%E5%9E%8B.assets/%E6%88%AA%E5%B1%8F2020-07-17%20%E4%B8%8B%E5%8D%885.49.24.png)

这个就是训练好的模型了：

![截屏2020-07-17 下午5.50.03](%E7%AE%80%E5%8D%95%E7%9A%84%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E6%A8%A1%E5%9E%8B.assets/%E6%88%AA%E5%B1%8F2020-07-17%20%E4%B8%8B%E5%8D%885.50.03.png)

您可以拖拽一个新的图片问问机器他是不是皇室战争游戏截图，机器会告诉你它的选择和它对自己做出选择的自信![截屏2020-07-17 下午5.51.20](%E7%AE%80%E5%8D%95%E7%9A%84%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E6%A8%A1%E5%9E%8B.assets/%E6%88%AA%E5%B1%8F2020-07-17%20%E4%B8%8B%E5%8D%885.51.20.png)

![截屏2020-07-17 下午5.51.58](%E7%AE%80%E5%8D%95%E7%9A%84%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E6%A8%A1%E5%9E%8B.assets/%E6%88%AA%E5%B1%8F2020-07-17%20%E4%B8%8B%E5%8D%885.51.58.png)

## 4、在工程中使用



![截屏2020-07-17 下午9.30.10](%E7%AE%80%E5%8D%95%E7%9A%84%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E6%A8%A1%E5%9E%8B.assets/%E6%88%AA%E5%B1%8F2020-07-17%20%E4%B8%8B%E5%8D%889.30.10.png)

url可以换成可用的图片url。

工程文件同时打包了，您可以解压运行查看

## 5、写在最后

上方示例代码的编写方式不符合swift响应式编程的思想，使用闭包处理数据流动仅仅是为了便于理解。