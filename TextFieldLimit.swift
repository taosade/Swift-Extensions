// Limit TextField's input string length

import SwiftUI

extension View
{
	func inputLimit(_ text: Binding<String>, to limit: Int) -> some View
	{
		self.onChange(of: text.wrappedValue)
		{
			_ in text.wrappedValue = String(text.wrappedValue.prefix(limit))
		}
	}
}

struct TextFieldLimit: View
{
	@State var input: String = ""

	private var limit = 8

    var body: some View
	{
		TextField("Type up to \(limit) characters…", text: $input)
		.inputLimit($input, to: limit)
    }
}

struct TextFieldLimit_Previews: PreviewProvider
{
    static var previews: some View
	{
        TextFieldLimit()
    }
}
