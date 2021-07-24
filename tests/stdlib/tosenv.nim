discard """
  matrix: "--threads"
  joinable: false
  targets: "c cpp"
"""
import os

block: # delEnv
  const dummyEnvVar = "D20210720T144752" # This env var wouldn't be likely to exist to begin with
  doAssert not existsEnv(dummyEnvVar)
  putEnv(dummyEnvVar, "1")
  doAssert existsEnv(dummyEnvVar)  
  delEnv(dummyEnvVar)
  doAssert not existsEnv(dummyEnvVar)
  delEnv(dummyEnvVar) # deleting an already deleted env var
  doAssert not existsEnv(dummyEnvVar)

block: # putEnv
  # raises OSError on invalid input
  doAssertRaises(OSError, putEnv("NIM_TESTS_TOSENV_PUT=DUMMY_VALUE", "NEW_DUMMY_VALUE"))
  doAssertRaises(OSError, putEnv("", "NEW_DUMMY_VALUE"))
  doAssert not existsEnv("")
  doAssert not existsEnv("NIM_TESTS_TOSENV_PUT=DUMMY_VALUE")
  doAssert not existsEnv("NIM_TESTS_TOSENV_PUT")

block:
  doAssert getEnv("NIM_TESTS_TOSENV_NONEXISTENT", "") == ""
  doAssert getEnv("NIM_TESTS_TOSENV_NONEXISTENT", " ") == " "
  doAssert getEnv("NIM_TESTS_TOSENV_NONEXISTENT", "Arrakis") == "Arrakis"

block: # bug #18533
  proc c_getenv(env: cstring): cstring {.importc: "getenv", header: "<stdlib.h>".}
  var thr: Thread[void]
  proc threadFunc {.thread.} = putEnv("foo", "fooVal2")

  putEnv("foo", "fooVal1")
  doAssert getEnv("foo") == "fooVal1"
  createThread(thr, threadFunc)
  joinThreads(thr)
  doAssert getEnv("foo") == $c_getenv("foo")

  doAssertRaises(OSError): delEnv("foo=bar")
