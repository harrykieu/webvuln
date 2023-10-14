import platform
import subprocess
import tempfile
import os 
from pathlib import Path
import datetime
from time import sleep
import pytz

# The root path of the project
ROOTPATH = Path(__file__).parent.parent.parent

def multiprocess(result, *processes):
    """Run multiple processes and write the result to a file.

    For each process, the output and error are written to a temporary file. Those files are then read and written to a single file specified by the `result` parameter. The result is a boolean value indicating whether all processes are run successfully. If any process fails, the function will return False and the `result` file will not be created.

    @param `result`: The file to write the result to.
    @param `processes`: A list of processes to run. Each process is a string.
    """
    for p in processes:
        if type(p) != str:
            raise TypeError("Process must be a string")
    # To maintain the order of the subprocesses
    subprocessList = []
    for p in processes:
        try:
            p_args = p.split(' ')
            tempf = tempfile.TemporaryFile()
            try:
                sp = subprocess.Popen(p_args, stdout=tempf, stderr=tempf, shell=True)
                pollRes = sp.poll()
                while pollRes == None:
                    pollRes = sp.poll()
            except sp.stderr:
                print("Error in running process: " + p)
                tempf.close()
                return False
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

def log(data, type):
    """Log data to a file.

    @param `data`: The data to be logged.
    @param `type`: The type of the data: `ERROR`, `INFO`, `WARNING`, or `DEBUG`.
    """
    if type not in ["ERROR", "INFO", "WARNING", "DEBUG"]:
        raise ValueError("Invalid log type")
    if not data:
        raise ValueError("Empty data")
    if platform.system() == "Windows":
        logFolder = "\\logs"
        logFile = "\\log.txt"
        logLocation = f'{logFolder}{logFile}'
    else:
        logFolder = "/logs"
        logFile = "/log.txt"
        logLocation = f'{logFolder}{logFile}'
    if not os.path.exists(f'{ROOTPATH}{logFolder}'):
        os.mkdir(f'{ROOTPATH}\\{logFolder}')
    if not os.path.exists(f'{ROOTPATH}{logLocation}'):
        # Create the log file
        open(f'{ROOTPATH}{logLocation}', "x")
        with open(f'{ROOTPATH}{logLocation}', "a") as f:
            f.write("[INFO] Log file created\n")
        f.close()
    try:
        # Convert UTC time to GMT+7 timezone
        tz = pytz.timezone('Asia/Bangkok')
        now = datetime.datetime.utcnow().replace(tzinfo=pytz.utc).astimezone(tz)
        with open(f'{ROOTPATH}{logLocation}', "a") as f:
            f.write(f'{now} [{type}] {data}\n')
        f.close()
    except:
        raise RuntimeError("Failed to write to log file")
