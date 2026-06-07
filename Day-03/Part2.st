| input ranges total stream getNumbers |

getNumbers := nil.
getNumbers := [:numbers :space |
	| max upperBound index result |
	(space = 0)
		ifTrue: [ #() ]
		ifFalse: [
			max := 0.
			upperBound := numbers size - (space - 1).
			1 to: upperBound do: [:i |
				| num |
				num := numbers at: i.
				(num > max)
					ifTrue: [
						max := num.
						index := i
					].
			].
			result := {max}, (getNumbers value: (numbers allButFirst: index) value: space - 1).
			result.
		].
].

stream := FileStream readOnlyFileNamed: 'input-day2.txt'.
input := stream contentsOfEntireFile.
stream close.

ranges := input lines.
total := 0.
ranges do: [:range |
	| numbers number |
	numbers := getNumbers value: (range asArray collect: [:each | each digitValue]) value: 12.
	number := ((numbers collect: [:each | each asString]) joinSeparatedBy: '') asInteger.
	total := total + number.
].
Transcript show: 'Total: ', total printString; cr.