10/25/2023

This config creates three ec2 instances (meant to be used for a MariaDB or other cluster type).
Check variables.tf!!!

No DNS is set at this level.  These servers don't use Elastic IP addresses.

Notes:
Volumes set to delete on termination.
auto-recovery behavior defaults to restart
No burst balance alarms on the volumes because gp3 volumes don't use that construct.


