import SwiftUI

private let isImmediateOn = true

class EasyTaskStorage {
    
    private var task: Task<Void, Never>?
    
    func invalidate() {
        task?.cancel()
    }
    
    func start(_ action: sending @escaping @isolated(any) () async -> Void) {
        task?.cancel()
        if #available(anyAppleOS 26.0, *), isImmediateOn {
            task = Task.immediate {
                await action()
            }
        } else {
            task = Task {
                await action()
            }
        }
    }
}

struct EasyTaskModifier<ID>: ViewModifier where ID: Equatable {
    
    private let id: ID
    private let action: @isolated(any) () async -> Void
    
    @State private var storage = EasyTaskStorage()
    
    init(
        id: ID,
        action: sending @escaping @isolated(any) () async -> Void)
    {
        self.id = id
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                storage.start(action)
            }
            .onDisappear {
                storage.invalidate()
            }
            .onChange(of: id) { oldValue, newValue in
                if oldValue != newValue {
                    storage.invalidate()
                    storage.start(action)
                }
            }
    }
}

extension View {
    
    func easyTask(
        @_inheritActorContext _ action: sending @escaping @isolated(any) () async -> Void
    ) -> some View {
        easyTask(id: 0, action)
    }
    
    func easyTask<ID>(
        id: ID,
        @_inheritActorContext _ action: sending @escaping @isolated(any) () async -> Void
    ) -> some View where ID: Equatable {
        modifier(EasyTaskModifier(id: id, action: action))
    }
}
