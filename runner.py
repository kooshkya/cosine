import random
import math
import time

def calculateDist(x, v):
    n = 8
    term = 1
    expression = 1
    for i in range(1, n):
        term *= -1 / (2 * i * (2 * i - 1))
        term *= x**2
        expression += term
    return expression * v


def runForC(c):
    xList = []
    vList = []
    for i in range(c):
        x = ((random.random() - 0.5) / 0.5) * math.pi
        v = ((random.random() - 0.5) / 0.5) * 16
        xList.append(x)
        vList.append(v)

    s = time.time()

    for i in range(c):
        calculateDist(xList[i], vList[i])

    e = time.time()
    t = e - s
    print(f"c: {c}, t: {t}")
    print(f"average t: {t / c}")

for c in [1000, 10000, 100000, 1000000]:
    runForC(c)
