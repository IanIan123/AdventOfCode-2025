| input stream total numbers rangesStr ranges |

stream := FileStream readOnlyFileNamed: 'input-day5.txt'.
input := stream contentsOfEntireFile.
stream close.

pos := input indexOfSubCollection: (String lf, String lf).

rangesStr := ((input copyFrom: 1 to: pos - 1) lines).
ranges := rangesStr collect: [:r |
    ((r findTokens: '-') collect: [:each | each asInteger]) asSortedCollection asArray
].
numbers := ((input copyFrom: pos + 2 to: input size) lines) collect: [:each | each asInteger].

total := 0.

numbers do: [:each |
	(ranges anySatisfy: [:range |
		| low high |
		low := range at: 1.
		high := range at: 2.
		(each between: low and: high)
	]) ifTrue: [
		total := total + 1.
	].
].

Transcript show: 'Total: ', total printString; cr.