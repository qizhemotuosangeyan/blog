### SwiftUI中的辅助功能

##### 辅助功能

帮助残障者打通更多的通道

- 旁白，手势，热键
- Voice Control
- Full keyboard apps

每个按钮拥有一个名称帮助残障人士了解自己需要什么

##### 辅助功能用户接口

- 易于理解的标签
- 易于交互的动作
- 有序的导航和分组

##### SwiftUI中的自动完成辅助功能

已经在代码中了，你的action所引起的值的变化都将会被SwiftUI监测到，并且会被自动的传达给残障人士

图片命名不会被告知残障人士以帮助残障人士了解图片含义，而是需要开发者标记

```swift
Image("CheckmarkGlyph",
    label: Text("Signup Complete!"))
```

Label: "test label"

Value: "Alex"

Trait: "PopUp Button"

##### SwiftUI辅助功能的API

可以为不需要念出来的标签添加辅助功能隐藏选项（就是不读出来）

可以为上下文通畅添加额外需要读出来的文本（平常人看不到）

##### 辅助功能树

这个没看懂。。。。