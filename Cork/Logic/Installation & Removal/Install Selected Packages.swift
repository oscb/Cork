//
//  Install Selected Packages.swift
//  Cork
//
//  Created by David Bureš on 04.07.2022.
//

import Foundation
import SwiftUI

enum InstallationError: Error
{
    case outputHadErrors
}

@MainActor
func installPackage(package: BrewPackage, installationProgressTracker: InstallationProgressTracker, brewData: BrewDataStorage) async throws -> TerminalOutput
{
    print("Installing package \(package.name)")

    var installationResult: TerminalOutput

    if !package.isCask
    {
        async let installationResultComplete: TerminalOutput = await shell("/opt/homebrew/bin/brew", ["install", package.name])
        
        print("Result for installing Formula \(package.name): \(await installationResultComplete)")

        if await installationResultComplete.standardError.contains("error")
        {
            throw InstallationError.outputHadErrors
        }
        else
        {
            installationResult = await installationResultComplete
            
            withAnimation {
                brewData.installedFormulae.append(BrewPackage(name: package.name, isCask: package.isCask, installedOn: package.installedOn, versions: [extractPackageVersionFromTerminalOutput(terminalOutput: installationResult, packageBeingInstalled: package)], sizeInBytes: package.sizeInBytes))
            }
        }
    }
    else
    {
        async let installationResultComplete: TerminalOutput = await shell("/opt/homebrew/bin/brew", ["install", "--cask", package.name])
        
        print("Result for installing Cask \(package.name): \(await installationResultComplete)")

        if await installationResultComplete.standardError.contains("error")
        {
            throw InstallationError.outputHadErrors
        }
        else {
            installationResult = await installationResultComplete
            
            withAnimation {
                #warning("This fails to get the version for some reason. Figure out why")
                brewData.installedCasks.append(BrewPackage(name: package.name, isCask: package.isCask, installedOn: package.installedOn, versions: [extractPackageVersionFromTerminalOutput(terminalOutput: installationResult, packageBeingInstalled: package)], sizeInBytes: package.sizeInBytes))
            }
        }
    }

    installationProgressTracker.packagesStillLeftToInstall.removeAll(where: { $0 == package.name })
    
    return installationResult
}

/*@MainActor
func installSelectedPackages(packageArray: [String], tracker: InstallationProgressTracker, brewData _: BrewDataStorage)
{
    let progressSteps = Float(1) / Float(packageArray.count)
    print(progressSteps)

    tracker.progressNumber = 0

    for package in packageArray
    {
        Task
        {
            tracker.packageBeingCurrentlyInstalled = package
            print("Trying to install \(tracker.packageBeingCurrentlyInstalled)")

            let installCommandOutput = await shell("/opt/homebrew/bin/brew", ["install", package])

            if installCommandOutput.standardOutput.contains("Pouring")
            {
                print("Installing \(tracker.packageBeingCurrentlyInstalled) at \(tracker.progressNumber)")
                tracker.progressNumber += progressSteps
            }
            else
            {
                tracker.isShowingInstallationFailureAlert = true
            }
        }
    }
}*/
