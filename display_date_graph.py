from datetime import datetime
import copy


# read file
def readfile(file_name="time.log"):
    with open(file_name) as f:
        dates = [s.strip() for s in f.readlines()]
    return dates

# calc diff time
lines = []
lines = readfile()
next_date = datetime.strptime("00:00:00", '%H:%M:%S')
prev_date = datetime.strptime("00:00:00", '%H:%M:%S')
date_differents = []

for s in lines:
    next_date = datetime.strptime(s, '%H:%M:%S')
    # comp
    date_different = next_date - prev_date
    date_differents.append(date_different)
    print(date_different)
    prev_date = copy.deepcopy(next_date)

del(date_differents[0:1])



