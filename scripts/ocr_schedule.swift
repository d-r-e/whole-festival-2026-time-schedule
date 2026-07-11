import Foundation
import Vision

for path in CommandLine.arguments.dropFirst() {
    let request = VNRecognizeTextRequest()
    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = false
    let handler = VNImageRequestHandler(url: URL(fileURLWithPath: path), options: [:])
    try handler.perform([request])
    let lines = (request.results ?? []).compactMap { observation -> (CGFloat, String)? in
        guard let text = observation.topCandidates(1).first?.string else { return nil }
        return (observation.boundingBox.midY, text)
    }.sorted { $0.0 > $1.0 }
    print("\n=== \(URL(fileURLWithPath: path).lastPathComponent) ===")
    for (_, text) in lines { print(text) }
}
