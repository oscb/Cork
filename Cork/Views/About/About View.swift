//
//  About View.swift
//  Cork
//
//  Created by David Bureš on 07.07.2022.
//

import SwiftUI
import DavidFoundation

struct AboutView: View
{
    @State private var usedPackages: [UsedPackage] = [
        UsedPackage(name: "DavidFoundation", whyIsItUsed: "My own package that provides some basic convenience features", packageURL: URL(string: "https://github.com/buresdv/DavidFoundation")!)
    ]
    @State private var acknowledgedContributors: [AcknowledgedContributor] = [
        AcknowledgedContributor(name: "Rob Napier", reasonForAcknowledgement: "Gave invaluable help with all sorts of problems, from async Swift to blocking package installations", profileService: "Mastodon", profileURL: URL(string: "https://elk.zone/mstdn.social/@cocoaphony@mastodon.social")!),
        AcknowledgedContributor(name: "Łukasz Rutkowski", reasonForAcknowledgement: "Fixed many async and SwiftUI problems", profileService: "Mastodon", profileURL: URL(string: "https://elk.zone/mstdn.social/@luckkerr@mastodon.world")!)
    ]
    
    @State private var isPackageGroupExpanded: Bool = false
    @State private var isContributorGroupExpanded: Bool = false

    var body: some View
    {
        HStack(alignment: .top, spacing: 20)
        {
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                .resizable()
                .frame(width: 100, height: 100)

            VStack(alignment: .leading, spacing: 20)
            {
                VStack(alignment: .leading)
                {
                    Text(NSApplication.appName!)
                        .font(.title)
                    Text("Version \(NSApplication.appVersion!) (\(NSApplication.buildVersion!))")
                        .font(.caption)
                }

                Text("© 2022 David Bureš and contributors.")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                VStack
                {
                    DisclosureGroup(isExpanded: $isPackageGroupExpanded)
                    {
                        List(usedPackages)
                        { package in
                            HStack
                            {
                                VStack(alignment: .leading)
                                {
                                    Text(package.name)
                                        .font(.headline)
                                    Text(package.whyIsItUsed)
                                        .font(.subheadline)
                                }

                                Spacer()

                                ButtonThatOpensWebsites(websiteURL: package.packageURL, buttonText: "GitHub")
                            }
                        }
                        .listStyle(.bordered(alternatesRowBackgrounds: true))
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            idealHeight: 100
                        )
                    } label: {
                        Text("Packages Used")
                    }
                    .animation(.none, value: isPackageGroupExpanded)
                    
                    DisclosureGroup
                    {
                        List(acknowledgedContributors)
                        { contributor in
                            HStack
                            {
                                VStack(alignment: .leading)
                                {
                                    Text(contributor.name)
                                        .font(.headline)
                                    Text(contributor.reasonForAcknowledgement)
                                        .font(.subheadline)
                                }

                                Spacer()

                                ButtonThatOpensWebsites(websiteURL: contributor.profileURL, buttonText: contributor.profileService)
                            }
                        }
                        .listStyle(.bordered(alternatesRowBackgrounds: true))
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            idealHeight: 100
                        )
                    } label: {
                        Text("Acknowledged Contributors")
                    }
                    .animation(.none, value: isContributorGroupExpanded)
                }

                HStack
                {
                    Button {
                        NSWorkspace.shared.open(URL(string: "https://github.com/buresdv/Cork")!)
                    } label: {
                        Label("Contribute", systemImage: "curlybraces")
                    }

                    Spacer()
                    
                    Button
                    {
                        NSWorkspace.shared.open(URL(string: "https://elk.zone/mstdn.social/@davidbures")!)
                    } label: {
                        Label("Contact Me", systemImage: "paperplane")
                    }
                }
            }
            .frame(width: 300, alignment: .topLeading)
            .animation(.none)
        }
        .padding()
    }
}
