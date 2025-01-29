import SwiftUI

struct ContentView: View {

    init() {
        RobotoMono.registerFonts()
    }

    var body: some View {
        DottedGermanyArrayView()
    }
}

public struct RobotoMono {
    public static func registerFonts() {
        registerFont(bundle: Bundle.main , fontName: "RobotoMono-VariableFont_wght", fontExtension: ".ttf") //change according to your ext.
    }
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {

        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }

        var error: Unmanaged<CFError>?

        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
