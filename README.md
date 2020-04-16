**翻译再创作自swiftui-lab，侵删。**

**您可以查看英文原版：**https://swiftui-lab.com/alignment-guides/

AlignmentGuide功能强大，但通常未得到充分利用的**布局工具**。在许多情况下，它可以帮助我们避免复杂的选择，例如(anchor preferences)，正如您所看到的，对齐方式的更改也可以很简单的设置为动画

代码https://gist.github.com/swiftui-lab/c84a9cfd7fd022bcb4a33636ca88d646

但是，如果您尝试使用AlignmentGuide，你可能对结果会感到困惑，它们更趋向于“你期待它们做什么”，除非它们不会。因为目前我们处于SwiftUI的早期阶段，所有有时会你会觉得这只是一个bug，然后就去想别的解决方案。

在花了一些时间测试AlignmentGuide的所里范围之后，我得出了它们的工作方式。但是我同时产生了一些困惑：没有一整套完整有效的方法去面对它。当我们忽略它们的时候，事情就开始变得不顺利了。我整篇文章都想告诉你：“==每个视图都拥有一个alignmentGuide==”(EVERY VIEW inside a container, has an alignment guide.)

在本文中，我将尝试消除刚才的困惑，目标明确，出发。代码可以让您直观的看到在对齐过程中发生了什么

看完之后，您应该对AlignmentGuide能做什么不能做什么有了判断力

#### 什么是一个AlignmentGuide

一个AlignmentGuide基于一个数字，它在视图中设置一个点，这个点用来确定如何根据附近的其他视图来约束它自己。可以注意到，alignment可以是垂直的或者是水平的，为了继续阐述这一概念，我们从水平的alignment入手

假设我们有三个视图（A，B和C），它们的水平参考线(guide)是0，20，10。由于参考线的存在，三个视图将被调整至：以A为参考，B和C分别偏移了20和10![截屏2020-04-15 上午12.40.21](SwiftUI-alignmentGuide-%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B8%83%E5%B1%80%E5%9F%BA%E7%A1%80.assets/%E6%88%AA%E5%B1%8F2020-04-15%20%E4%B8%8A%E5%8D%8812.40.21.png)

同样的，竖直的alignment也是如此![截屏2020-04-15 上午12.40.42](SwiftUI-alignmentGuide-%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B8%83%E5%B1%80%E5%9F%BA%E7%A1%80.assets/%E6%88%AA%E5%B1%8F2020-04-15%20%E4%B8%8A%E5%8D%8812.40.42.png)

根据这个例子，您应该也注意到了这样一个事实：水平alignment需要一根竖线来约束，竖直alignment需要一根水平的线来约束，乍一看很奇怪，但是仔细想想好像确实这么回事儿。

#### 什么是ZStack

稍后我们将使用ZStack，但是您应该知道ZStack同时需要水平和垂直Aligement

#### 疑惑的产生

我认为首先要解决的问题是：您可能在很多地方使用.lead和.training等代码，但是在每种情况下，它们的含义完全不同![截屏2020-04-15 上午12.47.19](SwiftUI-alignmentGuide-%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B8%83%E5%B1%80%E5%9F%BA%E7%A1%80.assets/%E6%88%AA%E5%B1%8F2020-04-15%20%E4%B8%8A%E5%8D%8812.47.19.png)

别慌，我们将深入研究这些参数中的每一个，这里就是吓唬吓唬你，一会儿您就会感到真相大白。

**Container Alignment**：他有两个目的，它指明了哪些alignmentGuide是需要忽略的，而哪些是不需要忽略的。但是，他同样为所有没有明确指定alignmentGuide的视图隐式的定义了alignmentGuide（相当于提供默认alignmetGuide？）

**Alignment Guide**: 除非这个值与ContainerAlignment匹配，否则，这个alignmentGuide在约束(layout)的时候将被忽略

**Implicit Alignment Value**: 它是一个数值，明确了它所修改的guide的位置，有一些方便的预设值，比如d[.leading], d[.center],等等。但是最终返回的还是一个数字。

**Explicit Alignment Value**：同样是一个数字值，指明了它所修改guide的位置，这是一个明确的值，也就是您通过编程方式定义的值

**Frame Alignment**：明确了某个特定的 View Group 中的各个View是如何对齐的

**Text Alignment**: 对于多行的文本视图，他指定文本行在文本视图内如何对齐

#### 隐式VS显式

==容器中的每个视图都拥有一个alignment==，着重标记是因为它是最重要的概念之一。我们通过调用.alignmentGuide()来定义对齐方式时，对齐方式是显式的，没有调用的话就是隐式的。隐式对齐的值由容器视图中的alignment参数提供（比如：VStack(alignment: .leading)），稍后我们将看到这些值是什么。

你可能想知道，如果不给VStack，HStack或者ZStack制定对齐参数会发生什么，好吧它们确实有默认值：他们都是.center，很容易记住

#### ViewDimensions

到目前为止，我们已经看到在alignmentGuide()方法的computeValue闭包中将alignmentGuide应返回一个CGFloat。如果我们没有可用于处理的数据，那么计算这样一个数字可能会比较吃力，还好我们做到了，让我们来研究.alignmentGuide()的方法声明

```swift
func alignmentGuide(_ g: HorizontalAlignment, computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View
func alignmentGuide(_ g: VerticalAlignment, computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View
```

这是一个重写的方法，有两个版本，一个用来水平参考线，一个用来垂直参考线。有意思的是，这种方法为computeValue闭包提供了ViewDimensions类型的参数。这个类型是一个结构体，其中包含一些有关我们要为其创建alignmentGuide的视图有用的信息

```swift
public struct ViewDimensions {
    public var width: CGFloat { get } // 视图的宽
    public var height: CGFloat { get } // 视图的高

    public subscript(guide: HorizontalAlignment) -> CGFloat { get }
    public subscript(guide: VerticalAlignment) -> CGFloat { get }
    public subscript(explicit guide: HorizontalAlignment) -> CGFloat? { get }
    public subscript(explicit guide: VerticalAlignment) -> CGFloat? { get }
}
```

除了两个一眼就能看懂的属性宽和高之外，出现了几个令人费解的下标：它们接收水平Alignment或者竖直Alignment作为他们的索引，让我们来看看如何访问它们

```swift
Text("Hello")
    .alignmentGuide(HorizontalAlignment.leading, computeValue: { d in                        
        return d[HorizontalAlignment.leading] + d.width / 3.0 - d[explicit: VerticalAlignment.top]
    })
```

随后当我们探索水平Alignment和竖直Alignment以及Alignment类型的时候，您将马上就看懂这些值的含义

#### 对齐方式含糊不清

大多数时候，我们不需要像这样指定对比的全名

```swift
d[HorizontalAlignment.leading] + d.width / 3.0 - d[explicit: VerticalAlignment.top]
```

编译器可以推断出我们是在谈论水平Alignment还是竖直Alignment，因此可以简单的写成这样：

```swift
d[.leading] + d.width / 3.0 - d[explicit: .top]
```

然而，在某些情况下，编译器可能会抱怨alignment的不明确，尤其是在使用.center的时候。这是因为.center值有两种类型：水平Alignment和竖直Alignment，您可能需要指定全名，正如某些示例中的一样， 一会我们将看到。

#### 水平Alignment种类

当使用水平Alignment的索引访问ViewDimension值的时候，我们可以获得视图的前边缘，视图的中心或视图的后边缘

```swift
extension HorizontalAlignment {
    public static let leading: HorizontalAlignment//前边缘
    public static let center: HorizontalAlignment//中心
    public static let trailing: HorizontalAlignment//后边缘
}
```

请注意⚠️：有两种方法指定索引

```swift
d[.trailing]
d[explicit: .trailing]
```

前一种是隐式值，这意味着给定alignment类型的默认值：.lead通常为0，.center为width/2.0，.trailing为width

后一种是获取给定alignmentGuide的显示值。比如：在ZStack中，计算显式的.lead值时最好参考.top的显式值，如果您喜欢这样做，当时是可以的，虽然不太常见，但需要注意的是：它将返回一个CGFloat，因为不是所有的view都有明确的alignmentGuide

#### 竖直的Alignment种类

竖直的Alignment工作方式和水平的一样，但是他除了.top, .center, .bottom之外还有.firstTextBaseline和.lastTextBaseline（第一条文本基准线和最后一条文本基准线）

```swift
extension VerticalAlignment {
    public static let top: VerticalAlignment
    public static let center: VerticalAlignment
    public static let bottom: VerticalAlignment
    public static let firstTextBaseline: VerticalAlignment
    public static let lastTextBaseline: VerticalAlignment
}
```

#### Alignment种类

如前所述，ZStack容器需要指定两种对齐方式。因此将这两种Alignment类型结合在一起描述，例如：如果我们想要顶部的竖直alignment和前面(左侧)的水平alignment对齐，我们有两种选择

```swift
ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) { ... }
```

```swift
ZStack(alignment: .topLeading) { ... }
```

//🤔现在你可能觉得前一种做法就是徒劳的，不过一会我们开始使用自定义alignmentGuide的时候，第一个选项就有意义了

#### Container Alignment（容器对齐）

*这里的Container指的是VStack,HStack和ZStack*

Container中的alignment参数有两个作用:

   			1. 确定哪些.alignmentGuide()与布局有关，在布局期间，将忽略所有与容器参数中对齐方式不同的对齐方式
   			2. 它给哪些没有显示alignment的Container提供了隐式的alignmentGuide()

在下面的动画中，您可以看到更改容器中的alignment参数将如何影响布局期间的alignmentGuide

![截屏2020-04-15 上午2.20.40](SwiftUI-alignmentGuide-%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B8%83%E5%B1%80%E5%9F%BA%E7%A1%80.assets/%E6%88%AA%E5%B1%8F2020-04-15%20%E4%B8%8A%E5%8D%882.20.40.JPG)

![截屏2020-04-15 上午2.20.51](SwiftUI-alignmentGuide-%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B8%83%E5%B1%80%E5%9F%BA%E7%A1%80.assets/%E6%88%AA%E5%B1%8F2020-04-15%20%E4%B8%8A%E5%8D%882.20.51.JPG)

![截屏2020-04-15 上午2.21.13](SwiftUI-alignmentGuide-%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B8%83%E5%B1%80%E5%9F%BA%E7%A1%80.assets/%E6%88%AA%E5%B1%8F2020-04-15%20%E4%B8%8A%E5%8D%882.21.13.JPG)

原视频见：https://swiftui-lab.com/wp-content/uploads/2019/09/container-alignment-1000.mov

源代码见：https://gist.github.com/swiftui-lab/812ec44e53fe3ce335248ef724c33463

注意：若果你将改变alignment写在了withAnimation block里，视图将会移动到新的位置

#### Frame Alignment

到目前为止，我们所看到的所有对齐方式都涉及如何相对于彼此放置。确定之后，系统布局需要将整个组防止在容器中，通过提供frame(alignment:)，你可以告诉系统该如何做，如果未指定，系统将采用.center

![frame-alignment-1000.2020-04-15 02_36_04](SwiftUI-alignmentGuide-%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B8%83%E5%B1%80%E5%9F%BA%E7%A1%80.assets/frame-alignment-1000.2020-04-15%2002_36_04.gif)

通常，修改frame的对齐不会有任何效果，这不是bug，在大多数情况下，Container是紧凑的，也就是薯片，Container足够大以容纳他的所有视图，但不能再增加更多的alignment元素，因此，在frame()中使用.lead,.center.trailing无效，因为视图组已经在使用所有空间，由于没有剩余空间，因此无法将其移动任何一侧。稍后我们开始使用学习app的时候将对其进行直接的观赏

#### Multline Text Alignment()多行文字对齐

这个很简单，当我们的文本视图包含多行时，它将确定行之间的对齐方式

![img](https://swiftui-lab.com/wp-content/uploads/2019/09/text-alignment.png)

#### 与AlignmentGuide互动

在这个文章中，我创建了一个有用的学习工具，用来探索到目前为止所学到的知识，我建议您以横向模式在iPad上运行代码，如果您没有iPad，只需使用模拟器即可

代码：https://gist.github.com/swiftui-lab/793ca53ad1f2f0d7eb07aa23b54d9cbf

使用“Show in Two Phases”想象可以了解alignment的工作方式。您将看到alignmentGuide是如何移动到新位置的，然后View是如何移动以满足alignmentGuide的

请注意：同城这些操作是同时发生的，但是此选项将其分为两部分，以更好的了解该过程

您可以试试下面这些事情：

- 修改frame(alignment:)参数，看看它在紧凑容器和宽敞容器中如何工作。您应该注意到：当我们容易变紧时，此参数无效

- 修改Container的对齐方式，请注意，只要alignmentGuide的类型相同，那么更改是无效的。唯一会移动的是视图具有隐式alignmentGuide的视图。这是因为它是唯一具有不同alignmentGudie的视图
- 通过与视图交互来测试不同的预设alignment值，您可以将alignmnetGuide设置为.lead、.center、.trailing（分别按下L，C，T按钮）
- 通过与视图的交互来测试不同的任意alignment值，点击黄色条以选择对齐点
- 测试小于0或者大于视图宽度的对齐值。为此请打开"extend bar"开关

当您测试不同的值时，请点击屏幕之前预测会发生什么，，您总是正确的吗，如果是的，我们就可以开始创建一些自定义alignments，请继续阅读

#### 自定义alignments

现在我们知道了标准情况下alignment是如何工作的，我们将创建一个自定义alignment，让我们看一下第一个示例代码，并分析它的作用

```swift
extension HorizontalAlignment {
    private enum WeirdAlignment: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d.height//返回了默认视图的高度（意味着：这个view的高度越高，其相对于隐式的参考视图就会偏移的越多）
        }
    }
    //注意到自定义的alignment是一个枚举WeirdAlignment，然后像.leading类似枚举那样返回满足AlignmentID协议，然后实现一个defaultValue方法，返回一个CGFloat。这样写可以像.leading那样作为参数传递
    static let weirdAlignment = HorizontalAlignment(WeirdAlignment.self)
}//确定我们自定义的alignment是水平alignment
```

当自定义alignment的时候，我们正在做两件事

1. 确定他是水平alignment还是竖直alignment
2. 提供隐式alignmentGuide的默认值（对于没有显式alignmentGuide的视图）

接下来的比较有趣了，通过使用高度作为默认的alignment，它会产生有趣的效果

![截屏2020-04-15 下午12.41.38](SwiftUI-alignmentGuide-%E8%87%AA%E5%AE%9A%E4%B9%89%E5%B8%83%E5%B1%80%E5%9F%BA%E7%A1%80.assets/%E6%88%AA%E5%B1%8F2020-04-15%20%E4%B8%8B%E5%8D%8812.41.38.png)

```swift
struct CustomView: View {
    var body: some View {
        VStack(alignment: .weirdAlignment, spacing: 10) {
            //此处对VStack使用了我们刚刚自定义的alignmeng
            Rectangle()//这是竖线
                .fill(Color.primary)
                .frame(width: 1)
                .alignmentGuide(.weirdAlignment, computeValue: { d in d[.leading] })//对竖线的alignmentGuide设置为自定义的，然后computeValue返回.leading也就是0：相当于这根线的左边对齐约束alignment线，由于该线只有一个宽度，所以差不多可以当作alignmentGuide线
            
            ColorLabel(label: "Monday", color: .red, height: 50)//对于没有显式声明alignmentGuide的View将采用默认alignmentGuide，也就是根据高度，决定位置
            ColorLabel(label: "Tuesday", color: .orange, height: 70)
            ColorLabel(label: "Wednesday", color: .yellow, height: 90)
            ColorLabel(label: "Thursday", color: .green, height: 40)
            ColorLabel(label: "Friday", color: .blue, height: 70)
            ColorLabel(label: "Saturday", color: .purple, height: 40)
            ColorLabel(label: "Sunday", color: .pink, height: 40)
            
            Rectangle()//下面的线，跟上面的线配置相同
                .fill(Color.primary)
                .frame(width: 1)
                .alignmentGuide(.weirdAlignment, computeValue: { d in d[.leading] })
        }
    }
}

struct ColorLabel: View {
    let label: String
    let color: Color
    let height: CGFloat
    
    var body: some View {
        Text(label)
      		.font(.title)
      		.foregroundColor(.primary)
      		.frame(height: height)
     		  .padding(.horizontal, 20)
          .background(RoundedRectangle(cornerRadius: 8).fill(color))
    }
}
```

在这个例子中，我们了解了如何创建自定义对齐方式，但是我门明明不需要自定义对齐就可以实现图中的结果。其实：==使用自定义对齐方式的真正好处是使用它们来对齐位于视图层次结构不同分支上的视图==



让我们来看看下一个例子

![img](https://swiftui-lab.com/wp-content/uploads/2019/09/custom-alignment.gif)

先分析一下这个视图的组成部分，就会意识到我们需要使用图像与文本对齐。但他们不属于同一个Container（就是类似VStack的容器）



![img](https://swiftui-lab.com/wp-content/uploads/2019/09/custom-alignment-layout.png)

我们的图像和文本视图都有一个公共container(HStack)，因此我们需要创建一个自定义对齐方式以匹配它们的中心点。重要的是要记住适当的设置公共Container的alignment参数

```swift
extension VerticalAlignment {
    private enum MyAlignment : AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[.bottom]
        }
    }//自定义Mylignment：返回.bottom
    static let myAlignment = VerticalAlignment(MyAlignment.self)//标明使用的是竖直Alignment
}

struct CustomView: View {
    @State private var selectedIdx = 1
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
            HStack(alignment: .myAlignment) {
                Image(systemName: "arrow.right.circle.fill")
                    .alignmentGuide(.myAlignment, computeValue: { d in d[VerticalAlignment.center] })//对对勾设置刚刚自定义的Guide，返回竖直Alignment.center
                    .foregroundColor(.green)

                VStack(alignment: .leading) {
                    ForEach(days.indices, id: \.self) { idx in
                        Group {
                            if idx == self.selectedIdx {
                                Text(self.days[idx])
                                    .transition(AnyTransition.identity)
                                    .alignmentGuide(.myAlignment, computeValue: { d in d[VerticalAlignment.center] })
                            } else {
                                Text(self.days[idx])
                                    .transition(AnyTransition.identity)
                                    .onTapGesture {
                                        withAnimation {
                                            self.selectedIdx = idx
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .padding(20)
            .font(.largeTitle)
    }
}
```

你可能想知道所有没有明确竖直Alignment的View怎么样了，它们不是应该使用了隐式的值吗，如果这样的话，难道不是会被叠起来？

所有这些问题，这都是alignmentGuide的另一个事实。这种情况下，我们要处理的VStack而不是ZStack。这意味着其内部的所有视图必须垂直堆叠。alignmentGui不会破坏这一点。布局系统将使用选定视图中的显式对齐方式来对齐箭头图像。其他没有明确alignmentGuide的TextView将相对于其他文本视图放置

#### ZStack自定义Alignment

如果您需要为ZStack创建自定义对齐方式，这里有一个模版

```swift
extension VerticalAlignment {
    private enum MyVerticalAlignment : AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[.bottom]
        }
    }
    
    static let myVerticalAlignment = VerticalAlignment(MyVerticalAlignment.self)
}

extension HorizontalAlignment {
    private enum MyHorizontalAlignment : AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[.leading]
        }
    }
    
    static let myHorizontalAlignment = HorizontalAlignment(MyHorizontalAlignment.self)
}

extension Alignment {
    static let myAlignment = Alignment(horizontal: .myHorizontalAlignment, vertical: .myVerticalAlignment)
}

struct CustomView: View {
    var body: some View {
        ZStack(alignment: .myAlignment) {
            ...
        }
    }
}
```

#### 综上

在本文中，我们已经看到了强大的alignmentGuide。一旦您了解了他们可以提供的东子，它们就会变得更加有意义，您应该始终记住以下几点

1. 容器中的每个视图都有alignmentGuide，如果未明确制定，它将由Container的alignment参数决定
2. 在布局期间，将忽略与Container alignment参数中只得难过的类型不同的参考线
3. VStack使用HorizontalAlignment，而HStack使用VerticalAlignment。
4. 如果Container很紧凑，则frame方法中的对齐参数将不会产生视觉效果
5. 当来自视图层次不同分支的两个视图需要彼此对齐时，需要使用自定义AlignmentGuide

