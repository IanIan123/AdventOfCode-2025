| input stream lines items total |

stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.

lines := input lines.
items := lines collect: [:x |
	(x findTokens: ' ') collect: [:each | 
		each asInteger isNil 
			ifTrue: [each]
			ifFalse: [each asInteger]
	]
].

total := 0.

(1 to: (items at: 1) size) do: [:i |
	| op result |
	op := (items at: (items size)) at: i.
	result := (items at: 1) at: i.
	2 to: (items size - 1) do: [:j |
		| line value |
		line := items at: j.
		value := line at: i.
		(op = '*')
			ifTrue: [ result := result * value ]
			ifFalse: [ result := result + value ].
	].
	total := total + result.
].

Transcript show: total printString; cr.