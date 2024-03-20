package main

import (
	"fmt"
	"os"
	"os/exec"

	log "github.com/sirupsen/logrus"
	"github.com/tinkerbell/actions/grub2disk/grub"
)

func main() {
	fmt.Printf("GRUB2Disk - GRUB streamer\n------------------------\n")
	grubInstallPath := os.Getenv("GRUB_INSTALL_PATH")
	grubBlockDevice := os.Getenv("GRUB_DISK")
	filesystemType := os.Getenv("FS_TYPE")

	if _, err := exec.Command("/bin/sh", "-c", "apk add grub").Output(); err != nil {
		log.Info(fmt.Printf("failed to install grub with error %w", err))
	}
	if _, err := exec.Command("/bin/sh", "-c", "apk add grub-bios").Output(); err != nil {
		log.Info(fmt.Printf("failed to install grub-bios with error %w", err))
	}
	if err := grub.MountGrub(grubInstallPath, grubBlockDevice, filesystemType); err != nil {
		log.Fatal(err)
	}
	log.Infof("grub successfully written on [%s]", grubInstallPath)
}
