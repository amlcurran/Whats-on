import UIKit
import SwiftUI
import Core

struct HeaderView2: View {
    
    private enum ShownSheet: String, Identifiable {
        case settings
        
        var id: String {
            rawValue
        }
    }

    let onShareModeTapped: () -> Void
    @State private var shownSheet: ShownSheet?
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(Date(), format: .dateTime
                            .year()
                            .month(.wide)
                            .day()
                            .weekday(.wide))
                        .textCase(.uppercase)
                        .font(.system(size: 14)
                                .weight(.semibold))
                        .foregroundColor(.accentColor)
                    Text("What's on")
                        .font(.system(size: 32)
                                .weight(.heavy))
                        .foregroundColor(Color("secondary"))
                }
                Spacer(minLength: 16)
                Menu {
                    Button("Settings") {
                        shownSheet = .settings
                    }
                    Button("Private Share") {
                        onShareModeTapped()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 20))
                }
            }
            .padding()
        }
        .accentColor(Color("accent"))
        .background(Color("windowBackground"))
        .sheet(item: $shownSheet, onDismiss: nil) { sheet in
            switch sheet {
            case .settings:
                let timeStore = UserDefaultsTimeStore()
                let calendarPreferenceStore = CalendarPreferenceStore()
                let shownCalendars = CalendarLoader(preferenceStore: calendarPreferenceStore).load()
                OptionsView(startDate: timeStore.startDateBinding,
                                       endDate: timeStore.endDateBinding,
                                       allCalendars: shownCalendars) {
                    shownSheet = nil
                }
            }
            
        }
    }
}

struct HeaderView2_Preview: PreviewProvider {
    
    static var previews: some View {
        HeaderView2 {
            
        }
        .previewLayout(.sizeThatFits)
    }
    
}
