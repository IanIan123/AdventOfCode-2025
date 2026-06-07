| input stream lines items ops total cols clonedItems |

stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.

lines := input lines.
ops := lines at: (lines size).

1 to: (ops size) do: [:i |
	| c |
	c := ops at: i.
	((c =  $* or: [ c = $+ ]) and: [ i > 1 ])
		ifTrue: [
			1 to: (lines size) do: [:j |
				(lines at: j) at: (i -1) put: $-.
			].
		].
].

items := lines collect: [:x |
	| cells |
	cells := x findTokens: '-'.
	cells collect: [:each | 
		each asInteger isNil 
			ifTrue: [each withBlanksTrimmed]
			ifFalse: [each]
	]
].

clonedItems := items deepCopy.
rows := (clonedItems size) - 1.
cols := (clonedItems at: 1) size.

1 to: cols do: [:numCol |
	1 to: rows do: [:numRow |
		| newNum line numStrFirst digitsWidth |	
		newNum := ''.
		numStrFirst := (items at: 1) at: numCol.
		digitsWidth := numStrFirst size.
		(numRow <= digitsWidth)
			ifTrue: [
				1 to: rows do: [:digitRow |
					| numStr digitCol digit |
					numStr := (items at: digitRow) at: numCol.
					digitCol := (digitsWidth + 1) - numRow .
					digit := (numStr at: digitCol) asString.
					newNum := newNum, digit
				].
				newNum := newNum asInteger
			]
			ifFalse: [ newNum := 0 ].
		line := clonedItems at: numRow.
		line at: numCol put: newNum.
	].
].

clonedItems at: (items size) put: (items at: (items size)).
items := clonedItems.

total := 0.

1 to: cols do: [:i |
	| op result |
	op := (items at: (items size)) at: i.
	result := (items at: 1) at: i.
	2 to: (items size - 1) do: [:j |
		| line value |
		line := items at: j.
		value := line at: i.
		(op = '*')
			ifTrue: [ 
				(value = 0)
					ifFalse: [ result := result * value ]
			]
			ifFalse: [ result := result + value ].
	].
	total := total + result.
].

Transcript show: total printString; cr.