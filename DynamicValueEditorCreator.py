from DynamicValuesEditor import DynamicValue, DynamicValuesEditor


dvs = [DynamicValue('/first/gain', 0, 100), DynamicValue('/first/freq', 1000, 2000)]
ed = DynamicValuesEditor(dvs, '127.0.0.1', 6449) 