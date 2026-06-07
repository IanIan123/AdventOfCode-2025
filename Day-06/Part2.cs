var lines = File.ReadAllLines("input.txt");
var result = Enumerable.Range(0, lines[0].Length)
    .Aggregate(new { total = 0L, result = 0L, op = '+' }, (acc, i) =>
    {
        var op = lines.Last()[i];
        var numStr = string.Join("", lines.SkipLast(1).Select(l => l[i])).Trim();
        var isLast = i == lines[0].Length - 1;

        if (op != ' ')
            acc = acc with { result = op == '+' ? 0 : 1, op = op };

        if (long.TryParse(numStr, out var number))
            acc = acc with { result = acc.op == '+' ? acc.result + number : acc.result * number };

        if (string.IsNullOrEmpty(numStr) || isLast)
            acc = acc with { total = acc.total + acc.result };

        return acc;
    });

Console.WriteLine(result.total);