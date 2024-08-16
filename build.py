import subprocess
import os
import sys

if len(sys.argv) < 2:
  print("Please provide a Godot version to build")
  exit(1)

GODOT_VERSION = sys.argv[1]
SCRIPT_AES256_ENCRYPTION_KEY = os.environ.get("SCRIPT_AES256_ENCRYPTION_KEY")

if GODOT_VERSION == "":
  print("No version of godot specificed, please rerun with a version \"python build.py x.y.z\"")
  exit(1)

subprocess.run(args=[
  "docker",
  "build", 
  "-t", 
  "godot-4.3",
  ".",
  "--build-arg",
  "SCRIPT_AES256_ENCRYPTION_KEY=%s" % SCRIPT_AES256_ENCRYPTION_KEY,
  "--build-arg",
  "GODOT_VERSION=%s" % GODOT_VERSION
], shell=True)

# subprocess.run(["ls", "-l"])