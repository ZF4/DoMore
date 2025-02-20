import SwiftUI
import SwiftData

public struct LockButton: View {

    @State private var isUnlocked = true
    @State private var isLoading = false
    @Query private var modes: [BlockModel]
    var onSelect: () -> Void
//    var onLockChange: (Bool) -> Void // Closure to call when isLocked changes

//    public init(onLockChange: @escaping (Bool) -> Void) {
//        self.onLockChange = onLockChange
//    }

    public var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    BackgroundComponent()
                    DraggingComponent(isUnlocked: $isUnlocked, isLoading: isLoading, maxWidth: geometry.size.width)
                }
            }
            .frame(height: 55)
            .padding(.horizontal)
            .padding(.bottom, 20)
            .onChange(of: isUnlocked) { newValue, oldValue in
                print("new value \(newValue)")
                onSelect()
                simulateRequest()
        }        .onAppear {
            if let firstMode = modes.first(where: {$0.isActive == true }) {
                isUnlocked = firstMode.isLocked ?? true // Assuming BlockModel has an isLocked property
            }
        }
    }

    private func simulateRequest() {
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
        }
    }

}


#Preview {
    LockButton(onSelect: {})
}
