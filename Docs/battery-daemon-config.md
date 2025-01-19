# Configure Battery Daemon

The following is a set of instruction to configure the battery daemon (upower) for Ubuntu server.

## Steps
- Check if service is installed with `systemctl status upower.service`
  - If error is thrown, follow next steps.
  - If it displays information, nothing else needs to be done.
- Update apt packages with `sudo apt update`
- Install upower with `sudo apt install upower`
- Start the service with `sudo systemctl start upower.service`
- Enable it to start on boot with `sudo systemctl enable upower.service`
- Check status again with `systemctl status upower.service`
- It should display information.
