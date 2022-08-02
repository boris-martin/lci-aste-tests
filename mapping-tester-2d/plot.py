from re import M
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

dataset = pd.read_csv('test-statistics-no-rbf.csv', delimiter=',')
#print(dataset['mesh A'])

#resolutions = np.array([0.5, 0.25, 0.1, 0.05, 0.01])

# Extract list of meshes
in_meshes = set()
resolutions = set()
for x in dataset['mesh A']:
    in_meshes.add(x)
    # Assumption: name is coarse_[number]
    res = x[7:]
    resolutions.add(res)

# Convert resolutions to numpy
resolutions = np.array(sorted(list(resolutions)))

# Extract list of mappings
mappings = set()
for x in dataset['mapping']:
    mappings.add(x)

print("Dataset length: ", len(dataset))
print("Found resolutions: \n", resolutions)
print("Found mappings: \n", mappings)

# Build plottable data: each mapping has a set of values (L² error here)
values = {mapping:{} for mapping in mappings}
for row in range(len(dataset)):
    values[dataset['mapping'][row]][dataset['mesh A'][row]] = dataset['relative-l2'][row]

print("Values dictionary:", values)

# Convert from dictionnary to np array for each mapping
values_np = {mapping:np.zeros((len(resolutions))) for mapping in mappings}
for mapping in mappings:
    print(list(values[mapping].keys()))
    for i, res in enumerate(resolutions):
        values_np[mapping][i] = values[mapping]['coarse_' + str(res)]

# Plotting
for mapping in mappings:
    plt.plot(resolutions, values_np[mapping], label=mapping)

plt.title('Accuracy of different mappings')
plt.ylabel('Mean quadratic error')
plt.xlabel('Mesh resolution')
plt.legend()
plt.show()
