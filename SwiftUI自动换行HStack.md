有时候，我们会遇到类似这样的需求![截屏2020-04-16 下午10.13.14](SwiftUI%E8%87%AA%E5%8A%A8%E6%8D%A2%E8%A1%8CHStack.assets/%E6%88%AA%E5%B1%8F2020-04-16%20%E4%B8%8B%E5%8D%8810.13.14.png)，其中一种实现方式就是对alignmentGuide的灵活运用，**如果您不太清楚刚刚这个名字的意思，我推荐您先看看我的这篇文章**，算是alignmentGuide的基础

博客地址：[alignmentGuide基础](https://github.com/qizhemotuosangeyan/blog/blob/master/SwiftUI-alignmentGuide-自定义布局基础.md)

### 写在前面

代码来自[https://stackoom.com/question/3ytbp/带包装的SwiftUI-HStack](https://stackoom.com/question/3ytbp/带包装的SwiftUI-HStack)

如侵权请联系我删除。

我添加了一些关键的打印语句和大量注释来探索这份代码。

## 正文

==先贴出源码，如果看着比较费劲可以跳过这部分，直接看我加了一些注释的版本==

```swift
import SwiftUI

struct TestWrappedLayout: View {
    @State var platforms = ["Ninetendo", "XBox", "PlayStation", "PlayStation 2", "PlayStation 3", "PlayStation 4"]

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.platforms, id: \.self) { platform in
                self.item(for: platform)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if platform == self.platforms.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if platform == self.platforms.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }

    func item(for text: String) -> some View {
        Text(text)
            .padding(.all, 5)
            .font(.body)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(5)
    }
}

struct TestWrappedLayout_Previews: PreviewProvider {
    static var previews: some View {
        TestWrappedLayout()
    }
}
```

### 我们一起来阅读这份源码（加了注释的版本）

```swift
import SwiftUI

struct TestWrappedLayout: View {
  //@State标明 当这个platforms发生变化的时候视图进行自动的更新，这个不懂不影响我们阅读代码
    @State var platforms = ["Ninetendo", "XBox", "PlayStation", "PlayStation 2", "PlayStation 3", "PlayStation 4"]
  
//几何阅读器GeometryReader：捕获了一个满足GeometryProxy协议的变量，该协议提供安全区插图和View的size（简单点说就是这个东西能捕获当前Container的一些参数，这个Container一般指的是HStack，VStack，ZStack等等）
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)//将捕获到的Container传递给generateContent函数返回一个View：这个函数在下面定义
        }

    }

    /// - Parameter g: 一个满足GeometryProxy协议的变量：这个变量就是Container本身
    /// - Returns: 一个View
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero//width初始值为0
        var height = CGFloat.zero//height初始值为0
        return ZStack(alignment: .topLeading) {//ZStack满足.topLeadingalignment
 
            //实现思路：每个视图宽度+本视图的原定起点如果大于g的宽度则换行，否则按照原定起点进行放置
          //具体：对齐引导1: width = 0，height = 0，第一个View的左边就紧挨着Container左边框，然后width = width + View1的宽度；第二个View的左边就向右偏移width个单位，然后width = width + View2；然后第三个。。。。。。以此类推可以得到一行内的全部正确约束
          //对齐引导2: height = 0， 在进行对齐引导1的时候如果某个View的宽度+原定偏移量超出了Container的宽度那么height = height + View的高度。。。。。。以此类推可以得到每行的约束
          //注意⚠️：由于alignmentGuide中的代码会被调用多次，所以当最后一个元素被成功约束之后需要将width，height清0以保证下一轮的约束正确
           //注意⚠️：偏移量取负值，也就是computeValue的返回值取负值表示向右偏移，取负值表示向下偏移
            //
            ForEach(self.platforms, id: \.self) { platform in
                self.item(for: platform)/*item方法将一个个数据转成一个个View*/
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in/*这里的d指的是每一个文本视图（子视图）*/
                        if (abs(width - d.width) > g.size.width)/*这里的g指的是Container视图（父视图）*/
                        {
                            width = 0
                            height -= d.height
                        }
                                                             //您可以取消这里的注释来自己看看这些参数的值大概是多少，实体运行才能看到哦，右边的预览是看不到打印值的
//                        print("当前width",width)
//                        print("当前d.width",d.width)
//                        print("当前g.size.widht",g.size.width)
//                        print("\n")
                        let result = width
                        if platform == self.platforms.last! {
                            width = 0 //最后一个元素：由于Swift的‘=’是值传递，所以这里width被置为0，但最后一个元素的返回值依然是正常的而不是0
//                            print("正在约束的是",platform)
                        } else {
                            width -= d.width
                        }
                        print("正在约束的是",platform)
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if platform == self.platforms.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }

    func item(for text: String) -> some View {
        Text(text)
            .padding(.all, 5)
            .font(.body)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(5)
    }
}

struct TestWrappedLayout_Previews: PreviewProvider {
    static var previews: some View {
        TestWrappedLayout()
    }
}

```



