import SwiftUI

// MARK: - Exact Layered Mesh Wave Background
struct LayeredMeshWaveView: View {
    var body: some View {

    }
}

// MARK: - Integration Example
struct Test: View {
    var body: some View {
        ZStack {
            // Background Mesh Waves
            LayeredMeshWaveView()
            
            // Apka App Content yahan rahega
            VStack {
                Spacer()
                Text("App Content Here")
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
}

#Preview{
    Test()
}
