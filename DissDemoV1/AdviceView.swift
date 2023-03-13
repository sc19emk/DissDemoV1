import SwiftUI
import Foundation


// MAIN Page Code
struct AdviceView: View {
    var body: some View {
        NavigationView {
            ScrollView{
//                VStack{
//                    HStack{
//                        Text("Advice Articles")
//                            .font(.title.bold())
//                            .padding()
//                        Spacer()
//                    }
//                }
                LazyVStack{
                    ForEach(allPosts) { post in
                        NavigationLink(destination: PostView(blogPost: post)) {
                            BlogPostCard(blogPost: post)
                        }
                    }
                }
            }
            .navigationBarTitle("Advice Articles")
//            .navigationBarItems(
//                trailing: Button(action: {}) { Image(systemName: "newspaper.fill")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//            })
        }
    }
}

//// CONTENT Page Code
//struct ContentView: View {
//    var body: some View {
//        TabView {
//            AdviceView().tabItem {
//                Image(systemName: "house.fill")
//                Text("Home")
//            }
//        }
//    }
//}

struct PostView: View {
    var blogPost: BlogPost
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Image(blogPost.image)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .clipped()
                    VStack {
                        HStack {
                            Text(blogPost.name)
                                .font(.title3)
                                .fontWeight(.heavy)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                                .padding(.vertical, 15)
                            Spacer()
                        }
                        Text(blogPost.details)
                            .multilineTextAlignment(.leading)
                            .font(.body)
                            .foregroundColor(Color.primary.opacity(0.9))
                            .padding(.bottom, 25)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct BlogPost: Identifiable {
    var id : Int
    var name : String
    var image : String
    var details : String
}

struct BlogPostCard: View {
    @Environment(\.colorScheme) var colorScheme
    var blogPost: BlogPost
    var body: some View {
        VStack(alignment: .leading) {
            Image(blogPost.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height:150)
                .frame(maxWidth: UIScreen.main.bounds.width - 80)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            VStack (spacing: 6) {
                HStack {
                    Text(blogPost.name)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(3)
                        .font(Font.title2.bold())
                        .foregroundColor(.primary)
                    Spacer()
                }
                HStack {
                    Text(blogPost.details)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(3)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            .frame(height:110)
        }
        .padding(15)
        .background (colorScheme == .dark ? Color(hex: "#121212") : Color.white)
        .frame (maxWidth: UIScreen.main.bounds.width - 50, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: colorScheme == .dark ? .white.opacity(0.01) : .black.opacity(0.1), radius: 15, x:0, y:5)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a,r,g,b) = (255, (int >> 8)*17, (int >> 4 & 0xF)*17, (int & 0xF)*17)
        case 6:
            (a,r,g,b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1,1,1,0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

var allPosts = [
    BlogPost(id: 0, name: "Tips for walking alone", image: "article1", details:"How to keep yourself safe while walking alone. 1. Take out a headphone, and dont wear noise cancelling headphones, so are you are aware of whats happening around you. 2. Wear bright colours. 3. Reguarly check your surrondings, to see if anybody is following you."),
    BlogPost(id: 1, name: "Self Defense 101", image: "article1", details:"Go for the neck!"),
    BlogPost(id: 2, name: "Areas to avoid", image: "article1", details:"Dark, unlit areas. Parks. Forests. Alleyways. Stick to major roads and popular areas.")
]

// used for creating the canvas

struct AdviceView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
        //ContentView()
    }
}
