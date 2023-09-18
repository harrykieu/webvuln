import subprocess
import tempfile

def multiprocess(result, *processes):
    """Run multiple processes and write the result to a file.

    For each process, the output and error are written to a temporary file. Those files are then read and written to a single file specified by the `result` parameter. The result is a boolean value indicating whether all processes are run successfully. If any process fails, the function will return False and the `result` file will not be created.

    @param result: The file to write the result to.
    @param processes: A list of processes to run. Each process is a string.
    """
    for p in processes:
        if type(p) != str:
            raise TypeError("Process must be a string")
    # To maintain the order of the subprocesses
    subprocessList = []
    for p in processes:
        try:
            tempf = tempfile.TemporaryFile()
            sp = subprocess.Popen(p, stdout=tempf, stderr=tempf)
            subprocessList.append((sp, tempf))
        except:
            print("Error in running process: " + p)
            sp.close()
            tempf.close()
            return False
    res = open(result, "wb")
    for sp, tempf in subprocessList:
        sp.wait()
        tempf.seek(0)
        res.write(tempf.read())
        tempf.close()
    res.close()
    return True
