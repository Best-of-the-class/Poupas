package security

import "os/exec"

func IsRooted() bool {
	paths := []string{
		"/system/bin/su",
		"/system/xbin/su",
		"/sbin/su",
	}

	for _, p := range paths {
		if _, err := exec.Command("ls", p).Output(); err == nil {
			return true
		}
	}

	return false
}