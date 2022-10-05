import Foundation

/*
    Extends Swift's native String type with wash(_: WashMode, _: CharacterSet) method.

    Wash modes:

    .leading
    - trims specific characters from the beginning of the string

    .trailing
    - trims specific characters from the end of the string

    .leadingAndTrailing
    - trims specific characters from the beginning and from the end of the string

    .occurencesOf
    - removes all occurences of specific characters from the string

    .inputLine
    - removes all unnessary whitespace and newlines from the string
    - designed to handle single line input (TextField)
    - igonores second argument (CharacterSet)

    .inputText
    - removes all unnessary whitespace and excessive newlines (more than 2 in a row) from the string
    - designed to handle single multiline input (TextEditor)
    - igonores second argument (CharacterSet)

    Calling wash() method with no mode specified works as whitespace trimmer.
*/

extension String
{
    enum WashMode
    {
        case leading
        case trailing
        case leadingAndTrailing
        case occurencesOf
        case inputLine
        case inputText
    }

    func wash(
        _ washMode: WashMode = .leadingAndTrailing,
        _ characterSet: CharacterSet = .whitespacesAndNewlines) -> String
    {
        switch washMode
        {
            case .leading:
                return trimLeading(characterSet)

            case .trailing:
                return trimTrailing(characterSet)

            case .leadingAndTrailing:
                return trimLeading(characterSet).trimTrailing(characterSet)

            case .occurencesOf:
                return String(self.unicodeScalars.filter(
                {
                    character in !characterSet.contains(character)
                }))

            case .inputLine:
                return washLine(self)

            case .inputText:
                return self
                    .components(separatedBy: .newlines)
                    .map({ element in washLine(element) })
                    .joined(separator: "\n")
                    .replacingOccurrences(
                        of: "\n{3,}",
                        with: "\n\n",
                        options: .regularExpression)
                    .wash(.leadingAndTrailing, CharacterSet(charactersIn: "\n"))
        }
    }

    private func trimLeading(_ characterSet: CharacterSet) -> String
    {
        if CharacterSet(charactersIn: self).isSubset(of: characterSet) { return "" }

        if let index = self.firstIndex(where:
        {
            character in !CharacterSet(character.unicodeScalars).isSubset(of: characterSet)
        })
        { return String(self[index...]) }

        return self
    }

    private func trimTrailing(_ characterSet: CharacterSet) -> String
    {
        if CharacterSet(charactersIn: self).isSubset(of: characterSet) { return "" }

        if let index = self.lastIndex(where:
        {
            character in !CharacterSet(character.unicodeScalars).isSubset(of: characterSet)
        })
        { return String(self[...index]) }

        return self
    }

    private func washLine(_ string: String) -> String
    {
        return string
            .components(separatedBy: .whitespacesAndNewlines)
            .filter({ element in element.count > 0 })
            .joined(separator: " ")
    }
}
