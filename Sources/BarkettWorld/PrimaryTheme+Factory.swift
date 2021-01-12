//
//  PrimaryTheme.swift
//  
//
//  Created by Ben Barkett on 12/18/20.
//

import Foundation
import Plot
import Publish

public extension Theme {
    //My custom theme based on Sundell's original Foundation Theme
    static var primary: Self {
        Theme(
            htmlFactory: BWHtmlFactory(),
            resourcePaths: ["Resources/Themes/styles.css"]
        )
    }
}

private struct BWHtmlFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                .sidenav(for: context.site as! BarkettWorld),
                .wrapper(
                        .class("main"),
                        .h1("Latest content"),
                        .itemList(
                             for: context.allItems(
                                 sortedBy: \.date,
                                 order: .descending
                             ),
                             on: context.site
                         ),
                        .footer(for: context.site)
                     ) //wrapper
            )
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body(
                .sidenav(for: context.site as! BarkettWorld),
                .wrapper(
                    .class("main"),
                    .h1(.text(section.title)),
                    .itemList(
                        for: section.items,
                         on: context.site
                     ),
                    .footer(for: context.site)
                ) // wrapper
                     
            )

        )
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .sidenav(for: context.site as! BarkettWorld),
                .wrapper(
                    .class("main"),
                    .article(
                        .contentBody(item.body),
                        .span("Tagged with: "),
                        .tagList(for: item, on: context.site)
                    )
                    ,
                    .footer(for: context.site)
                ) // wrapper
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
            HTML(
                .lang(context.site.language),
                .head(for: page, on: context.site),
                .body(
                    .sidenav(for: context.site as! BarkettWorld),
                    .wrapper(
                        .class("main"),
                        .contentBody(page.body),
                        .footer(for: context.site)
                    ) // wrapper
                )
            )
        }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .sidenav(for: context.site as! BarkettWorld),
                .wrapper(
                    .class("main"),
                    .h1("Browse all tags"),
                    .ul(
                        .class("all-tags"),
                        .forEach(page.tags.sorted()) { tag in
                            .li(
                                .class("tag"),
                                .a(
                                    .href(context.site.path(for: tag)),
                                    .text(tag.string)
                                )
                            )
                        }
                    ),
                    .footer(for: context.site)
                )
            )
        )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .sidenav(for: context.site as! BarkettWorld),
                .wrapper(
                    .class("main"),
                    .h1(
                        "Tagged with ",
                        .span(.class("tag"), .text(page.tag.string))
                    ),
                    .a(
                        .class("browse-all"),
                        .text("Browse all tags"),
                        .href(context.site.tagListPath)
                    ),
                    .itemList(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    ),
                    .footer(for: context.site)
                )
            )
        )
    }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }

    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        let sectionIDs = T.SectionID.allCases

        return .header(
            .wrapper(
                .div(
                    .a(
                        .img(
                            .src("/Images/logo_no_text.png")
    //                        .attribute(named: "width", value: "600"),
    //                        .attribute(named: "height", value: "300")
                        ),
                        .href("/")
                    )//a
                ),
                .a(.class("site-name"), .href("/"), .text(context.site.name)),
                .p(.text(context.site.description)),
                .if(sectionIDs.count > 1,
                    .nav(
                        .ul(.forEach(sectionIDs) { section in
                            .li(.a(
                                .class(section == selectedSection ? "selected" : ""),
                                .href(context.sections[section].path),
                                .text(context.sections[section].title)
                            ))
                        })
                    )
                )
            )//wrapper
        )
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(
                    .img(
                        .src(item.imagePath ?? "/Images/blogicon.png"),
                        .attribute(named: "width", value: "50px"),
                        .attribute(named: "height", value: "50px")
                    ),
                    .article(
                        .h1(.a(
                            .href(item.path),
                            .text(item.title)
                        )),
                        .tagList(for: item, on: site),
                        .p(.text(item.description))
                )
                )
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.a(
                .href(site.path(for: tag)),
                .text(tag.string)
            ))
        })
    }

    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .p(
                .text("Generated using "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                )
            ),
            .p(.a(
                .text("RSS feed"),
                .href("/feed.rss")
            ))
        )
    }
}
