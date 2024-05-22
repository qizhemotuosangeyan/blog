# 结论

- 如果某天你发现你使用的class数据被更新了，但是UI却没有被及时刷新，那么手动的调用objectWillChange.send()可能是最便捷的解决方案



### 实验过程

运行代码



依次点击各个按钮，观察UI变化情况



可以观察到classModel中age1 和 age2的区别：age1运行+1方法后值确实增加了（打印台可以看到打印），但是UI没有被刷新，而是需要手动调用objectWillChage.send()方法才能看到UI变化。



age2和struct都具备「值变化则UI变化」的能力



age2使用@Published标记，并且为了使用@Published，我们让DemoClassModel满足了ObservableObject协议，也就是说在class中使用@Published标记的属性，当其发生变化时，view会收到他的更新变化，从而更新UI。



而age1没有使用@Published标记，所以他的改变我们虽然能从控制台看到打印，但是UI却不知道值发生了变化，所以需要对他的对象调用objectWillChange.send()来手动更新



而对于struct结构的Model，无需使用@Published标记或着objectWillChange.send()手动刷新，UI可以直接感知到它的变化从而更新