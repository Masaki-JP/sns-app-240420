import SwiftUI

extension View {
    /// ⚠️ If the device is an iPhone, it will be displayed as fullScreenCover, otherwise it will be displayed as modal.
    @ViewBuilder
    func adaptivePresentation<Content>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.fullScreenCover(isPresented: isPresented, onDismiss: onDismiss, content: content)
        } else {
            self.sheet(isPresented: isPresented, onDismiss: onDismiss, content: content)
        }
    }
}
