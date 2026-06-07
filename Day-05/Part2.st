| input stream total rangesAllStr rangesAll iterate mergedAll  |

stream := FileStream readOnlyFileNamed: 'input-day.txt'.
input := stream contentsOfEntireFile.
stream close.

pos := input indexOfSubCollection: (String lf, String lf).

rangesAllStr := ((input copyFrom: 1 to: pos - 1) lines).
rangesAll := rangesAllStr collect: [:r |
    ((r findTokens: '-') collect: [:each | each asInteger]) asSortedCollection asArray
].

iterate := nil.
iterate := [:ranges |
	| merged mergedIndexes |
	merged := OrderedCollection new.
	mergedIndexes := OrderedCollection new.
	1 to: ranges size do: [:i |
		| range low high |
		((mergedIndexes includes: i) not)
			ifTrue: [
				range := ranges at: i.
				low := range at: 1.
				high := range at: 2.
				1 to: ranges size do: [:j |
					| range2 lowM highM overlap |
					(i ~= j and: [(mergedIndexes includes: j) not])
						ifTrue: [
							range2 := ranges at: j.
							lowM := range2 at: 1.
							highM := range2 at: 2.
							overlap := (low >= lowM and: [low <= highM])
								or: [high <= highM and: [high >= lowM]]
								or: [low < lowM and: [high > highM]].
							(overlap)
								ifTrue: [
									mergedIndexes addAll: {i. j}.
									merged add: {low min: lowM. high max: highM}.
								]
						]
				].
				((mergedIndexes includes: i) not)
					ifTrue: [ merged add: range ].
			]
	].
	(mergedIndexes isEmpty)
		ifTrue: [ merged ]
		ifFalse: [ iterate value: merged ]
].

mergedAll := iterate value: rangesAll.

total := mergedAll inject: 0 into: [:sum :range | 
	sum + ((range at: 2) - (range at: 1)) + 1
].

Transcript show: 'Total: ', total printString; cr.