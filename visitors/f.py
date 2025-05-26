l = [1,2,3,4,5]
print(l[-1])



numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

indexesToRemove = [3, 7, 9]

# newNumbers = [elem for i, elem in enumerate(numbers) if i != indexesToRemove]

for i in reversed(range(len(numbers))):
    if numbers[i] in indexesToRemove:
        del numbers[i]

print(numbers)