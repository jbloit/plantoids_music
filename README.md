# plantoids_music
Supercollider patches for plantoids installation, running on a raspberryPi with a PiSound audio interface.

# Installation

## Install the Prynth image
- Install latest image from the [Prynth project](https://prynth.github.io/create/create.html)
for older versions, see [images archive](http://idmil.org/pubfiles/software/prynth/)
- To start making noise, launch the Rpi, connect with an ethernet cable and open a browser to http://raspberrypi.local:3000
- select one of the patches in the menu and run it by clicking on the run button in the browser

## Install PiSound driver
Follow instructions from [this page](https://www.blokas.io/pisound/docs/Software/).
It boils down to running:

```bash
curl https://blokas.io/pisound/install-pisound.sh | sh
```

(Internet connexion needed).


## Plantoid patches installation

The subfolders in the [copyToRaspberryPi](copyToRaspberryPi) folder are to be copied to the raspberryPi, once the PiSound is installed. For moving files around between your computer and the pi, the easiest is probably through [FileZilla](https://www.raspberrypi.org/documentation/remote-access/ssh/sftp.md).

### clicks.sh
This is a custom script that will launch a patch called *1.scd* when user clicks the PiSound button once, *2.scd* when user clicks the button twice etc.
Copy the script to ```/usr/local/pisound/scripts/pisound-btn/clicks.sh``` and be sure to grant executable permissions

```bash
sudo chmod +x clicks.sh
```
Got the script from [here](https://github.com/poetaster/pisound-prynth/blob/master/usr/local/pisound/scripts/pisound-btn/clicks.sh)

### Map the button actions to the clicks.sh script
Either see instructions from [here](https://www.blokas.io/pisound/docs/The-Button/)
or just replace the [pisound.conf](copyToRaspberryPi/copy_to_etc/pisound.conf) file at */etc/pisound.conf*.

### Copy the actual Supercollider patches
Copy all the files from [copy_to_supercolliderFiles](copyToRaspberryPi/copy_to_supercolliderFiles) to the */home/pi/prynth/server/public/supercolliderfiles/* folder on the pi.
The contents of the *soundfiles* folder should be copied in */home/pi/prynth/server/public/soundfiles/* on the pi.

 
