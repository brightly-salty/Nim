discard """
  output: '''1
0'''
joinable: false
"""

## GOAL: Allow this code:

type
  E1 = enum
    value1,
    value2
  E2 = enum
    value1,
    value2 = 4

const
  Lookuptable = [
    E1.value1: "1",
    value2: "2"
  ]

when false:
  const
    Lookuptable: array[E1, string] = [
      value1: "1",
      value2: "2"
    ]


proc p(e: E1): int =
  echo ord e


let v = p value2 # ERROR: ambiguous!
# (value2|value2)  nkClosedSymChoice -> nkSym

proc x(p: int) = discard
proc x(p: string) = discard

proc takeCallback(param: proc(p: int)) = discard

takeCallback x

echo ord v
