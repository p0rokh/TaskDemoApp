import SwiftUI

struct AppearDemoView: View {
    var body: some View {
        let _ = DispatchQueue.main.async {
            print("main queue drained")
        }
        return Text("Hello, world!")
            .onAppearModifier()
            .task {
                print("dot task")
            }
            .onAppear {
                print("on appear")
            }
    }
}

struct AppearModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.onAppear {
            print("on appear AppearModifier")
        }
    }
}

extension View {
    public func onAppearModifier() -> some View {
        modifier(AppearModifier())
    }
}
