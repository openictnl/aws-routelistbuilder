# save AWS ip-ranges into openvpn push routelist

Use this bash script to automate the aws ip-ranges json to an openvpn push routelist. </br>
> **Warning**</br>
>This script downloads a .json from a defined url! Be very careful when downloading files from any source on the internet. Use this script at your own risk, we are not responsible for any harm done to your device after using this script. Created files could get deleted (when the parameter is supplied) be aware of this.

## Requirements
This script uses two packages: jq, and ipcalc. These items can be installed via, for example: apt-get

``` shell
apt-get update
apt-get install jq ipcalc
```

### Start the script
The script should be started (after cloning) like:
``` shell
chmod u+x convert.sh
/usr/bin/bash ./convert.sh -o <save/location/path.txt>
```

### Commandline parameters
| Flag | Type | Default | Result |
| ------------- | ------------- | ------------- | ------------- |
| -o | string | ./routelist.txt | The location where the txt file will be stored
| -a | flag | false | When this flag is supplied the current items will be added to the routelist
