import UIKit

public final class CardExpirationDateFormatter: NSObject, UITextFieldDelegate {
    
    // MARK: - Methods
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        guard string.allSatisfy({ "0123456789".contains($0) }) else { return false }
        
        guard let text = textField.text as NSString? else { return true }
        let newString = text.replacingCharacters(in: range, with: string)
        let formattedString = formatExpirationDate(newString)
        textField.text = formattedString
        return false
    }
    
    // MARK: - Private methods
    
    private func formatExpirationDate(_ date: String) -> String {
        let cleanedDate = date.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        let maxLength = 4
        let formattedLength = min(cleanedDate.count, maxLength)
        
        var formattedDate = ""
        for i in 0..<formattedLength {
            if i == 2 {
                formattedDate.append("/")
            }
            let index = cleanedDate.index(cleanedDate.startIndex, offsetBy: i)
            formattedDate.append(cleanedDate[index])
        }
        
        return formattedDate
    }
}
