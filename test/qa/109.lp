import math

(print @math.pi)

s = 0.0
for i in range(1000000):
    s += 1.0 / ((i + 1) * (i + 1))

(print @s)

term1 = 0.0
for i in range(100000):
    term1 += 1.0 / ((4 * i + 1) * (4 * i + 3))

term2 = 0.0
for i in range(100000):
    term2 += 1.0 / ((2 * i + 1) * (2 * i + 2))

(print @term1)
(print @term2)
