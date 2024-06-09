#!/usr/bin/python3

import subprocess
import re

def check_device_unallocated():
    # Run the btrfs fi usage command and capture its output
    output = subprocess.check_output(['btrfs', 'fi', 'usage', '/']).decode('utf-8')
    
    # Find the line containing "Device unallocated" using regex
    match = re.search(r'Device unallocated:\s+(\d+\.\d+)(\w+)', output)
    
    if match:
        env_vars = {'DISPLAY': ':0',
                    'DBUS_SESSION_BUS_ADDRESS': 'unix:path=/run/user/1000/bus'}
        
        number = float(match.group(1))
        unit = match.group(2)
        
        if unit == 'MiB' or (unit == 'GiB' and number <= 10):
            result = subprocess.run(['notify-send', 'BTRFS Alert', f"Alert: Device unallocated space is {number} {unit}"], env=env_vars, capture_output=True, text=True)
            # print(result.stdout)
            # print(result.stderr)
            # You can add additional actions here, like sending an email or logging the alert
        else:
            result = subprocess.run(['notify-send', 'BTRFS Normal', f"Device unallocated space is within acceptable limits: {number} {unit}"], env=env_vars, capture_output=True, text=True)
    else:
        result = subprocess.run(['notify-send', 'BTRFS Error', "Could not find 'Device unallocated' in the output."], env=env_vars, capture_output=True, text=True)
# Run the check
check_device_unallocated()