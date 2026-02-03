import java.io.File

fun List<List<Char>>.findHorizontal(word: List<Char>): Int {
    var reverse = word.reversed()

    return this
        .fold(0) { count, chars ->
            count + chars
                .windowed(size = word.size, step = 1)
                .filter { it.equals(word) || it.equals(reverse) }
                .size
        }
}

fun List<List<Char>>.findVertical(word: List<Char>): Int {
    return this
        .indices
        .map { i -> this.map { it[i] } }
        .findHorizontal(word)
}

fun List<List<Char>>.findRightDiagonal(word: List<Char>): Int {
    var reverse = word.reversed()
    var lastIndex = word.size - 1

    return this
        .subList(0, this.size - lastIndex)
        .foldIndexed(0) { i, count, chars ->
            count + chars
                .subList(0, chars.size - lastIndex)
                .indices
                .map { (0..lastIndex).map { k -> this[i + k][it + k] } }
                .filter { it.equals(word) || it.equals(reverse) }
                .size
        }
}

fun List<List<Char>>.findLeftDiagonal(word: List<Char>): Int {
    return this
        .map { it.reversed() }
        .findRightDiagonal(word)
}

fun List<List<Char>>.findAll(word: List<Char>): Int {
    return (
        this.findHorizontal(word)
            + this.findVertical(word)
            + this.findLeftDiagonal(word)
            + this.findRightDiagonal(word)
        )
}

fun List<List<Char>>.findCrosses(word: List<Char>): Int {
    var reverse = word.reversed()
    var lastIndex = word.size - 1

    return this
        .subList(0, this.size - lastIndex)
        .foldIndexed(0) { i, count, chars ->
            count + chars
                .subList(0, chars.size - lastIndex)
                .indices
                .filter { j ->
                    var right = (0..lastIndex).map { this[i + it][j + it] }
                    var left = (0..lastIndex).map { this[i + it][j + lastIndex - it] }

                    (left.equals(word) || left.equals(reverse))
                        && (right.equals(word) || right.equals(reverse))
                }
                .size
        }
}

File("input").useLines { linesSeq ->
    var lines = linesSeq
        .map { it.trim().toList() }
        .toList()

    var part1 = lines.findAll(listOf('X', 'M', 'A', 'S'))
    var part2 = lines.findCrosses(listOf('M', 'A', 'S'))

    println("Part 1: ${part1}")
    println("Part 2: ${part2}")
}

