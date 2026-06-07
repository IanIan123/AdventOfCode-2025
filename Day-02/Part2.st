| input ranges countMatches total stream splitIntoChunks |

splitIntoChunks := [:string :size |
    (1 to: string size by: size) collect: [:i |
        string copyFrom: i to: (i + size - 1 min: string size)
    ]
].

countMatches := [:code | 
    | parts num1 num2 counter str numInvalid chunks allSame found |
    parts := code findTokens: '-'.
    num1 := parts first asNumber.
    num2 := parts second asNumber.
    counter := num1.
    numInvalid := 0.
    [counter <= num2] whileTrue: [
	    found := false.
        str := counter printString.
        1 to: str size - 1 do: [:counter2 |
    		found ifFalse: [
                chunks := splitIntoChunks value: str value: counter2.
                allSame := chunks allSatisfy: [:chunk | chunk = chunks first].
                allSame ifTrue: [
                    numInvalid := numInvalid + counter.
                    found := true.
                ].
            ].
        ].
        counter := counter + 1
    ].
    numInvalid
].

stream := FileStream readOnlyFileNamed: 'input.txt'.
input := stream contentsOfEntireFile.
stream close.

ranges := input findTokens: ','.
total := 0.
ranges do: [:range |
    total := total + (countMatches value: range)
].
Transcript show: 'Total: ', total printString; cr.