# ~/.pythonrc.py
print("loaded pythonrc")

try:
    import numpy as np

    np.set_printoptions(precision=3, suppress=True)
except ImportError:
    pass

try:
    import pandas as pd

    pd.set_option("display.precision", 3)
except ImportError:
    pass


try:
    import polars as pl

    pl.Config.set_float_precision(3)  # digits after the decimal
    pl.Config.set_fmt_float("mixed")
except ImportError:
    pass

try:
    from rich import print
except ImportError:
    pass
