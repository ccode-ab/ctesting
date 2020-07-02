import XCTest
import SnapshotTesting
import UIKit

open class TestCase: XCTestCase {

    // MARK: - Snapshots

    public let snapshotWidth: CGFloat = 375
    public let snapshotWidthExtended: CGFloat = 1024

    public enum TraitOverride: CaseIterable {
        case none
        case dark

        fileprivate var traitCollection: UITraitCollection {
            switch self {
            case .none:
                return UITraitCollection()
            case .dark:
                if #available(iOS 12.0, *) {
                    return UITraitCollection(userInterfaceStyle: .dark)
                } else {
                    XCTFail("Testing dark mode on iOS 11 or older.")
                    return UITraitCollection()
                }
            }
        }

        fileprivate var suffix: String {
            switch self {
            case .none: return ""
            case .dark: return ".Dark"
            }
        }
    }

    open func assertSnapshot(
        named name: String? = nil,
        skippingTraits: Set<TraitOverride> = [],
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line,
        matching value: () -> UIView) {

        for traitOverride in TraitOverride.allCases {
            guard !skippingTraits.contains(traitOverride)
                else { continue }

            SnapshotTesting.assertSnapshot(
                matching: value(),
                as: .image(traits: traitOverride.traitCollection),
                named: "\(name ?? "")\(traitOverride.suffix)",
                record: ProcessInfo.processInfo.environment["DEVELOPMENT"] != nil,
                timeout: 5,
                file: file,
                testName: testName,
                line: line
            )
        }
    }

    open override func recordFailure(withDescription description: String, inFile filePath: String, atLine lineNumber: Int, expected: Bool) {
        if ProcessInfo.processInfo.environment["DEVELOPMENT"] != nil && description.hasPrefix("failed - Record mode is on.") {
            NSLog("Development. Ignoring failed recording of snapshot test.")
        } else {
            super.recordFailure(withDescription: description, inFile: filePath, atLine: lineNumber, expected: expected)
        }
    }
}
