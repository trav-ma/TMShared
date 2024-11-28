//
//  FileHandler.swift
//  Low Quality Clips
//
//  Created by Travis Ma on 10/1/23.
//

import AVFoundation
import UniformTypeIdentifiers
import AppKit

struct MacOSFileHandler {
    private static let BOOKMARK_KEY = "bookmark"
    
    static func clearSelectedFolder() {
        UserDefaults.standard.removeObject(forKey: BOOKMARK_KEY)
    }
    
    /*
     check if permissions granted for selected folder
     */
    static func isPermissionGranted() -> Bool {
        if let data = UserDefaults.standard.data(forKey: BOOKMARK_KEY) {
            var bookmarkDataIsStale: ObjCBool = false
            do {
                let url = try (
                    NSURL(
                        resolvingBookmarkData: data,
                        options: [
                            .withoutUI,
                            .withSecurityScope
                        ],
                        relativeTo: nil,
                        bookmarkDataIsStale: &bookmarkDataIsStale
                    ) as URL
                )
                if bookmarkDataIsStale.boolValue {
                    NSLog("WARNING stale security bookmark")
                    return false
                }
                return url.startAccessingSecurityScopedResource()
            } catch {
                print("\(#file).\(#function) Error \(error)")
            }
        }
        return false
    }
    
    /*
     returns selected folder if permission is granted
     */
    static func selectedFolder() -> URL? {
        if let data = UserDefaults.standard.data(forKey: BOOKMARK_KEY) {
            var bookmarkDataIsStale: ObjCBool = false
            do {
                let url = try (
                    NSURL(
                        resolvingBookmarkData: data,
                        options: [
                            .withoutUI,
                            .withSecurityScope
                        ],
                        relativeTo: nil,
                        bookmarkDataIsStale: &bookmarkDataIsStale
                    ) as URL
                )
                if bookmarkDataIsStale.boolValue {
                    print("WARNING stale security bookmark")
                    return nil
                }
                if !url.startAccessingSecurityScopedResource() {
                    return nil
                }
                return url
            } catch {
                print("\(#file).\(#function) Error \(error)")
            }
        }
        return nil
    }
    
    /*
     check if permissions granted and if not, call selectFolder
     */
    static func selectFolder() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.title = "Select an output folder"
        openPanel.message = "Select an output folder"
        openPanel.prompt = "Select"
        openPanel.showsResizeIndicator = true
        openPanel.showsHiddenFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        if (openPanel.runModal() == NSApplication.ModalResponse.OK) {
            if let url = openPanel.url {
                storeFolderInBookmark(url: url)
                return url
            }
        }
        return nil
    }
    
    /*
     stores selected folder for future reference
     */
    private static func storeFolderInBookmark(url: URL) {
        do {
            let data = try url.bookmarkData(
                options: NSURL.BookmarkCreationOptions.withSecurityScope,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            UserDefaults.standard.set(data, forKey: BOOKMARK_KEY)
        } catch {
            print("\(#file).\(#function) Error \(error)")
        }
    }
    
    static func fileSizeInMB(url: URL?) -> Double {
        guard let url = url, url.isFileURL else { return 0 }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: url.path)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / (1024 * 1024)
            }
        } catch {
            print("\(#file).\(#function) Error \(error)")
        }
        return 0.0
    }
    
    static func isVideo(_ fileURL: URL) -> Bool {
        let fileExtension = fileURL.pathExtension
        if let uti = UTType(filenameExtension: fileExtension) {
            return uti.conforms(to: .movie)
        }
        return false
    }
    
    static func isDirectory(_ fileURL: URL) -> Bool {
        do {
            let resourceValues = try fileURL.resourceValues(forKeys: [.isDirectoryKey])
            return resourceValues.isDirectory ?? false
        } catch {
            print("\(#file).\(#function) Error \(error)")
        }
        return false
    }
    
    static func getMovieFiles(in folderURL: URL) -> [URL] {
        let fileURLs = getFilesInFolder(in: folderURL)
        return fileURLs.filter { isVideo($0) }
    }
    
    static func getFilesInFolder(in folderURL: URL) -> [URL] {
        var files = [URL]()
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(
                at: folderURL,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: []
            )
            for fileURL in fileURLs {
                let resourceValues = try fileURL.resourceValues(forKeys: [.isDirectoryKey])
                if let isDirectory = resourceValues.isDirectory, !isDirectory {
                    files.append(fileURL)
                }
            }
        } catch {
            print("\(#file).\(#function) Error \(error)")
        }
        return files
    }
    
    static func deleteAllFiles(in folderUrl: URL) {
        do {
            let fileURLs = getFilesInFolder(in: folderUrl)
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch {
            print("\(#file).\(#function) Error \(error)")
        }
    }
    
    static func appendToFileName(originalUrl: URL, appendString: String) -> URL? {
        let fileExtension = originalUrl.pathExtension
        let originalName = originalUrl.deletingPathExtension().lastPathComponent
        let directory = originalUrl.deletingLastPathComponent()
        return directory.appendingPathComponent("\(originalName)_\(appendString).\(fileExtension)")
    }
}
