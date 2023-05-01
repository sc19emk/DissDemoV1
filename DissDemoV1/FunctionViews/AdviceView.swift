import SwiftUI
import Foundation


// advice page code with all articles
struct AdviceView: View {
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    var body: some View {
        NavigationView {
            // scroll view containing all the articles
            ScrollView{
                LazyVStack{
                    HStack {
                        // page title
                        Image(systemName: "character.book.closed")
                            .font(.system(size: 30))
                            .foregroundColor(Color.cyan)
                        Text("Advice")
                            .font(.system(size: 30, design: .monospaced))
                            .bold()
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                    }
                    // displaying each available post
                    ForEach(allArticles) { post in
                        NavigationLink(destination: ArticleView(article: post)) {
                            AdviceCard(blogPost: post)
                        }
                    }
                }
            }
        }
    }
}
// detailed post view
struct ArticleView: View {
    var article: Article // the current blog post
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    // image at top of the page
                    Image(article.image)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .clipped()
                    VStack {
                        // article title
                        HStack {
                            Text(article.title)
                                .font(.title3)
                                .fontWeight(.heavy)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            // author
                            Text("From " + article.author)
                                .font(.subheadline)
                                .fontWeight(.thin)
                                .foregroundColor(.primary)
                                .padding(.bottom, 15)
                        }
                        // content
                        Text(article.content)
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

struct AdviceCard: View {
    @Environment(\.colorScheme) var colorScheme // night / dark mode
    var blogPost: Article // each article
    var body: some View {
        VStack(alignment: .leading) {
            // image
            Image(blogPost.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height:150)
                .frame(maxWidth: UIScreen.main.bounds.width - 80)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            VStack (spacing: 6) {
                HStack {
                    // title
                    Text(blogPost.title)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(3)
                        .font(Font.title2.bold())
                        .foregroundColor(.primary)
                    Spacer()
                }
                HStack {
                    // snippet of the content (3 lines max)
                    Text(blogPost.content)
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
        .background (colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white)
        .frame (maxWidth: UIScreen.main.bounds.width - 50, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: colorScheme == .dark ? .white.opacity(0.01) : .black.opacity(0.1), radius: 15, x:0, y:5)
    }
}
// article structure
struct Article: Identifiable {
    var id : Int
    var title : String
    var image : String
    var content : String
    var author : String
    var url : String
}
// article examples
var allArticles = [
    Article(id: 0, title: "Ask for Angela launches in Leeds", image: "ask-for-angela", content:"If you ever feel uncomfortable or unsafe when out in the city centre, Ask for Angela to get discreet help.Leeds City Council are working with Women Friendly Leeds and other partners and venues across the city centre to help keep all people safe when on a night out. \n\nAnyone can say the code word ‘Angela’ to staff at participating venues to signal that they’re in an uncomfortable situation and would like assistance. \n\nThe ‘Ask for Angela’ scheme was founded by Lincolnshire County Council as part of a wider campaign to reduce violence and harassment against women. It means that if you go to a participating hospitality venue, such as a bars and club, you can ask for ‘Angela’ to discreetly signal to staff that you feel unsafe or threatened and would like assistance. \n\nTrained staff will then be able offer to help, for example by calling a taxi or providing a safe space. Staff at participating venues have been trained to help, they won’t judge and will aim to get people out of the situation without too much fuss. \n\nWhatever the reason is, if you feel unsafe or uncomfortable when out speak to a member of staff at participating venues and ‘ASK FOR ANGELA’ to get discreet help.", author: "Women Friendly Leeds", url: "https://womenfriendlyleeds.org/ask-for-angela/"),
    Article(id: 1, title: "5 Defense Strategies Every Woman Needs To Know", image: "10-self-defense", content:"You may not prevail against a pro MMA fighter in the octagon; but everyone has the power to survive or avoid the most common attacks that occur in the real world. This power comes not from being stronger but by understanding strategy. MMA and Brazilian Jiu Jitsu training is the best thing you can do to prepare yourself for physical conflict; but strategy is what allows you to succeed without fighting- and what gives you the advantage when fighting is necessary. Here are five of those strategies.\n\n\nStrategy #1 - Awareness of Surroundings and the People In Them \n\nAwareness is as simple as it is powerful. It deters criminals, lets you detect threats ahead of time, and gives your intuition the information it needs to protect you. An alert person is more difficult to attack than a distracted person and therefore less likely to be selected for crime.\n\nAttackers don't look for fights, they look for opportunities.They aim to catch victims off guard so that by the time they realize what's happening it's too late. Your eyes, ears, and intuition have been perfected over centuries for the sole purpose of keeping you alive. They are highly effective survival tools- never allow them to be shut down in public. You cannot defend what you can't see.\n\n\nStrategy #2 - Trust Your Instincts\n\nMany women who were attacked say they had a bad feeling beforehand but ignored it. In order to not appear rude or paranoid we so often interrogate and deny our own survival instincts. But that gut feeling that something isn't right is the most important warning sign that you are not safe. Instincts work faster than intellect when it comes to your safety and require no further validation. Always listen to you gut feeling about a person, place or situation.\n\nYour instincts get two things right: they are always based on something, and they always have your best interest at heart - Gavin De Becker\n\n\nStrategy #3 - Present Yourself Confidently\n\nBody language is one of the most important indicators of a persons willingness to fight back. Studies show that predators judge vulnerability by observing how people walk. Someone who walks confidently with their shoulders back and head up and moves swiftly with purpose is perceived to be likely and capable of standing up for themselves. Someone who hangs their head, avoids eye contact, and walks with a sense of defeatedness is perceived to be unlikely to put up a fight. Confident body language is what tells a predator within a seconds glance that you are not an easy target. When you move, move with confidence.\n\n\nStrategy #4 - Deny Attack Opportunities\n\nSelecting or creating an attack opportunity is a critical part of the attackers strategy. Under the right circumstances even the most invulnerable target is accessible, and in others the most vulnerable target cannot be touched. Attack opportunities involve considerations like: \n- finding a place and time where no one is around to intervene \n- using tactical positioning to surprise or corner you \n-using lures to bait victims into approaching willingly \n-attacking when the victim has no capacity to defend themselves \n\n\nStrategy #5 - Recognize Baits\n\nLures are used to lower your guard and give the attacker an excuse to get close enough to attack. They are much more common than physical force attacks. For example: \n\n-Ted Bundy used the 'help me' trick by pretending to be injured and asking women for help putting things in his trunk. The help me trick can look like asking for directions, looking for a lost pet, asking to use your phone, etc. \n-Unsolicited offers for help are also very common. Offers to help with groceries, give you a ride, help you with your car that broke down, etc. \n-Child predators entice children to approach their car by offering free stuff, showing animals, asking for help, or by simply starting a conversation. \n-Home invaders bait victims to open the door by pretending to be a salesman or neighbour.  \n-Fake emergencies are a guise used by criminals like abductors and home invaders. \n\nLures lower the criminals risk by reducing the amount of time an attack will take and eliminating escape options. They work so well because they exploit our virtues: our desire to help others, to reciprocate, to be nice and not offend. Recognize baits for what they are- an excuse to be allowed into your personal space. The street is the most common site of abduction, and lures are the most common strategy- therefore as a rule, you should never get close to someone's car when the driver starts a conversation with you, regardless of what comes out of their mouth.\n\nMy safety first, your feelings second.", author: "Girls Who Fight", url: "https://www.girlswhofight.co/post/ten-self-defense-strategies-women-need-to-know"),
    Article(id: 2, title: "How To Position Yourself", image: "posi", content:"Positioning yourself so that you cannot be surprised or cornered makes it difficult for a predator to find an attack opportunity. Minimise the opportunity for an attack with these steps:  \n-Other people are your greatest protection. Stick with friends and take paths with people around. \n-Observe those around you- if someone seems to be following you, paying too much attention to you, or is in a position where they could surprise or trap you, stay away from them. \n-If someone on an elevator gives you the creeps, wait for the next one. \n-If someone is lingering by your car or front door, wait for them to leave. \n-You cannot defend what you cannot see which is why most attacks come from behind. Consider what's behind you. \n-When waiting for a bus stand with your back against a wall so you can see all angles.", author:"", url:""),
    Article(id: 3, title:"Keeping Safe Whilst Walking",image:"article1",content:"-Always try to walk facing on-coming traffic to avoid kerb crawlers (men who drive around looking for prostitutes). \n-If you do get asked for sex by someone slowly driving their car alongside you, feel free to report the creep to the police, it’s illegal. \n-If you think you are being followed, trust your instincts and take action. As confidently as you can, cross the road turning as you do to see who is behind you. If you are still being followed, cross again. Keep moving. Make for a busy area and ask for help – for example from a shop keeper. \n-If a vehicle pulls up suddenly alongside you, turn and walk in the other direction: you can turn much faster than a car. \n-Avoid confrontation. Do not meet aggression with aggression, as this is likely to escalate the situation. Talk your way out of problems, stay calm, speak gently, slowly and clearly. Breathe out slowly to help you relax. \n-If you are trapped or in danger, yell or scream. Your voice is your best defence. Shout, ‘Phone the police’ or other specific instructions which people can understand easily.",author: "The Mix", url: "https://www.themix.org.uk/crime-and-safety/personal-safety/safety-tips-for-women-9066.html"),
    Article(id: 4, title:"Using Taxis Safely",image:"taxi",content:"-Do not hail a minicab from the street or accept a lift from a minicab touting for trade: the driver could be anyone. Book a cab over the phone and when the cab arrives ask the driver his name and company. Ask what name he is expecting to collect. \n-Always try to share a cab with a friend. \n-If necessary walk to the nearest minicab office, keeping to well-lit streets and walking against the traffic and in sight of other people whenever possible. \n-Always sit in the back of a cab and if you get chatting to the driver do not give away personal details. \n-Let a friend know when you get a cab. Some taxi apps even let you share your journey route. Alternatively, you can download a free tracking app such as Find My Friends which can be useful when you use public transport or when you’re out late/on your own. \n-Trust your instincts – If you are at all worried, ask the driver to stop in a busy area and get out of the car. If the driver refuses to stop, use a mobile to call the police and alert other drivers and pedestrians by waving or calling out the window.",author:"The Mix", url: "https://www.themix.org.uk/crime-and-safety/personal-safety/safety-tips-for-women-9066.html"),
    Article(id: 5, title:"Safety On Public Transport",image:"transport-safety",content:"-Have your ticket, pass or change ready in your hand so that your wallet is out of sight. \n-Always wait for the bus or train in a well-lit place near other people if possible and try to arrange for someone to meet you at the bus stop or station. \n-Avoid empty carriages on trains. Always try to sit where there are lots of people. If you feel uneasy, move to another seat or carriage. \n-If a bus is empty or it is after dark, stay on the lower deck as near as possible to the driver. \n-If you feel threatened make as much noise as possible to attract the attention of the driver or guard.",author:"The Mix", url: "https://www.themix.org.uk/crime-and-safety/personal-safety/safety-tips-for-women-9066.html"),
    Article(id: 6, title:"Pocket Essentials",image:"pocket-essentials",content:"- A mobile, or at least some spare change to make a phone call. \n-A couple of numbers for reputable cab firms in your area/ area you go out. \n-If possible, carry a personal alarm and know how to use it to shock and disorientate an assailant so that you can get away.",author:"The Mix", url: "https://www.themix.org.uk/crime-and-safety/personal-safety/safety-tips-for-women-9066.html"),
    Article(id: 7, title:"Drink Spiking",image:"drink-spiking",content:"‘Drink spiking’ doesn’t just mean date-rape drugs; if someone buys you double shots without telling you, you could easily end up out of control and vulnerable: \n-Always watch your drink, or get your friend to watch it when you go to the loo; \n-If someone offers to buy you a drink, watch them order it at the bar; \n-If you start to feel weird (sick, dizzy, confused) find a friend and tell them.",author:"The Mix", url: "https://www.themix.org.uk/crime-and-safety/personal-safety/safety-tips-for-women-9066.html")
]


// used for creating the canvas

struct AdviceView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
    }
}
