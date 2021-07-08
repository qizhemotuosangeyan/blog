如果你想要具体按数值指 定字号的话，可以使用 .font(.system(size: 48)) 的方式;除了系统提供的字 体，你也可以通过指定名字，来使用自定义字体: .font(.custom("Copperplate", size: 48))

你也可以使用 Color(_:red:green:blue:) 以提供色 彩空间和 RGB 值来设置颜色。

我们可以为 padding 指定需要填充的方向以及大小，比如: .padding(.top, 16) 将在上方填充 16 point 的空白，.padding(.horizontal, 8) 在水平方向 (也即 [.leading, .trailing]) 填充 8 point。

 (Color 也是一个遵守 View 协议的类型)，你也可以将任意的 View 作为背景元素进行设置。

​      //ForEach:用来列举元素并声称View collection 类型，要求列举的数组必须满足Identifiable协议

​      //"\.self"表示 为某个满足Hashable协议的结构体 产生一个唯一的标识

```swift
print("Button: \(item.title)")
```

小 技 巧: 你 可 以 在 预 览 中 使 用 在ContentView()后 面 添 加 environment(\.colorScheme, .dark) 来快速检查深色模式下的 UI。

  @Binding **var** brain: CalculatorBrain//用@Binding告诉编译器这个属性是引用，配合$将某个属性转换为引用传递给其他结构体



@propertyWrapper 总是包含一个value， 一个wrappedValue，一个projectedValue和一个init

用@Binding来举例，init方法用来接收一些参数然后做一些初始化工作，被包裹的值在每次被读/写时都会自动调用包裹器中的某些方法，本质上直接访问访问的就是wrappedValue，加$访问，访问的就是projectedValue。

wrappedValue有一个get和一个set方法来操作直接访问时的返回值和直接写入时的操作（set自动携带newValue参数，无需声明）



@State 的值，它的所有相关操作和状态改变 都应该是和当前 View 挂钩的，如果你需要在多个View中共享数据，那@State不是很好的选择，如果View和Model有联系那@State成为不可选项

被@ObservedObject包裹的View会订阅ObservableObject

当某个满足ObservableObject协议的数据发生改变时会被广播给订阅者View

```swift
    let objectWillChange = PassthroughSubject<Void, Never>()
//满足ObservableObject的class需要定义一个objectWillChange，Passthrough.......这个类提供的实例会为class提供一个send方法，当值发生改变时向外界发送通知
//PassthroughSubject来自Combine框架

```



实际上，如果我们省略掉自己声明的 objectWillChange，并把属性标记为 @Published，编译器将会帮我们自动完成这件事情。此时View直接持有model无需再将model标记为@Binding，用ContentView订阅（采用@ObservedObjected）

`每当各种View持有的model被他们所更改后，model都会将这种改变 发送给订阅者contentView，contentView就会自动刷新UI`

.sheet：present a view when given condition is  true//用户用手势关闭时，系统会帮你自动把condition set as false

@Published标记Model，View中用@Environment标记model，无需在传递链中传递$model，系统会自动寻找，记得在ContentView初始化的时候（rootView）的时候使用.environment(_)方法为model new一个Model

更多时候我们会希望 UI 上需要显示的内容能和某个中间 类型的属性一一对应，而不是在 View 中再去对数据 model 做变形和计算。在开发中，对于这种 “驱动 View 的 Model” 中间类型，一般被叫做 ViewModel。

1. 如果我们想要 图片可以按照所在的 frame 缩放，需要添加 resizable()。
2. 图片的原始尺寸比例和使用 frame(width:height:) 所设定的长宽比例可能有所 不同。aspectRatio 让图片能够保持原始比例

font 选自体，fontWeight选字重，

.padding(.top, 12)某View与上方间距12

```swift
 Image(systemName: "star")//掉用SF symbol 中的图片符号
//对于符号，直接修改font会比先改frame再改resizable更加方便，否则点击范围过小
```

```swift
/// 使用ViewModifier打包多个同时复用的modifier
struct IconModifierPackage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundColor(.white)
            .frame(width: 30, height: 30, alignment: .center)
    }
}
```

```swift
//为Shape染色：例如RoundRect
.fill(Color.green)
//Shape渐变色填充
.fill(LinearGradient(gradient: Gradient(colors: [Color.white, model.color]), startPoint: .leading, endPoint: .trailing)
```

```swift
//获取Shape的边框，第一个参数是颜色，第二个参数为显示风格
.stroke(model.color, style: StrokeStyle(lineWidth: 4))
```

preview中的VStack代表将多个View放在同一个屏幕中展示

#### 隐式动画

```swift
//在View的modifier链中添加手势触发展开/收起前可添加动画
.animation(.default)
.onTapGesture {
self.expanded.toggle() }
//或者使用多种动画的组合
.animation(
	Animation
  	.linear(duration: 0.5)
  	.delay(0.2)
  	.repeatForever(autoreverse: true)
)
```

#### 显式动画

```swift
.onTapGesture {
    withAnimation(
      .spring(//三个参数
        response: 0.55,
        dampingFraction: 0.425,
				blendDuration: 0
      )
) {
self.expanded.toggle() }
}

```

List 是最传统的构建列表的方式。它接受一个数组，数组中的元素需要遵守 Identifiable 协议。

```swift
protocol Identifiable {
  associatedtype ID : Hashable
  var id: Self.ID{ get }
}
```

List 的默认格式会为 cell 添加额外的默认 padding

ScrollView {}//大括号里接受一堆View（比如ForEach产生的）

LazyVStack/LazyHStack 一样括在原本的VStack/HStack外使其具有懒加载功能



