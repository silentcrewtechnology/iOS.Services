import UIKit

public final class CardNumberFormatter: NSObject, UITextFieldDelegate {
    
    // MARK: - Methods
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        guard string.allSatisfy({ "0123456789".contains($0) }) else { return false }
        
        guard let text = textField.text as NSString? else { return true }
        let newString = text.replacingCharacters(in: range, with: string)
        let formattedString = formatCardNumber(newString)
        textField.text = formattedString
        return false
    }
    
    // MARK: - Private methods
    
    private func formatCardNumber(_ cardNumber: String) -> String {
        let cleanedCardNumber = cardNumber.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        let maxLength = 16
        let formattedLength = min(cleanedCardNumber.count, maxLength)
        
        var formattedCardNumber = ""
        for i in 0..<formattedLength {
            if i % 4 == 0 && i > 0 {
                formattedCardNumber.append(" ")
            }
            let index = cleanedCardNumber.index(cleanedCardNumber.startIndex, offsetBy: i)
            formattedCardNumber.append(cleanedCardNumber[index])
        }
        
        return formattedCardNumber
    }
}
