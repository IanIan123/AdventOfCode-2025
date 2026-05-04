| stream input lines games total findMatchingSubsets printMask renderTarget |
Transcript clear.
stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.
lines := input lines.
games := OrderedCollection new.
1 to: lines size do: [:i |
	| items answer buttons answerMask width |
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
	games add: (Array with: answerMask with: buttons asArray with: width).
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
total := 0.
games do: [:game |
	| targetMask buttons width result |
	targetMask := game at: 1.
	buttons := game at: 2.
	width := game at: 3.
	result := findMatchingSubsets value: targetMask value: buttons.
	Transcript show: 'Target: ' , (renderTarget value: targetMask value: width) , (String with: Character lf).
	result do: [:mask |
		| pressed str |
		pressed := (0 to: buttons size - 1)
			select: [:i | (mask bitAnd: (1 bitShift: i)) ~= 0]
			thenCollect: [:i | printMask value: (buttons at: i + 1)].
		str := '* Pressing `'.
		pressed doWithIndex: [:p :i | str := str , p. i < pressed size ifTrue: [str := str , ', ']].
		Transcript show: str , '`.' , (String with: Character lf)].
].