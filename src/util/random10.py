from pprint import pprint

def generate_next(hi, lo):
    newbit = ((hi & 2) ^ (lo & 2)) << 6
    return newbit | (hi >> 1), ((hi & 1) << 7) | (lo >> 1)


seed_hi = 0x00
seed_lo = 0x02

max_rolls = 0
results = {}
hi, lo = seed_hi, seed_lo

while True:
    tmp_hi = hi
    tmp_lo = lo
    rolls = 0
    while True:
        rolls += 1
        for _ in range(5):
            tmp_hi, tmp_lo = generate_next(tmp_hi, tmp_lo)
        result = tmp_lo & 15
        max_rolls = max(max_rolls, rolls)
        if result < 10:
            break
    results[result] = results.get(result, 0) + 1
    hi, lo = generate_next(hi, lo)
    if (seed_hi, seed_lo) == (hi, lo):
        break

total = sum(results.values())
results = {key: f'{total/value:02f}' for key, value in results.items()}
print("Existing: ")
pprint(results)
print(f"Max rolls: {max_rolls}")
print("")

max_rolls = 0
results = {}
hi, lo = seed_hi, seed_lo

while True:
    tmp_hi = hi
    tmp_lo = lo
    i = 0
    for _ in range(5):
        i += 1
        for _ in range(5):
            tmp_hi, tmp_lo = generate_next(tmp_hi, tmp_lo)
        result = tmp_lo & 15
        max_rolls = max(max_rolls, i)
        if result < 10:
            break
    else:
        result = result >> 1
    results[result] = results.get(result, 0) + 1
    hi, lo = generate_next(hi, lo)
    if (seed_hi, seed_lo) == (hi, lo):
        break

total = sum(results.values())
results = {key: f'{total/value:02f}' for key, value in results.items()}
print("Proposed:")
pprint(results)
print(f"Max rolls: {max_rolls}")
