

import SwiftUI
// ————————————————————————————ClassModel————————————————————————
class DemoClassModel: ObservableObject {
    var age1: Int
    @Published var age2: Int
    init(age: Int) {
        self.age1 = age
        self.age2 = age
    }
    func agePlus1() {
        print("class age = \(self.age1)")
        self.age1 += 1
    }
    func age2Plus1() {
        self.age2 += 1
    }
}
// ————————————————————————————————————————————————————————————

// ————————————————————————————StructModel————————————————————————
struct DemoStructModel {
    var age: Int
    init(age: Int) {
        self.age = age
    }
    mutating func tap() {
        self.age += 1
    }
}

// ———————————————————————————————View部分—————————————————————————————
struct ContentView: View {
    @StateObject var classModel = DemoClassModel(age: 0)
    @State var structModel = DemoStructModel(age: 0)
    var body: some View {
        let age1Class = classModel.age1
        let age2Class = classModel.age2
        let ageStruct = structModel.age
        
        VStack {
            List {
                Text("class model age1: \(age1Class)")
                Button("class age1 + 1") {
                    classModel.agePlus1()
                }
                Button("objectWillChage.send()") {
                    classModel.objectWillChange.send()
                }
            }
            List {
                Text("class model age2: \(age2Class)")
                Button("class age2 + 1") {
                    classModel.age2Plus1()
                }
            }
            List {
                Text("struct model age: \(ageStruct)")
                Button("struct age + 1") {
                    structModel.tap()
                }
            }
        }
        .padding()
    }
}
// ————————————————————————————————————————————————————————————
#Preview {
    ContentView()
}
