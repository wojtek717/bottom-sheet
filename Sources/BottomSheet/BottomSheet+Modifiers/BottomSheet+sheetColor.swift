import SwiftUI

public extension BottomSheet {
    func sheetColor(_ color: Color) -> BottomSheet {
        self.configuration.sheetColor = color
        return self
    }
}
