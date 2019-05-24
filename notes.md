Queries 11 and 17 have been adjusted from their forms in the pdf.
They select from all three relations, rather than just onektup and tenktup1,
because they both have "tenktup2.unique1" in their where clauses.

Queries 26 and 27 have been changed to use unique2.
(The 10001 and 74 values have been swapped).
This is due to a presumed typo in the benchmark pdf, where
unique2 is given as 74, but all the relations have >74 rows, so this
is a guaranteed collision on unique2=74.

1x
2x
3
4
5x
6x
7x
8x
9x
10x
11x
12
13
14
15x
16x
17x
18x
19x
20x
21
22
23
24
25
26
27
28
29
30
31
32
