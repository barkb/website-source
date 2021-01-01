import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct BarkettWorld: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case about
        case projects
        case contact

    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://your-website-url.com")!
    var name = "Ben Barkett"
    var description = "Hello! I'm Ben Barkett: an aspiring Software Developer and graduating senior with degrees in Computer Science and Economics."
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try BarkettWorld().publish(
    withTheme: .primary
    )
