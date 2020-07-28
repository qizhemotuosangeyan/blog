优化app启动（app launch）

### 什么是启动(launch)

app启动是用户体验的中断

产品的启动不像用户期待的那样，说明代码也不想你们期待的那样

### 不同类型的启动有哪些

- 🐢cold launch

长时间没启动：从磁盘到内存到进程生成

- 🐰warm launch

应用已经在内存中

- 🐺Resume launch

### 如何将启动页分解为不同的子阶段

400ms内完成第一个页面的渲染可以让用户看cold launch如同resume launch般迅速，其中系统需要大概100ms的时间初始化必要组件，400ms加载时间结束后，app应当是可以交互的即使现在部分需要异步加载数据的地方还放着占位符

1、==DYLD：系统加载共享库合框架==

#### 建议

- 避免链接未使用的库

- 避免动态库加载比如dlopen(), NSBundle.load()

- 硬链接所有依赖项



2、==libSystemInit：系统组件初始化，有固定的时间成本（开发者不需要关注）==

3、==Static Runtime Initialization ：初始化编程语言的runtime==

#### 建议

- 不推荐使用静态初始化，当自己的框架使用了静态初始化时。应当尽早暴露专用API。不得不使用静态初始化时推荐将代码移出launch 然后加上懒加载



4、UIKit Initialization：初始化UIApplication和UIApplicationDelegate



5、Application Initialization：iOS12之前使用的delegate，之后使用地delegate+scence

6、第一帧渲染

#### 建议

- 减少试图层次中的视图个数
- 懒加载
- 减少不需要的视图约束

7、拓展阶段：数据回掉对视图的更新

### 评估启动时间

- 消除网络干扰和后台进程干扰

### 建议

- 重启设备后等待两三分钟
- 确保飞行模式或模拟网络开启
- 测试时使用不变的iCloud账户和不变的数据，或者完全注销iCloud