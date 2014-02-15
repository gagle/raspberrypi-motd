motd
====

#### Message of the Day for the Raspberry Pi ####

<p align="center">
  <img src="https://github.com/gagle/raspberrypi-motd/blob/master/motd.png?raw=true"/>
</p>

Written in pure Bash. No need to install any package. Tested with the Arch Linux ARM distribution.

Download and save the `motd.sh` bash script in the Raspberry Pi. Remember to add execution permissions to the file:

```bash
$ sudo chmod +x motd.sh
```

The following steps may vary depending on the OS.

- Autoexecute the script when the user logs in. There are multiple locations from where you can start the `motd.sh` script, for example using the file `/etc/profile`. Save the `motd.sh` script in the directory `/etc/profile.d` and it will be executed after the login. More about [autostarting scripts](https://wiki.archlinux.org/index.php/Bash#Configuration_file_sourcing_order_at_startup).

- Remove the default MOTD. In Arch Linux ARM you need to remove the `/etc/motd` file.
  
  ```bash
  $ sudo rm /etc/motd
  ```
  
- Remove the "last login" information. In Arch Linux ARM you need to disable the `PrintLastLog` option from the `sshd` service. Edit the `/etc/ssh/sshd_config` file and uncomment the line `PrintLastLog yes`:
  
  ```bash
  $ sudo nano /etc/ssh/sshd_config
  ```
  
  Before:
  
  ```text
  #PrintLastLog yes
  ```
  
  After:
  
  ```text
  PrintLastLog no
  ```
  
  Restart the `sshd` service:
  
  ```bash
  $ sudo systemctl restart sshd
  ```

Note: If you don't see the degree Celsius character correctly (`º`) make sure you have enabled a UTF8 locale ([Arch Linux locales](https://wiki.archlinux.org/index.php/locale)).