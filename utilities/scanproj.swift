//
//  scanproj.swift
//  SwanKit
//
//  Created by anobisoft on 2026-07-27.
//

import Foundation

// Конфигурация выходного файла
let currentPath = FileManager.default.currentDirectoryPath
let outputFileName = "\(URL(fileURLWithPath: currentPath).lastPathComponent).txt"

print("⏳ Начинаю сбор файлов проекта в \(outputFileName)...")

// Функция для выполнения консольных команд (запуск git)
func runShellCommand(_ command: String, arguments: [String]) -> String? {
    let process = Process()
    let pipe = Pipe()

    process.standardOutput = pipe
    process.standardError = pipe
    process.arguments = arguments
    process.executableURL = URL(fileURLWithPath: command)

    do {
        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)
    } catch {
        print("❌ Ошибка выполнения команды \(command): \(error.localizedDescription)")
        return nil
    }
}

// 1. Получаем список файлов, которые не игнорируются гитом
guard let gitOutput = runShellCommand("/usr/bin/git", arguments: ["ls-files"]) else {
    print("❌ Не удалось запустить git. Убедитесь, что вы находитесь в git-репозитории.")
    exit(1)
}

// Разделяем вывод git на массив строк (путей к файлам)
let files = gitOutput
    .components(separatedBy: .newlines)
    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    .filter { !$0.isEmpty && $0 != outputFileName && !$0.contains("utilities/") && !$0.hasSuffix(".storyboard") }

var finalContent = ""

// 2. Обходим каждый файл и считываем его содержимое
for filePath in files {
    let fileURL = URL(fileURLWithPath: currentPath).appendingPathComponent(filePath)
    let fileName = fileURL.lastPathComponent

    // Проверяем, является ли это текстовым файлом, который можно прочитать
    do {
        let content = try String(contentsOf: fileURL, encoding: .utf8)

        // Форматируем метаданные в стиле, удобном для чтения нейросетями
        finalContent += "================================================\n"
        finalContent += "ИМЯ ФАЙЛА: \(fileName)\n"
        finalContent += "ПУТЬ: \(filePath)\n"
        finalContent += "================================================\n\n"
        finalContent += content
        finalContent += "\n\n"

        print("✅ Добавлен: \(filePath)")
    } catch {
        // Пропускаем бинарные файлы (картинки, сториборды, архивы), которые нельзя прочесть как UTF-8 строку
        print("⏩ Пропущен (не текстовый формат): \(filePath)")
    }
}

let outputFileURL = URL.documentsDirectory.appending(path: outputFileName)

do {
    try finalContent.write(to: outputFileURL, atomically: true, encoding: .utf8)
    print("\n🎉 Готово! Все данные успешно сохранены в файл: \(outputFileURL.path)")
} catch {
    print("❌ Не удалось записать итоговый файл: \(error.localizedDescription)")
}
