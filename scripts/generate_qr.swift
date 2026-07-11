#!/usr/bin/env swift
import AppKit
import CoreImage
import Foundation

let url = "https://d-r-e.github.io/whole-festiva-2026-time-schedule/"
let output = URL(fileURLWithPath: CommandLine.arguments.dropFirst().first ?? "whole-festival-timetable-qr.png")

guard let filter = CIFilter(name: "CIQRCodeGenerator") else { fatalError("QR generator is unavailable") }
filter.setValue(url.data(using: .utf8), forKey: "inputMessage")
filter.setValue("M", forKey: "inputCorrectionLevel")
guard let code = filter.outputImage else { fatalError("Could not create QR code") }

let scaled = code.transformed(by: CGAffineTransform(scaleX: 12, y: 12))
let context = CIContext()
guard let image = context.createCGImage(scaled, from: scaled.extent),
      let png = NSBitmapImageRep(cgImage: image).representation(using: .png, properties: [:]) else {
    fatalError("Could not render QR code")
}
try png.write(to: output)
print("wrote \(output.path)")
