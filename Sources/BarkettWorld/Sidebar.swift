//
//  File.swift
//  
//
//  Created by Ben Barkett on 12/20/20.
//

import Foundation
import Plot
import Publish

extension Node where Context == HTML.BodyContext {
    static func sidenav(for site: BarkettWorld) -> Node {
        return .div(
            .class("sidenav"),
            .div(
                .class("sidenav-header"),
                .a(
                    .href("/"),
                    .img(
                        .src("/Images/logo_no_text.png"),
                        .attribute(named: "width", value: "100"),
                        .attribute(named: "height", value: "100")
                    )
                ),
                .h1(.text(site.name.uppercased())),
                .p(.text(site.description))
            ),//img + title + desc div
            .div(
                .class("sidenav-nav"),
                .nav(
                    .ul(
                        .li(.a(
                            .class("sidenav-about"),
                            .href("/about"),
                            .text("ABOUT")
                        )),
                        .li(.a(
                            .class("sidenav-posts"),
                            .href("/posts"),
                            .text("POSTS")
                        )),
                        .li(.a(
                            .class("sidenav-projects"),
                            .href("/projects"),
                            .text("PROJECTS")
                        )),
                        .li(.a(
                            .class("sidenav-contact"),
                            .href("/contact"),
                            .text("CONTACT")
                        ))
                    )
                )
            )//nav
        )
    }
}


