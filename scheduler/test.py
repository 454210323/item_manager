from datetime import datetime, time

end_day = "2024-07-07"
a = datetime.combine(datetime.fromisoformat(end_day), time(23, 59, 59))
print(a)
