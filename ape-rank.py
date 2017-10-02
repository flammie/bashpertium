#!/usr/bin/env python3

from sys import argv, exit

if not len(argv) == 3:
    print("Usage:", argv[0], "APEGLOSSES RESULTS")
    exit(1)

outf = open(argv[2], "w")

correct = 0
incorrect = 0
with open(argv[1]) as inf:
    for l in inf:
        print(l)
        apes = l.strip().split('$')
        for ape in apes:
            fields = ape.strip('^').split('/')
            if len(fields) <= 1:
                continue
            surf = fields[0]
            print("[S]urf)", surf)
            for i in range(1, len(fields)):
                print(i, fields[i])
            print("[N]one of above")
            while True:
                resp = input("s, n, 1, 2, 3 ...?")
                if resp.isdigit() and int(resp) <= len(fields):
                    correct += 1
                    print(ape[0], '=', ape[int(resp)], file=outf, sep='', end=' ')
                    break
                elif resp in 'Ss':
                    incorrect += 1
                    print(ape[0], '=!!', ape[0], file=outf, sep='', end=' ')
                    break
                elif resp in 'Nn':
                    incorrect += 1
                    print(ape[0], '=?', file=outf, sep='', end=' ')
                    break
                else:
                    print("?", resp, "?")
        print(file=outf)

print("%f %% (%d / %d)", 100*correct/(correct+incorrect), correct,
        correct + incorrect)
