import SwiftUI

struct BrandView: View {
  var body: some View {
    HStack {
      Spacer()
      Text("Key Plastic Surgery Inc.")
        .font(.headline)
        .foregroundColor(.blue)
        .padding()
      Spacer()
    }
    .background(.white)
  }
}

