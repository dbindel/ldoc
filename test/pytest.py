#!/usr/bin/env python
#ldoc

##
# ---
# title: "Hello, Quarto"
# format: 
#   pdf:
#     documentclass: article
# ---

##
# ## Code Cell
#
# Here is a Python code cell:

import os
os.cpu_count()

#ldoc off

# This is after the main document, should get ignored
print(os.cpu_count())
