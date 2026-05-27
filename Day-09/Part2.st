| stream input lines points pointsCompressed pairs sortedPairs xs ys map rowCount colCount queue directions |

Transcript clear.

stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.

lines := input lines.

points := OrderedCollection new.
1 to: lines size do: [:i |
	| point |
	point := ((lines at: i) findTokens: ',') collect: [:each | each asInteger].
	points add: (point at: 1) @ (point at: 2)
].

xs := (points collect: [:p | p x]) asSet asSortedCollection.
ys := (points collect: [:p | p y]) asSet asSortedCollection.

pointsCompressed := points collect: [:p |
	{ ((xs indexOf: p x) @ (ys indexOf: p y)). p }
].

rowCount := ys size + 2.
colCount := xs size + 2.

map := Array new: rowCount.
1 to: rowCount do: [:i |
	| cols |
	cols := Array new: colCount.
	cols atAllPut: 0.
	map at: i put: cols.
].

pointsCompressed doWithIndex: [:p :i |
	| pt0 pt1Index pt1 diffx diffy steps dx dy tempPoint |
	pt0 := p at: 1.
	pt1Index := i = pointsCompressed size ifTrue: [ 1 ] ifFalse: [ i + 1 ].
	pt1 :=  (pointsCompressed at: pt1Index) at: 1.
	diffx := (pt1 x) - (pt0 x).
	diffy := (pt1 y) - (pt0 y).
	steps := (diffx = 0 ifTrue: [ diffy ] ifFalse: [ diffx ]) abs.
	dx := diffx sign.
	dy := diffy sign.
	tempPoint := pt0.
	Transcript show: steps printString; cr.
	1 to: steps do: [:index |
		tempPoint := (tempPoint x + dx)@(tempPoint y + dy).
		(map at: ((tempPoint y) + 1)) at: ((tempPoint x) + 1) put: 1.
		]
].

queue := OrderedCollection new.
queue add: 1@1.
(map at: 1) at: 1 put: -1.
directions := (#(-1 0 1) collect: [:x |
	#(-1 0 1) collect: [:y | Point x: x y: y]
]) flatten reject: [:v | v x = 0 and: [v y = 0]].

[queue notEmpty] whileTrue: [
	| p newPoints |
	p := queue removeFirst.
	newPoints := (directions collect: [:x | x + p ])
		select: [:p1 |
			(p1 x >= 1 and: [p1 x <= colCount]) and: 
			(p1 y >= 1 and: [p1 y <= rowCount]) and:
			[(#(1 -1) includes: ((map at: (p1 y)) at: (p1 x))) not]
		].
	newPoints do: [:p0 |
		queue add: p0.
		(map at: (p0 y)) at: (p0 x) put: -1.
	].	
].

pairs := OrderedCollection new.
pointsCompressed do: [:p0 |
	pointsCompressed do: [:p1 |
		| pt0 pt1 |
		pt0 := p0 at: 1.
		pt1 := p1 at: 1.
		(pt0 ~= pt1)
			ifTrue: [
				| xmin ymin xmax ymax inside |
				xmin := pt0 x min: pt1 x.
				ymin := pt0 y min: pt1 y.
				xmax := pt0 x max: pt1 x.
				ymax := pt0 y max: pt1 y.
				inside := true.
				ymin to: ymax do: [:i |
					xmin to: xmax do: [:j |
						((map at: (i + 1)) at: (j + 1)) = -1
							ifTrue: [
								inside := false.
							]
						]
					].
				inside
					ifTrue: [
						| dx dy area item pt0Orig pt1Orig |
						pt0Orig := p0 at: 2.
						pt1Orig := p1 at: 2.
						dx := ((pt0Orig x) - (pt1Orig x)) abs.
						dy := ((pt0Orig y) - (pt1Orig y)) abs.
						dx := dx + 1.
						dy := dy + 1.
						area := dx * dy.
						item := Array with: p0 with: p1 with: area.
						pairs add: item.
					]
			]
	]
].
sortedPairs := pairs sorted: [:a :b | (a at: 3) > (b at: 3)].
Transcript show: ((sortedPairs at: 1) at: 3) printString; cr.