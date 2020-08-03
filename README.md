# AWSdynamicSecurityGroupUpdate

This is a simple script that I created in order to help me update AWS Security Group rules for SSH to remote instances from my dynamic public IP.

You can change the protocol and port by passing them as script arguments `$1` and `$2`, respectively.

You can also undo the operation by passing script argument `undo` as `$1`, alternatively with `$2` and `$3` as the protocol and port.

You can specify the names of security groups in `groups.txt`, which always takes precedence.

If `groups.txt` is not found, the groups affected will be the ones matching the /24 of your current IP range.

## Example

By running with default options, if your public IP is 1.2.3.4, the script will gather all the security group names with a TCP port 22 ALLOW rule from 1.2.3.0/24 and try to add an additional rule for 1.2.3.4.

Yes, this means that at some point you will have to go back into the console and clean up old entries, because I didn't bother adding the additional logic of including that into the script.

Feel free to fork or submit pull requests if you want to contribute and make this script better.

### Caveats

If not running in default VPC, I believe you will have to modify the aws command line to add the name of the VPC.

Bad practice, I know, but initially this script was just for me to use with my personal instances before I tweaked it for wider use.
