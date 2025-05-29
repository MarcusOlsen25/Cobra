import subprocess
import time

start_time = time.perf_counter()

# Replace './program' with your actual executable path
subprocess.run(["./program"], check=True)

end_time = time.perf_counter()
elapsed = end_time - start_time

print(f"Execution time: {elapsed:.6f} seconds")
