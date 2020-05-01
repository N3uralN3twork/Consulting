from doepy import build


levels = {"Pressure": [40, 55, 70],
          "Temperature": [290, 320, 350],
          "Flow-rate": [0.2, 0.4],
          "Time": [5, 8]}
levels

# Number of entries = 3*3*2*2 = 36 entries for 1 replicate
full_factorial = build.build_full_fact(levels)

# Check for 36 entries
len(full_factorial) # 36


