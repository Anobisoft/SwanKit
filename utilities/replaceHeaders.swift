#!/usr/bin/env swift
import Foundation

let fileManager = FileManager.default
let currentPath = fileManager.currentDirectoryPath

// Вспомогательная функция для выполнения консольных команд
func shell(_ command: String) -> String? {
    let task = Process()
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh")

    do {
        try task.run()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            return output.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    } catch {
        return nil
    }
    return nil
}

// 1. Динамически определяем имя remote и парсим его URL
let (holderName, projectName): (String, String) = {
    let defaultProject = URL(fileURLWithPath: currentPath).lastPathComponent
    let defaultHolder = NSUserName()

    // Получаем список всех remote и берем самый первый (обычно origin, upstream или дефолтный)
    guard let remoteList = shell("git remote"), !remoteList.isEmpty else {
        return (defaultHolder, defaultProject)
    }

    let firstRemote = remoteList.components(separatedBy: .newlines)
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .first(where: { !$0.isEmpty }) ?? "origin"

    // Получаем URL для выбранного remote
    guard let remoteURL = shell("git remote get-url \(firstRemote)"), !remoteURL.isEmpty else {
        return (defaultHolder, defaultProject)
    }

    // Очищаем от расширения .git
    var cleanedURL = remoteURL
    if cleanedURL.hasSuffix(".git") {
        cleanedURL = String(cleanedURL.dropLast(4))
    }

    // Поддерживаем SSH-формат (заменяем двоеточие на слэш)
    cleanedURL = cleanedURL.replacingOccurrences(of: ":", with: "/")

    // Разбиваем путь на компоненты
    let components = cleanedURL.components(separatedBy: "/").filter { !$0.isEmpty }

    if components.count >= 2 {
        let project = components[components.count - 1]
        let holder = components[components.count - 2]
        return (holder, project)
    }

    return (defaultHolder, defaultProject)
}()

// 2. Получаем имя автора из Git
let userName: String = {
    if let gitName = shell("git config user.name"), !gitName.isEmpty {
        return gitName
    }
    return NSUserName()
}()

// Функция генерации компактной шапки
func makeHeader(forFileName fileName: String, creationDate: String, copyrightYear: String) -> String {
    return """
    //
    //  \(fileName)
    //  \(projectName)
    //
    //  Created by \(userName) on \(creationDate).
    //  Copyright © \(copyrightYear) \(holderName). Licensed under the MIT License.
    //
    
    
    """ // Два переноса строки для отделения от импортов
}

func cleanAndReplaceHeader(in content: String, with newHeader: String) -> String {
    let lines = content.components(separatedBy: .newlines)
    var headerEndIndex = 0

    for (index, line) in lines.enumerated() {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        if index == 0 && !trimmed.hasPrefix("//") {
            break
        }
        if trimmed.hasPrefix("//") {
            headerEndIndex = index + 1
        } else if trimmed.isEmpty {
            headerEndIndex = index + 1
        } else {
            break
        }
    }

    let remainingLines = lines.suffix(from: headerEndIndex)
    let cleanContent = remainingLines.joined(separator: "\n")
    return newHeader + cleanContent
}

func processDirectory(at path: String) {
    guard let enumerator = fileManager.enumerator(atPath: path) else { return }

    while let relativePath = enumerator.nextObject() as? String {
        // Пропускаем служебные директории, скрытые файлы и кэши
        if relativePath.contains(".build") ||
            relativePath.contains(".swiftpm") ||
            relativePath.contains(".xcodeproj") ||
            relativePath.contains(".git/") ||
            relativePath.contains("utilities/") {
            continue
        }

        if relativePath.hasSuffix(".swift") {
            let fileURL = URL(fileURLWithPath: path).appendingPathComponent(relativePath)
            let fileName = fileURL.lastPathComponent

            // Защита манифеста пакета
            if fileName == "Package.swift" {
                continue
            }

            // 3. Вытягиваем дату ПЕРВОЙ ревизии файла из истории Git коммитов
            let gitCmd = "git log --follow --format=%as -- \"\(fileURL.path)\" | tail -1"
            let gitDate = shell(gitCmd)

            let formattedCreationDate: String
            let copyrightYear: String

            if let date = gitDate, !date.isEmpty {
                formattedCreationDate = date
                copyrightYear = String(date.prefix(4))
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formattedCreationDate = formatter.string(from: Date())

                formatter.dateFormat = "yyyy"
                copyrightYear = formatter.string(from: Date())
            }

            guard let fileContent = try? String(contentsOf: fileURL, encoding: .utf8) else { continue }

            let dynamicHeader = makeHeader(forFileName: fileName, creationDate: formattedCreationDate, copyrightYear: copyrightYear)
            let updatedContent = cleanAndReplaceHeader(in: fileContent, with: dynamicHeader)

            if updatedContent != fileContent {
                do {
                    try updatedContent.write(to: fileURL, atomically: true, encoding: .utf8)
                    print("🧹 : \(relativePath) [\(formattedCreationDate)]")
                } catch {
                    print("❌ Ошибка записи \(fileName): \(error.localizedDescription)")
                }
            }
        }
    }
}

print("🚀 Данные из репозитория -> Владелец: [\(holderName)], Проект: [\(projectName)]")
print("🚀 Тотальный разбор истории Git...")
processDirectory(at: currentPath)
print("🏁 Все шапки успешно приведены к единому формату!")
