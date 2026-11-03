import SwiftUI

struct ContentView: View {
    var body: some View {
        let _ = DispatchQueue.main.async { print("main queue drained") }
        return Text("Hello, world!")
            .task(name: "wow!") {
                print("hello original task before sleep")
                try? await Task.sleep(for: .seconds(2))
                print("hello original task after sleep")
            }
            .easyTask {
                print("hello easy task")
            }
            .onAppear {
                print("on appear")
            }
            .onDisappear {
                print("on disappear")
            }
    }
}

#Preview {
    ContentView()
}
