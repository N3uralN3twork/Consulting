import numpy as np
a_dict = {np.nan: None, 1: 5.0, 2: 4.4, 3: 3.4, 4: 2.0, 5: 1.0}

try:

    print(a_dict[np.nan])

    print(a_dict[2])

    print(a_dict[4])

except KeyError:

    print("The key does not exist!")
