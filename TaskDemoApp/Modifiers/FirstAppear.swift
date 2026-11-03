import SwiftUI

private struct FirstAppear: ViewModifier {
    
    private let action: () -> ()
    
    @State private var hasAppeared = false
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}

public extension View {
    func onFirstAppear(_ action: @escaping () -> ()) -> some View {
        modifier(FirstAppear(action: action))
    }
}
