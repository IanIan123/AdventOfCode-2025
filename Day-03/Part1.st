| input ranges total stream getPair |

getPair := [:joltage |
	| numbers max | 
	numbers := (joltage asArray collect: [:each | each digitValue]).
	max := 0.
	1 to: numbers size do: [:i |
		i + 1 to: numbers size do: [:j |
			| num1 num2 num |
			num1 := numbers at: i.
			num2 := numbers at: j.
			num := (num1 asString, num2 asString) asInteger.
			(num > max)
				ifTrue: [ max := num].
		]
	].
	max
].

stream := FileStream readOnlyFileNamed: 'input-day2.txt'.
input := stream contentsOfEntireFile.
stream close.

ranges := input lines.
total := 0.
ranges do: [:range |
    total := total + (getPair value: range)
].
Transcript show: 'Total: ', total printString; cr.