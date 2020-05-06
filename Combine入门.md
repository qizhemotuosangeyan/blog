写在前面⚠️：大部分翻译自https://medium.com/ios-os-x-development/learn-master-%EF%B8%8F-the-basics-of-combine-in-5-minutes-639421268219，我添加了一些细枝末节的东西更便于读者理解

# 1. Publishers

首先：Combine框架中只有Publishers（发布者）或者operates（运算符，加工厂），或者subscribes（订阅者）。

流程总是：Publishers发布某个事件，operates对其进行加工，最后由订阅者处理（使用或丢弃）

```swift
let helloPublisher = "Hello Combine".publisher()
let fibonacciPublisher = [0,1,1,2,3,5].publisher()
let dictPublisher = [1:"Hello",2:"World"].publisher()
```

使用下面这个函数对某个Publishers进行订阅：

```swift
sink(receiveValue: (value -> Void))
```

那个闭包（block）就会收到订阅的事件和值

```swift
let fibonacciPublisher = [0,1,1,2,3,5].publisher()
_ = fibonacciPublisher.sink { value in
    print(value)//闭包捕获的value就是发布者发布的value
}

OUTPUT: 
0 1 1 2 3 5
```

除了发布普通值之外，Publishers还会发布一种特殊的值**Subscribers.Completion**用来表示发布事件的结束（“完成”和“错误”，它们都表示结束）![截屏2020-05-07 上午1.35.43](Combine%E5%85%A5%E9%97%A8.assets/%E6%88%AA%E5%B1%8F2020-05-07%20%E4%B8%8A%E5%8D%881.35.43.png)

```swift
case finished//完成
case failure(Failure)//错误，这个错误可以是自定义Object(对象)，或者是Never，Never表示此次发布事件不出现错误
```

```swift
let fibonacciPublisher = [0,1,1,2,3,5].publisher()
_ = fibonacciPublisher.sink(receiveCompletion: { completion in
    switch completion {
        case .finished:
            print("finished")
        case .failure(let never):
            print(never)
    }
}, receiveValue: { value in
    print(value)
})
//闭包捕获的completion就是结束状态，捕获的value就是发布的value
OUTPUT:
0 1 1 2 3 5
finished
```

如果你想取消订阅：你可以通过调用下面这个方法

```swift
let subscriber = fibonacciPublisher.sink { value in
    print(value)
}
subscriber.cancel()
```

## 2.Subject

下面的代码来自可以看出Subject是Publisher的子协议（也就是说Subject是一种特殊的Publisher）

```swift
protocol Subject : AnyObject, Publisher
```

##### 目前Combine中有两种不同的Subject

- PassthroughSubject:如果您订阅它，您将获得订阅后将发生的所有事件。
- CurrentValueSubject:如果您订阅它，您将获得到目前为止他所发布的最后一个事件和以后即将发布的事件

先说说PassthroughSubject：让我们先来创建一个最简单的默认的那种

```swift
let passthroughObject = PassthroughSubject<String,Error>()
```

调用这个函数去发布一个值：

 **send(input:String)**

调用这个两个函数中的某一个表示发送结束：

正常结束：**send(completion: .finished).**

错误结束：**send(completion: someError)**

```swift
//试一试
passthroughObject.send("Hello")
passthroughObject.send("World")
```

如果你在发布之后才订阅，那你就收不到这两个值（"Hello"和"World"）

```swift
let passThroughSubject = PassthroughSubject<String, Error>()
passThroughSubject.send("Hello")
passThroughSubject.send("World")
passThroughSubject.sink(receiveValue: { value in
    print(value)
})

OUTPUT:
NO OUTPUT
```

现在我们先订阅后发送"World"，这样就能收到了

```swift
let passThroughSubject = PassthroughSubject<String, Error>()
passThroughSubject.send("Hello")//发送Hello
passThroughSubject.sink(receiveValue: { value in
    print(value)
})//订阅，并在收到订阅时打印收到的值
passThroughSubject.send("World")//发布者发布World

OUTPUT:
World
```

再说说CurrrentValueSubject

与PassThroughSubject不同，CurrentValueSubject会在订阅的时候直接收到该发布者最新一次发布的值

```
如果你还没理解，看看这个例子吧：
比如说《看天下》杂志会在每月的8号发布一本杂志
5月10号的时候你订阅了《看天下》杂志，
如果订阅方法用的是PassThroughSubject，你将等到6月8号才能收到6月份的杂志（也永远不会收到5月份的杂志）
如果订阅方法是CurrentValueSubject，虽然你10号才去订阅付钱，但你当场就可以拿到5月8号发布的那本，后面就和PassThroughSubject一样每当发布的时候会收到最新的杂志
```



恭喜🎉。 如果您继续阅读这里，Combine就算是简单入了门， 还有很多东西要学习，但是Combine周围的一切都基于这些简单的原理。 您现在可以休息片刻，并尝试使用这些概念以充分理解它们。 如果您准备好了，让我们继续，因为还有更多有趣的东西要探索。

## Operator（操作符，加工厂）⚙️

记得我们刚刚提到了Combine中还有一种东西叫做operater（操作符），它们的行为就是在 Subscriber(订阅者)收到事件之前进行加工

##### Map(遍历器)

对Publisher的发布的每一个值执行某些操作：比如对每个值乘以10

```swift
[1,2,3,4].publisher().map {
    return $0 * 10//Swift语法不太熟的朋友别太担心，$0指的是闭包捕获到的值（此处map捕获的值是数组中的每一个元素）
}.sink { value in
    print(value)
}OUTPUT: 10 20 30 40
```

##### Scan(统计器)

类似于swift中的reduce，需要一个初值和一种迭代运算，返回一个汇总了的值

```swift
[1,2,3,4,5].publisher().scan(0) { seed, value in
    return seed + value
}.sink { value in
    print(value)
}
//示例代码中0就是初值，seed就是累加值的中间量，value就是对应数组中的每一个值，运算就是'+'
//seed的值：0,1,3,6,10来源于(0,1+2,1+2+3,1+2+3+4,1+2+3+4+5)，你看看像不像一颗种子在慢慢长大
OUTPUT: 1 3 6 10 15
```

##### Filter(过滤器)

要过滤元素，您只需定义一个需要传递的条件，如果满足该条件，该值将被发送给其订阅者。

```swift
[2,30,22,5,60,1].publisher().filter{
    $0 > 10
}.sink { value in
    print(value)
}

OUTPUT: 30 22 60
```



##### 自己去试试其他operator吧

- *flatMap*
- *replaceEmpty*
- max & min

## 4. Combine & SwiftUI/UIKit

Combine和SwiftUI/UIKit将会产生非常棒的结果

然后老外给了一个UIKit的例子：将ViewModel直接绑定在控件上（俺没看，就直接贴过来了）

```swift
import Combine
import UIKit
struct ViewModel {
    @Published var switchState: Bool = false
}
final class SomeViewController: UIViewController {
    private var subscriber: AnyCancellable?
    private var viewModel = ViewModel()
    
    @IBOutlet private weak var aSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        let queue = DispatchQueue.main        
        subscriber = publisher.assign(to: \.isEnabled, 
                                      on: aSwitch)
    }
    
    @IBAction func didSwitch(_ sender: UISwitch) {
        viewModel.switchState = sender.isOn
    }
}
```

恭喜🎉，你已经学习了Combine的基础知识，happy code every day!😊

如果这篇文章对您有所帮助，欢迎您捐赠一小笔给原作者https://medium.com/ios-os-x-development/learn-master-%EF%B8%8F-the-basics-of-combine-in-5-minutes-639421268219，如果您希望我继续翻译类似的文章，口头鼓励下我就ok了～