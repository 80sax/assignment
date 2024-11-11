import unittest
import subprocess
import re

class Test_Crosstrack_error(unittest.TestCase):

  MAX_SIM_STEPS = 250
  MAX_CROSSTRACK_ERROR = 1.0
  SIMS_PATH = "/gem_ws/src/POLARIS_GEM_e2/polaris_gem_drivers_sim/"

  def _test_sim(self, script):
    SCRIPT_NAME = script.split('/')[-1]
    print(F"\nRunning {SCRIPT_NAME}")
    process = subprocess.Popen(["python3", "-u", script], stdout=subprocess.PIPE, text=True)
    
    try:
      steps = 0
      for line in process.stdout:
        print(line.strip())
        match = re.search(r"([\d\.-]+)", line)
        crosstrack_error_value = float(match.group(1))
        self.assertLessEqual(abs(crosstrack_error_value), self.MAX_CROSSTRACK_ERROR)

        steps += 1
        if steps == self.MAX_SIM_STEPS:
          break
    finally:
      print(f"Stopping {SCRIPT_NAME} simulation...")
      process.stdout.close()
      process.terminate()
      process.wait()
    

  def test_pure_pursuit(self):
    script = "/gem_ws/src/POLARIS_GEM_e2/polaris_gem_drivers_sim/gem_pure_pursuit_sim/scripts/pure_pursuit_sim.py"
    self._test_sim(script)


  #def test_error_sim(self):
  #  script = "/gem_ws/src/POLARIS_GEM_e2/polaris_gem_drivers_sim/gem_pure_pursuit_sim/scripts/error_sim.py"
  #  self._test_sim(script)


if __name__ == "__main__":
  unittest.main()