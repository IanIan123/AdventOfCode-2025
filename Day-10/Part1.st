| stream input lines games total |

Transcript clear.

stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.

lines := input lines.

games := OrderedCollection new.
1 to: (lines size) do: [:i |
	| items answer buttons answerMask |
	items := ((lines at: i) findTokens: ' ').
	answer := items at: 1.
	answer := answer copyFrom: 2 to: (answer size - 1).
	answerMask := 0.
	answer doWithIndex: [:char :j |
		char = $# ifTrue: [answerMask := answerMask bitOr: (1 << (j - 1))]].
	answer := answerMask.
	buttons := items copyFrom: 2 to: (items size - 1).
	buttons := buttons collect: [:each | each copyFrom: 2 to: (each size - 1) ].
	buttons := buttons collect: [:each | 
    		| mask |
		mask := 0.
		(each findTokens: ',') do: [:x | mask := mask bitOr: (1 << x asInteger)].
		mask].
	games add: (Array with: answer with: buttons asArray).
].

total := 0.

games do: [:game |
 	| targetMask buttons best n |
	targetMask := game at: 1.
	buttons := game at: 2.
	n := buttons size.
	best := SmallInteger maxVal.
	0 to: (1 << n) - 1 do: [:subset |
		| state |
		state := 0.
		0 to: n - 1 do: [:i |
			| bitSet |
			bitSet := (subset bitAnd: (1 << i)) ~= 0.
			bitSet ifTrue: [state := state bitXor: (buttons at: i + 1)].
		].
		state = targetMask ifTrue: [
			| buttonCount |
			buttonCount := subset bitCount.
			best := best min: buttonCount]
		].
	total := total + best
].

Transcript show: total.