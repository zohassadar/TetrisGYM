from pprint import pprint


def generate_next(hi, lo):
    newbit = ((hi & 2) ^ (lo & 2)) << 6
    return newbit | (hi >> 1), ((hi & 1) << 7) | (lo >> 1)


seed_hi, seed_lo = 0, 2

max_rolls = 0
results = {}
hi, lo = seed_hi, seed_lo

while True:
    tmp_hi, tmp_lo = hi, lo
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
results = {key: f"{(value/total)*100:.05f}" for key, value in results.items()}
print("Existing: ")
pprint(results)
print(f"Max rolls: {max_rolls}")
print("")

results = {}
hi, lo = seed_hi, seed_lo

while True:
    tmp_hi, tmp_lo = hi, lo
    for _ in range(5):
        for _ in range(5):
            tmp_hi, tmp_lo = generate_next(tmp_hi, tmp_lo)
        result = tmp_lo & 15
        if result < 10:
            break
    else:
        result = result >> 1
    results[result] = results.get(result, 0) + 1
    hi, lo = generate_next(hi, lo)
    if (seed_hi, seed_lo) == (hi, lo):
        break

total = sum(results.values())
results = {key: f"{(value/total)*100:.05f}" for key, value in results.items()}
print("Proposed:")
pprint(results)
