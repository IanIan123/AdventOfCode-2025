using System.Numerics;

int total = File.ReadAllLines("input.txt").Sum(line =>
{
    var items = line.Split(' ');
    
    int targetMask = items[0][1..^1]
        .Select((c, i) => c == '#' ? (1 << i) : 0)
        .Aggregate(0, (mask, bit) => mask | bit);
    
    int[] buttons = items[1..^1]
        .Select(b => b[1..^1].Split(',')
            .Select(int.Parse)
            .Aggregate(0, (mask, x) => mask | (1 << x)))
        .ToArray();

    int n = buttons.Length;
    return Enumerable.Range(0, 1 << n)
        .Where(subset => buttons
            .Select((btn, i) => (subset & (1 << i)) != 0 ? btn : 0)
            .Aggregate(0, (state, btn) => state ^ btn) == targetMask)
        .Min(subset => (int)BitOperations.PopCount((uint)subset));
});

Console.WriteLine(total);