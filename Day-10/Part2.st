| stream input lines games total findMatchingSubsets printMask renderTarget getTargetMask printButtons iterate reduceCounters halveCounters allCountersNonNegative iterateCache |
Transcript clear.
stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.
lines := input lines.
games := OrderedCollection new.
1 to: lines size do: [:i |
	| items answer buttons answerMask width counters |
	items := (lines at: i) findTokens: ' '.
	answer := items at: 1.
	answer := answer copyFrom: 2 to: answer size - 1.
	width := answer size.
	answerMask := 0.
	answer doWithIndex: [:char :j |
		char = $# ifTrue: [answerMask := answerMask bitOr: (1 << (j - 1))]].
	buttons := items copyFrom: 2 to: items size - 1.
	buttons := buttons collect: [:each | each copyFrom: 2 to: each size - 1].
	buttons := buttons collect: [:each |
		| mask |
		mask := 0.
		(each findTokens: ',') do: [:x | mask := mask bitOr: (1 << x asInteger)].
		mask].
	counters := items at: items size.
	counters := counters copyFrom: 2 to: counters size - 1.
	counters := ((counters findTokens: ',') collect: [:x | x asInteger]) asArray .
	games add: (Array with: answerMask with: buttons asArray with: width with: counters).
].
findMatchingSubsets := [:targetMask :buttons |
	| numButtons matchingMasks |
	numButtons := buttons size.
	matchingMasks := OrderedCollection new.
	0 to: (1 bitShift: numButtons) - 1 do: [:subset |
		| state |
		state := 0.
		0 to: numButtons - 1 do: [:i |
			(subset bitAnd: (1 bitShift: i)) ~= 0
				ifTrue: [state := state bitXor: (buttons at: i + 1)]].
		state = targetMask ifTrue: [matchingMasks add: subset]].
	matchingMasks
].
printMask := [:m |
	| indices str |
	indices := (0 to: 31) select: [:b | (m bitAnd: (1 bitShift: b)) ~= 0].
	str := '{'.
	indices doWithIndex: [:b :i | str := str , b printString. i < indices size ifTrue: [str := str , ', ']].
	str , '}'
].
renderTarget := [:m :width |
	| str |
	str := '['.
	1 to: width do: [:i | str := str , ((m bitAnd: (1 bitShift: i - 1)) ~= 0 ifTrue: ['#'] ifFalse: ['.'])].
	str , ']'
].
getTargetMask := [:counters |
	| targetMask |
	targetMask := 0.
	counters doWithIndex: [:count :j |
		count odd ifTrue: [targetMask := targetMask bitOr: (1 << (j - 1))]].
	targetMask.
].
halveCounters := [:counters |
	counters collect: [:count | count / 2].
].
allCountersNonNegative := [:counters |
	counters allSatisfy: [:counter | counter >= 0]
].
printButtons := [:mask :buttons |
    | pressed str |
    pressed := (0 to: buttons size - 1)
        select: [:i | (mask bitAnd: (1 bitShift: i)) ~= 0]
        thenCollect: [:i | printMask value: (buttons at: i + 1)].
    str := '* Pressing '.
    pressed doWithIndex: [:p :i | str := str , p. i < pressed size ifTrue: [str := str , ', ']].
    Transcript show: str , '.' , (String with: Character lf)
].
reduceCounters := [:counters :buttons :mask |
	counters collectWithIndex: [:count :i |
		| decrements |
		decrements := 0.
		0 to: buttons size - 1 do: [:j |
			(mask bitAnd: (1 bitShift: j)) ~= 0 ifTrue: [
				((buttons at: j + 1) bitAnd: (1 bitShift: (i - 1))) ~= 0 ifTrue: [
					decrements := decrements + 1
				]
			]
		].
		count - decrements
	]
].
iterate := nil.
iterateCache := Dictionary new.

iterate := [:counters :buttons :width |
    | key |
    key := { counters. buttons. width }.

    iterateCache
        at: key
        ifAbsentPut: [
            (counters allSatisfy: [:c | c = 0])
                ifTrue: [ 0 ]
                ifFalse: [
                    | results newCounters targetMask minPresses |
                    minPresses := Float infinity.
                    targetMask := getTargetMask value: counters.
                    results := findMatchingSubsets value: targetMask value: buttons.
                    results do: [:mask |
                        | presses |
                        presses := mask bitCount.
                        newCounters := reduceCounters value: counters value: buttons value: mask.
                        (allCountersNonNegative value: newCounters)
                            ifTrue: [
                                newCounters := halveCounters value: newCounters.
                                minPresses := minPresses min:
                                    (presses + (2 * (iterate value: newCounters value: buttons value: width))).
                            ].
                    ].
                    minPresses
                ]
        ]
].
total := 0.
games do: [:game |
	| buttons counters width result |
	buttons := game at: 2.
	width := game at: 3.
	counters := game at: 4.
	Transcript show: 'Counters: ' , counters  , (String with: Character lf).
	result := iterate value: counters value: buttons value: width.
	Transcript show: 'Result: ', result, (String with: Character lf).
	total := total + result.
].
Transcript show: 'Total: ', total.