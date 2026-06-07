| input ranges countMatches total stream |

countMatches := [:code | 
    | parts num1 num2 counter str mid left right numInvalid |
    parts := code findTokens: '-'.
    num1 := parts first asNumber.
    num2 := parts second asNumber.
    counter := num1.
    numInvalid := 0.
    [counter <= num2] whileTrue: [
        str := counter printString.
        (str size even) ifTrue: [
            mid := str size / 2.
            left := str copyFrom: 1 to: mid.
            right := str copyFrom: mid + 1 to: str size.
            (left = right) ifTrue: [
                numInvalid := numInvalid + counter
            ]
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