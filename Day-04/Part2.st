| input stream grid lines rowCount colCount directions total iterate result |

stream := FileStream readOnlyFileNamed: 'input-day3.txt'.
input := stream contentsOfEntireFile.
stream close.

lines := input lines.
rowCount := lines size.
colCount := (lines first) size.

grid := Array new: rowCount.
1 to: rowCount do: [:i |
	grid at: i put: ((lines at: i) asArray).
].

directions := (#(-1 0 1) collect: [:x |
	#(-1 0 1) collect: [:y | Point x: x y: y]
]) flatten.
directions := directions reject: [:v | v x = 0 and: [v y = 0]].

total := 0.

iterate := [
	| sum |
	sum := 0.
	1 to: rowCount do: [:i |
		1 to: colCount do: [:j |
			| cell point newPoints chars count |
			cell := (grid at: i) at: j.
			(cell = $@)
				ifTrue: [
					point := Point x: i y: j.
					newPoints := (directions collect: [:x |
						x + point
					]) select: [:p |
					    (p x >= 1 and: [p x <= colCount]) and: 
					    (p y >= 1 and: [p y <= rowCount])
					].
					chars := newPoints collect: [:p |
						(grid at: (p x)) at: (p y)
					].
					count := chars count: [:each | each = $@].
					(count < 4)
						ifTrue: [
							(grid at: i) at: j put: $..
							sum := sum + 1.
						]
			]
		]
	].
	sum
].

result := iterate value.
[result > 0] whileTrue: [
	total := total + result.
	result := iterate value
].

Transcript show: 'Total: ', total printString; cr.