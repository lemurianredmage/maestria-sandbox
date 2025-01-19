# IBM Power 8 Server Configuration

The following is a set of instruction to configure an IBM POWER8 server with an ubuntu server distribution.

## Install (or reinstall) Ubuntu Server

- Go to [Ubuntu Server 20.04.1 LTS (Focal Fossa)](https://cdimage.ubuntu.com/ubuntu-legacy-server/releases/20.04/release/).
  - Locate and download **Legacy server install image -> PowerPC64 Little-Endian legacy server install image**.
- Follow [these instructions](https://ubuntu.com/tutorials/create-a-usb-stick-on-ubuntu#1-overview) to create a bootable USB.
- Connect your USB into the server and reboot it.
- Select boot option and follow on-screen instructions.
- This process will create a root user.

## Create a new user

- Connect to server via ssh with an admin user `ssh username@server-ip-address` or go directly to the server terminal
- Enter password
- Type `adduser new-user` and follow on-screen instructions
  - Where **new-user** is the name of the new user
- If user needs to have sudo permissions, run `usermod -aG sudo new-user`
- To test the new user, run:
  - Change to the new user with `su - new-user`
  - Run `sudo new-user` to check for superuser permissions
  - Running `sudo ls -la /root` will display **/root** directory files that are only available for superusers.

## Enable SSH

- Install openSSH
  ```bash
  sudo apt update
  sudo apt install openssh-server -y
  ```
- Start and enable SSH
  ```bash
  sudo systemctl start ssh
  sudo systemctl enable ssh
  ```
- Check SSH status and confirm is running
  ```bash
  sudo systemctl status ssh
  ```
- Configure Firewall
  ```bash
  sudo ufw allow ssh
  sudo ufw enable
  ```
- To verify connection go to another machine, open up a terminal and type `ssh username@server-ip-address`

## References

- [IBM POWER8](https://www.redbooks.ibm.com/redbooks.nsf/pages/power8)
- [IBM POWER8 Whitepapers](https://www.ibm.com/support/pages/sites/default/files/inline-files/$FILE/POWER8_RAS_whitepaper_POW03133USEN.PDF)
- [Ubuntu Release Cycle](https://ubuntu.com/about/release-cycle)
